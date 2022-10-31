% Done by: Dan Ben Ami
% ID: 316333079


%% ------------------- question 1 ---------------------------------
clear all
close all
clc

N = 1000;
p = 10;
alpha = 0.05;
iters = 1000;

t_star = norminv(1-alpha/2, 0, sqrt(8*p*(p+2)));

snr = -10:5:10;
s = randsrc(N,p,[-1 1; 0.5,0.5]);
pd = zeros(1,5);
parfor i = 1:length(snr)
    sigma_w = 10^(-snr(i)/10);
    cntr_pd = 0;
    for iter = 1:iters
        X = s + sqrt(sigma_w)*randn(N,p);
        sigma_x = cov(X);
        [U,S,V] = svd(sigma_x);
        inv_std_x = U*1/sqrt(S)*U';
        Z = (X-mean(X))*inv_std_x;
        B = (1/N)*sum(sqrt(sum(Z.^2,2)).^4);
        T = sqrt(N)*(B-p*(p+2));
        if abs(T)> t_star
            cntr_pd = cntr_pd + 1;
        end
    end
    pd(i) = cntr_pd/iters;
end

figure(1)
plot(snr,pd,'LineWidth',3)
xlabel('SNR');
ylabel('PD')
title('Probability of detection as a function of SNR');
grid on;

%% ------------------- question 3 ---------------------------------

p = 10;
N = 1000;
X = randn(N,p);
W = randn(N,p);
Y = cos(X) + W;
iters = 100;
Z = [X,Y];
perm_idx = randperm(N);
Y_perm = Y(perm_idx,:);


%Mutual Information Test



clear all
close all
clc

p = 1;
N = 1000;
X = randn(N,p);
W = randn(N,p);
Y = cos(X) + W;
iters = 100;                                                                                                                                                                                                                                                                                                              X.^2 + 0.1.*randn(N,1);
Z = [X,Y];

%GLRT
T_GLRT = (N-(2*p+3)/2)*(log(det(cov(X)))+log(det(cov(Y)))-log(det(cov(Z))));

%whitening
Sigma_Z = cov(Z);
[U,S,V] = svd(Sigma_Z);
tmp = U/(sqrt(S))*U.';
Z = Z*tmp.';

%MI
h_marg = (4/(p+2))^(1/(p+4))*N^(-1/(p+4));
h = (4/(2*p+2))^(1/(2*p+4))*N^(-1/(2*p+4));

f_XY = zeros(N,1);
f_X = zeros(N,1);
f_Y = zeros(N,1);

parfor i = 1:N   
    mu = [Z(i,1),Z(i,2)];
    f_X(i) = ksdensity(Z(:,1),mu(1),'kernel','normal','bandwidth',h_marg);
    f_Y(i) = ksdensity(Z(:,2),mu(2),'kernel','normal','bandwidth',h_marg);
    f_XY(i) = sum(mvnpdf(Z,mu,(h^2)*eye(2,2)))/N;
end

% plot3(Z(:,1),Z(:,2),f_XY,'.');

MI = abs(mean(log(f_XY./(f_X.*f_Y))));
T_MI = sqrt(1-exp(-2*MI));

T_MI_PERM = zeros(iters,1);
T_GLRT_PERM = zeros(iters,1);

for j = 1:iters
    
    perm_idx = randperm(N);
    Y_perm = Y(perm_idx,:);
    Z = [X,Y_perm];
    
    %GLRT
    T_GLRT_PERM(j) = (N-(2*p+3)/2)*(log(det(cov(X)))+log(det(cov(Y_perm)))-log(det(cov(Z))));
    
    %MI
    parfor i = 1:N
        
        mu = [Z(i,1),Z(i,2)];
        f_X(i) = ksdensity(Z(:,1),mu(1),'kernel','normal','bandwidth',h_marg);
        f_Y(i) = ksdensity(Z(:,2),mu(2),'kernel','normal','bandwidth',h_marg);
        f_XY(i) = sum(mvnpdf(Z,mu,(h^2)*eye(2,2)))/N;
                
    end
    
    MI_PERM = abs(mean(log(f_XY./(f_X.*f_Y))));
    T_MI_PERM(j) = sqrt(1-exp(-2*MI_PERM));
    disp(j);
end

P_VAL_MI = sum(T_MI_PERM > T_MI)/iters;
P_VAL_GLRT = sum(T_GLRT_PERM > T_GLRT)/iters;

fprintf('P val of MI: %d\n' ,P_VAL_MI);
fprintf('P val of GLRT: %d\n' ,P_VAL_GLRT);







