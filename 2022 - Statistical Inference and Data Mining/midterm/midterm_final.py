# Linear regression/ridge/lasso/kernel task
# BY: Dan Ben Ami
#     Elad Sofer
# Date: 1/1/23

#imports
import numpy as np
import pandas as pd
from sklearn.model_selection import GridSearchCV
from sklearn.kernel_ridge import KernelRidge
from sklearn import linear_model
import statsmodels.api as sm
import seaborn as sns
import glob
import os
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.impute import SimpleImputer


def unnecessary_features_check(df):
    ''' simple data processing and simple Linear regression for checking in the summary which
     features has high values in the " P>|t|" column, these features are unnecessary for the regression '''

    df = df[df['Life expectancy'].notna()]  # drop lines with NaN in Life expectancy
    # country embedding
    country_embd = df.copy()
    country_embd = country_embd.sort_values(by=['Life expectancy'], ascending=False)
    counties = country_embd['Country'].unique().tolist()
    country_emb_map = {}
    for i, country in enumerate(counties):
        country_emb_map[country] = i
    df["Country"] = df["Country"].map(country_emb_map)

    df.Status = [0 if stat == "Developed" else 1 for stat in df.Status]  # make Status binary, Developed=1, Developing=0
    df["Status"] = df["Status"].fillna(0)

    imp_median = SimpleImputer(missing_values=np.nan, strategy='median')
    df[:] = imp_median.fit_transform(df)

    for col in df.columns:
        if col == "Life expectancy" or col == "Status":
            continue
        df[col] = (df[col] - df[col].mean()) / df[col].std()
    y_train = df['Life expectancy']
    x_train = df.drop(['Life expectancy'], axis=1)
    x_train = sm.add_constant(x_train)

    # fit linear regression model
    model = sm.OLS(y_train, x_train).fit()

    # view model summary
    print(model.summary())


def data_processing(df, train_flag=True, country_emb_map=None):
    df.columns = [name.strip() for name in df.columns]  # remove any whitespace at the start and/or end of columns names

    df.drop(['BMI', 'Population', 'thinness  1-19 years', 'thinness 5-9 years', 'Income composition of resources',
             'Hepatitis B'], axis=1, inplace=True) # drop irrelevant columns (decided by sm.OLS p value after summary)

    if train_flag:
        df = df[df['Life expectancy'].notna()]  # drop lines with NaN in Life expectancy
        # country embedding
        country_embd = df.copy()
        country_embd = country_embd.sort_values(by=['Life expectancy'], ascending=False)
        counties = country_embd['Country'].unique().tolist()
        country_emb_map = {}
        for i, country in enumerate(counties):
            country_emb_map[country] = i
    else:
        df.drop(["ID"], axis=1, inplace=True)

    df["Country"] = df["Country"].map(country_emb_map)

    df.Status = [0 if stat == "Developed" else 1 for stat in df.Status]  # make Status binary, Developed=1, Developing=0
    df["Status"] = df["Status"].fillna(0)

    imp_median = SimpleImputer(missing_values=np.nan, strategy='median') # filling missing cells with the median of the specific feature over all the data
    df[:] = imp_median.fit_transform(df)

    for col in df.columns:  # standard normalization
        if col == "Life expectancy" or col == "Status":
            continue
        df[col] = (df[col] - df[col].mean())/df[col].std()

    return df, country_emb_map


def check_outliers(df: pd.DataFrame, target_col):
    for feature in df.columns:
        if feature == target_col:
            continue
        # Plotting before the outliers removal
        sns.pairplot(df[[feature, "Life expectancy"]])
        plt.show()
        input("Press Enter to continue to next feature...")


def remove_outliers(df):
    # These values are as a result that Ran normalized diffrently
    filter_mapper = {
        # "Adult Mortality": (df['Life expectancy'] < 0.22) & (df["Adult Mortality"] < -0.6),
        "infant deaths": df["infant deaths"] > 2,
        # "percentage expenditure": df["percentage expenditure"] > 6,
        # "under-five deaths": df["under-five deaths"] > 3,
        # "GDP": df["GDP"] > 6,
        "Schooling": (df["Schooling"] < -3.3),
        "Measles": (df["Measles"] > 9.5)}


    #  "dipheteria", "GDP"
    for feature in filter_mapper.keys():
        # Plotting before the outliers removal
        sns.pairplot(df[[feature, "Life expectancy"]])
        plt.savefig("outliers_figs/"+feature+"_before.png", dpi=500)
        plt.show()
        outliers_filter = filter_mapper[feature]

        x_not_outliers = df[~outliers_filter]

        # the normal data
        x_not_outliers_f1 = x_not_outliers[feature]
        y_not_outliers_f1 = x_not_outliers['Life expectancy']

        # outliers' labels
        y_outliers = df.loc[outliers_filter, 'Life expectancy']

        # Train the inverse function upon all the rest of the data (not the outliers)
        f_1_model = sm.OLS(x_not_outliers_f1, y_not_outliers_f1).fit()


        # receive the y and do the inverse f^-1(y) = x
        df.loc[outliers_filter, feature] = f_1_model.predict(y_outliers)

        # Plotting after the outliers removal
        sns.pairplot(df[[feature, "Life expectancy"]])
        plt.savefig("outliers_figs/"+feature+"_after.png", dpi=500)
        plt.show()
    return df




np.random.seed(10)

# make all the columns be represented when printing
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)

# read df
train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv')

# data processing

# unnecessary_features_check(train)
train, country_emb_map = data_processing(train)
le_mean, le_std = train['Life expectancy'].mean(), train['Life expectancy'].std()
train['Life expectancy'] = (train['Life expectancy'] - le_mean) / le_std
# check_outliers(train, 'Life expectancy')
# train = remove_outliers(train)
y_train = train['Life expectancy']
x_train = train.drop(['Life expectancy'], axis=1)


# model fitting
model = GridSearchCV(KernelRidge(), param_grid={"alpha": [2e0, 2.1, 5, 10, 1e0, 0.1, 1e-2, 1e-3], 'kernel':('linear', 'polynomial', 'laplacian')}, )
model.fit(x_train, y_train)

# predict
ID = test['ID']
test, _ = data_processing(test, train_flag=False, country_emb_map=country_emb_map)
y_test = model.predict(test)
res = pd.DataFrame()
res['ID'] = ID
res['Life expectancy'] = y_test * le_std + le_mean

# save results in the "test_results" directory with the next index name
list_of_files = glob.glob('test_results/*.csv')     # * means all if need specific format then *.csv
latest_file = max(list_of_files, key=os.path.getctime)      # the latest file name
new_file = latest_file[:-5]+str(int(latest_file[-5])+1)+latest_file[-4:]    # new file name (next index from latest)
res.to_csv(new_file, index=False)   # saving


