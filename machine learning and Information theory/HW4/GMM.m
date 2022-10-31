%Question 1
N = 1000;
M = 3;
mu = [0 0;0 0;0 0];
sigma = cat(3,[0.05 0; 0 5],[1 -0.9; -0.9 1],[1 0.9;0.9 1]);
w = [0.2,0.4,0.4];
gm = gmdistribution(mu,sigma,w);

X = random(gm,N);
figure(1)
scatter(X(:,1),X(:,2),10,'.') % Scatter plot with points of size 10
xlabel('Gaussian 1');
ylabel('Gaussian 2');
title('Scatter 1000 points of the generated data')
%Init
EM_Iter = 100;
gamma = zeros(N,M);
w_hat = rand(3,1); 
mu_hat = [X(randi(N),:);X(randi(N),:);X(randi(N),:)];
sigma_hat =  cat(3,[X(randi(N),:); X(randi(N),:)],[X(randi(N),:); X(randi(N),:)],[X(randi(N),:); X(randi(N),:)]);
for iter=1:EM_Iter
    LogLikliHood = 0;
    %E-Step
    for i=1:N
        for j=1:M
            gamma(i,j) = w_hat(j)*(1/(2*pi*sqrt(abs(det(sigma_hat(:,:,j)))))*exp((-1/2)*(X(i,:)-mu_hat(j,:))*(sigma_hat(:,:,j)\(X(i,:)-mu_hat(j,:))')));
        end
        tmp = sum(gamma(i,:));
        LogLikliHood = LogLikliHood + log(tmp);
        gamma(i,:) = gamma(i,:)/tmp;
    end
    %M-step
    for k=1:M
        w_hat(k)=(1/N)*sum(gamma(:,k));
        mu_hat(k,:) = gamma(:,k)'*X/(w_hat(k,:)*N);
        tmp = zeros(2,2);
        for n=1:N
            tmp = tmp + gamma(n,k)*(X(n,:)-mu_hat(k,:))'*(X(n,:)-mu_hat(k,:))/(w_hat(k,:)*N);
        end
        sigma_hat(:,:,k) = tmp;
    end
    if(iter>1)
        figure(1)
        scatter(iter,LogLikliHood);
        title('Em - Log Liklihood')
        xlabel('Iteration number')
        ylabel('Log Liklihood')
        hold on;
    end

end
%Estimate
figure(2)
x = -5:.1:5 ; %// x a x i s
y = -5:.1:5 ; %// y a x i s
tmp = X;
scatter(X(:,1),X(:,2),10,'.') % Scatter plot with points of size 10
hold on
[X ,Y] = meshgrid (x ,y) ; %// a l l c ombin a ti on s o f x , y
Z1 = mvnpdf ([X( : ),Y( : )] ,mu_hat(1,:), sigma_hat(:,:,1)) ; %// compute Gaussian pd f
Z1 = reshape(Z1,size(X));
Z2 = mvnpdf ([X( : ),Y( : )] ,mu_hat(2,:), sigma_hat(:,:,2)) ; %// compute Gaussian pd f
Z2 = reshape(Z2,size(X));
Z3 = mvnpdf ([X( : ),Y( : )] ,mu_hat(3,:), sigma_hat(:,:,3)) ; %// compute Gaussian pd f
Z3 = reshape(Z3,size(X));
contour(X,Y,Z1);
contour(X,Y,Z2);
contour(X,Y,Z3);
%Real
figure(3)
X = tmp;
x = -5:.1:5 ; %// x a x i s
y = -5:.1:5 ; %// y a x i s
scatter(X(:,1),X(:,2),10,'.') % Scatter plot with points of size 10
hold on
[X ,Y] = meshgrid (x ,y) ; %// a l l c ombin a ti on s o f x , y
Z1 = mvnpdf ([X( : ),Y( : )] ,mu(1,:), sigma(:,:,1)) ; %// compute Gaussian pd f
Z1 = reshape(Z1,size(X));
Z2 = mvnpdf ([X( : ),Y( : )] ,mu(2,:), sigma(:,:,2)) ; %// compute Gaussian pd f
Z2 = reshape(Z2,size(X));
Z3 = mvnpdf ([X( : ),Y( : )] ,mu(3,:), sigma(:,:,3)) ; %// compute Gaussian pd f
Z3 = reshape(Z3,size(X));
contour(X,Y,Z1);
contour(X,Y,Z2);
contour(X,Y,Z3);
%Question 3
MSER_OPT = zeros(20);
multiVariate_MSER = @(N,p,h) ((h^2+2)^(p/2))/(N*h^p)+((N-1)*(h^2+1)^p)/N-2*(h^2+1)^(p/2)+1;
for p=1:20
    for i=1:50
        MSER = @(h) multiVariate_MSER(2^i,p,h);
        x = fminbnd(MSER,0.01,10);
        if(MSER(x) <= 0.1)
            MSER_OPT(p) = 2^i;
            break
        end
    end
    if(MSER_OPT(p)==0)
        MSER_OPT(p) = 2^50;
    end
end

figure(1)
semilogy(MSER_OPT);
title("Minimal N as function of p");
xlabel("P axis");
ylabel("N axis logartmic scale");


%Question 4
clear all;
close all

N = 1000 ;
w = [0.5 ; 0.5];
mu = [2/3 2/3 ; -2/3 -2/3];
Sigma(:,:,1) = [5/9 -4/9 ; -4/9 5/9];
Sigma(:,:,2) = Sigma(:,:,1);

gm = gmdistribution(mu,Sigma,w);

X = random(gm,N);
%%

T = 500;

x1 = linspace(-5,5,T);

x2 = linspace(-5,5,T);

f = zeros(T,T);
f_hat = zeros(T,T);
f_hat2 = zeros(T,T);
h = N^(-1/6);
h2=0.1646;
%%
parfor i = 1:T    
    for j = 1:T                
        f(i,j) = pdf(gm,[x1(i),x2(j)]);
        x = [x1(i),x2(j)];
        f_hat(i,j) = sum(mvnpdf((X-repmat(x,1000,1))/h,[0,0],eye(2)))/(N*h^2);
        f_hat2(i,j) = sum(w(1)*mvnpdf((X-repmat(x,1000,1))/h2,mu(1,:),Sigma(:,:,1))+w(2)*mvnpdf((X-repmat(x,1000,1))/h2,mu(2,:),Sigma(:,:,2)))/(N*h2^2);
    end
    
end

figure
mesh(x1,x2,f)
xlabel('x1')
ylabel('x2')
zlabel('f(x)')
title('f(x) - True pdf')

%%


figure
mesh(x1,x2,f_hat)
xlabel('x1')
ylabel('x2')
zlabel('$$\hat{f}(x)$$','Interpreter','Latex')
title('pdf Estimated by Gaussian Kernel Function')

%%
figure
mesh(x1,x2,f_hat2)
xlabel('x1')
ylabel('x2')
zlabel('$$\hat{f}(x)$$','Interpreter','Latex')
title('pdf Estimated by GMM Kernel Function')





