% Done by: Dan Ben Ami
% Date: 18.4.22
close all
clear all
clc


% ----- image preparing ---------
img = imread('Castle.jpeg'); % load the image
img = rgb2gray(img); % make img to grey scale 
figure
imshow(img)
img = double(img); % change format
mean_img = mean(img').'; % calculate the average of the columns 
img = img - mean_img*ones(1,size(img,2)); % make the expectation of collumns 0
cov_img = cov(img'); % calculate the empirical covariance matrix of the column


% ------ compression -----------
[U,S,V] = svd(cov_img); % diagonalize the empirical covariance matrix
lamda = diag(S);
comp_ratio = cumsum(lamda)/sum(lamda); % calculate the compression ratio

num_vecs_95 = find(comp_ratio >=0.95); % find the num of eigenvalues neccesery for 0.95 compression ratio
num_vecs_95 = num_vecs_95(1);

num_vecs_65 = find(comp_ratio >=0.65); % find the num of eigenvalues neccesery for 0.65 compression ratio
num_vecs_65 = num_vecs_65(1);

comp_U95 = U(:,1:num_vecs_95); % trim the eigenvactors matrix to just num_vecs vectors that needed
alpha95 = comp_U95'*img;

comp_U65 = U(:,1:num_vecs_65); % trim the eigenvactors matrix to just num_vecs vectors that needed
alpha65 = comp_U65'*img;

% for saving the image all that needed saving is the alpha  and the comp_U
% matrixes.

% -------- decompression --------------
decomp_img95 = uint8(comp_U95*alpha95 + mean_img*ones(1,size(img,2))); % KLE
decomp_img65 = uint8(comp_U65*alpha65 + mean_img*ones(1,size(img,2))); % KLE

figure
imshow(decomp_img95);
figure
imshow(decomp_img65);

% -------- memory difference ----------
img_mem_size = size(img,1)*size(img,2);
comp95_mem_size = size(comp_U95,1)*size(comp_U95,2)+size(alpha95,1)*size(alpha95,2);
comp65_mem_size = size(comp_U65,1)*size(comp_U65,2)+size(alpha65,1)*size(alpha65,2);
fprintf('The memory size of the original image is %d bytes\n', img_mem_size);
fprintf('The memory size of the compreesed image with compression ratio 0.95 is %d bytes\n', comp95_mem_size);
fprintf('The memory size of the compreesed image with compression ratio 0.65 is %d bytes\n', comp65_mem_size);

