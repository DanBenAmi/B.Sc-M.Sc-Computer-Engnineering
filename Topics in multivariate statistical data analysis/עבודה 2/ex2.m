% Done by: Dan Ben Ami
% ID: 316333079


%% ------------------- question 1 ---------------------------------
clear all;
close all
clc

% given variables
M = 3;
w = [0.4, 0.4, 0.2]';
mu = zeros(3,2);
sigma = cat(3,[1 0.9;0.9 1],[1 -0.9;-0.9 1], diag([0.05 5]));
N = 1000 ;
gm = gmdistribution(mu, sigma, w);
X = random(gm,N);

% E-M 
gamma = zeros(N,M);
iters = 1;
w_hat =  repmat(1/3,3,1);
mu_hat = [X(randi(N),:);X(randi(N),:);X(randi(N),:)];
sigma_hat = cat(3,diag(rand(2,1)),diag(rand(2,1)), diag(rand(2,1)));
llh = zeros(iters,1);

for t=1:iters
    % E-step
    for i=1:N
        for j=1:M
            gamma(i,j)=w_hat(j)*1/(2*pi*sqrt(abs(det(sigma_hat(:,:,j)))))...
            *exp((-0.5*(X(i,:)-mu_hat(j,:))*(sigma_hat(:,:,j)\(X(i,:)...
            -mu_hat(j,:))'))); 
        end
        sum_g = sum(gamma(i,:));
        gamma(i,:) = gamma(i,:)/sum_g;
        % log liklihood
        llh(t) = llh(t) + log(sum_g);
    end

    % M-step
    w_hat = 1/N*sum(gamma(:,:));
    mu_hat = (gamma'*X)./(sum(gamma(:,:)))';

    sigma_hat(:,:,:) = zeros(2,2,M);
    for j=1:M
        for n=1:N
            sigma_hat(:,:,j) = sigma_hat(:,:,j)+gamma(n,j)*(X(n,:)-...
                mu_hat(j,:))'*(X(n,:)-mu_hat(j,:))/sum(gamma(:,j));
        end
    end     
end

%plot the log liklihood
figure(1);
plot(1:iters,llh, 'LineWidth',2) % Scatter plot with points of size 10
title('EM - Log liklihood  as a function of iterations');
xlabel('iterations') 
ylabel('log liklihood of f(x)')
grid on

% scatter plot
figure(2)
scatter(X(:,1),X(:,2),50,'.') % Scatter plot with points of size 10
title('1000 points taken from gmdistribution - estimation contour')
xlabel('X') 
ylabel('Y')
grid on
hold on
x= -4:.1:4;
y= -4:.1:4;
[A,B] = meshgrid(x,y);
for j=1:M
    Z = mvnpdf([A(:),B(:)],mu_hat(j,:),sigma_hat(:,:,j));
    Z = reshape(Z, size(A));
    contour(A,B,Z);
end

% scatter plot
figure(3)
scatter(X(:,1),X(:,2),50,'.') % Scatter plot with points of size 10
title('1000 points taken from gmdistribution - real contour')
xlabel('X') 
ylabel('Y')
grid on
hold on
x= -4:.1:4;
y= -4:.1:4;
[A,B] = meshgrid(x,y);
for j=1:M
    Z = mvnpdf([A(:),B(:)],mu(j,:),sigma(:,:,j));
    Z = reshape(Z, size(A));
    contour(A,B,Z);
end


%% ------------------- question 3 ---------------------------------

MSER = @(N,p,h)((((h^2+2)^(-p/2))/(N*h^p)) + (1-1/N)*(h^2+1)^(-p) - 2*(h^2+1)^(-p/2)+1);
Ns = zeros(20,1);
MSER_OPT = zeros(20,50);
for p = 1:20
    for i=1:50
        MSER_h = @(h) MSER(2^i,p,h);
        x = fminbnd(MSER_h,0.01,10);
        MSER_OPT(p,i) = MSER_h(x); 
        if ((MSER_OPT(p,i)<=0.1) && (Ns(p)==0))
            Ns(p) = 2^i;         
        end
    end
    if (Ns(p)==0)
        Ns(p) = 2^50;
    end
        
end        

p = 1:20;
figure(1)
semilogy(p,Ns);
title('minimal N that rreduces the MSER-OPT as function of P')
ylabel('N (log scale)') 
xlabel('P')


%% ------------------- question 4 ---------------------------------
clear all;
close all
clc

N = 1000 ;
w = [0.5 ; 0.5];
mu = [2/3 2/3 ; -2/3 -2/3];
Sigma = cat(3,[5/9 -4/9 ; -4/9 5/9],[5/9 -4/9 ; -4/9 5/9]);
gm = gmdistribution(mu,Sigma,w);
X = random(gm,N);
T = 150;
x = linspace(-4,4,T);
y = linspace(-4,4,T);
real_pdf = zeros(T,T);
f_hat1 = zeros(T,T);
f_hat2 = zeros(T,T);
h = N^(-1/6);
h2=0.1646;

for i = 1:T    
    for j = 1:T                
        real_pdf(i,j) = pdf(gm,[x(i),y(j)]);
        p = [x(i),y(j)];
        f_hat1(i,j) = sum(mvnpdf((X-repmat(p,1000,1))/h,[0,0],eye(2)))/(N*h^2);
        f_hat2(i,j) = sum(w(1)*mvnpdf((X-repmat(p,1000,1))/h2,mu(1,:),...
        Sigma(:,:,1))+w(2)*mvnpdf((X-repmat(p,1000,1))/h2,mu(2,:),Sigma(:,:,2)))/(N*h2^2);
    end
end

figure(1)
surf(x,y,real_pdf)
xlabel('x1')
ylabel('x2')
zlabel('f(x)')
title('f(x) - real pdf')

figure(2)
surf(x,y,f_hat1)
title('pdf Estimated by Gaussian Kernel Function with Gaussian pdf as reference')
xlabel('x1')
ylabel('x2')
zlabel('$$\hat{f}(x)$$','Interpreter','Latex')

figure(3)
surf(x,y,f_hat2)
title('pdf Estimated by Gaussian Kernel Function with real pdf as reference')
xlabel('x1')
ylabel('x2')
zlabel('$$\hat{f}(x)$$','Interpreter','Latex')













