%name: Tome kessous ID:206018749
%name: Dan ben ami  ID:316333079
M=18;
N=18;
D=0.1; %D=delta
h=D;
A=zeros(M,N);
q=[3,1,6,3,3,3,0,7,9,2,0,6,0,1,8,7,4,9]';

%----------------- Question 1 --------------

% section 1.1
% this two loops are using the formula from the task and saves each value
% in different coordinates in the matrix A.
for m=1:M 
    for n=1:N
        A(m,n)=1/(4*pi*sqrt(h^2+(m-n)^2*D^2));
    end
end
v=A*q;
norma2_q=norm(q); %norma number 2 of the q vector(||q||2)
norma2_v=norm(v); %norma number 2 of the v vector(||v||2)
normaF_A=sqrt(sum(A.^2,'all')); %norma of F kind of the A matrix(||A||F)
%kappa_A_cond=cond(A,2);
kappa_A=normaF_A*(sqrt(sum((inv(A)).^2,'all'))); % kappa of A matrix
[L,U,P]=lu(A); % factorizes the matrix A into an upper triangular matrix U and a permuted lower 
% triangular matrix L such that  A=P'*L*U. P is the pivoting matrix.


% section 1.2
y=zeros(18,1);
y(1)=v(1);
for i=(2:M)    %this loop calculate the vector y from the equation L*y=v.
    Row_L=L(i,1:(i-1));
    Col_y=y(1:i-1);
    y(i)=v(i)-Row_L*Col_y;
end   
q_tilda=zeros(18,1); % q_tilda is the approximate solution to the Aq=v equation by the LU solving system
q_tilda(M)=y(M)/U(M,N);
for i=(M-1:-1:1)  %this loop calculate the vector q_tilda from the equation U*q_tilda=y.
    Row_U=U(i,(i+1:N));
    Col_q_tilda=q_tilda(i+1:N);
    q_tilda(i)=(y(i)-Row_U*Col_q_tilda)/U(i,i);
end
relative_error_q=abs(norma2_q-norm(q_tilda))/norma2_q; % calculate the relative error of q.


% section 1.3
v_tilda=v+0.01*norma2_v*ones(18,1); %v_tilda is the vector v plus the delta that given
y_c=zeros(18,1);
y_c(1)=v_tilda(1);
for i=(2:M)    %this loop calculate the vector y_c from the equation L*y_c=v_tilda.
    Row_L_c=L(i,1:(i-1));
    Col_y_c=y_c(1:i-1);
    y_c(i)=v_tilda(i)-Row_L_c*Col_y_c;
end   
q_c_tilda=zeros(18,1); % q_c_tilda is the approximate solution to the Aq=v_tilda equation by the LU solving system
q_c_tilda(M)=y_c(M)/U(M,N);
for i=(M-1:-1:1)  %this loop calculate the vector q_c_tilda from the equation U*q_tilda=y.
    Row_U_c=U(i,(i+1:N));
    Col_q_c_tilda=q_c_tilda(i+1:N);
    q_c_tilda(i)=(y_c(i)-Row_U_c*Col_q_c_tilda)/U(i,i);
end
relative_error_q_c=abs(norma2_q-norm(q_c_tilda))/norma2_q; % calculate the relative error of q.


% section 1.4
A_tilda=A+0.01*normaF_A*ones(M,N); %A_tilda is the matrix A plus the delta that given.
[L_tilda,U_tilda]=lu(A_tilda); % factorizes the matrix A_tilda into an upper triangular matrix U_tilda and a permuted lower 
% triangular matrix L_tilda such that A_tilda=*L_tilda*U_tilda.
y_D=zeros(18,1);
y_D(1)=v(1);
for i=(2:M)    %this loop calculate the vector y from the equation L_tilda*y_D=v.
    Row_L_D=L_tilda(i,1:(i-1));
    Col_y_D=y_D(1:i-1);
    y_D(i)=v(i)-Row_L_D*Col_y_D;
end   
q_D_tilda=zeros(18,1); % q_D_tilda is the approximate solution to the A_tilda*q=v equation by the LU solving system
q_D_tilda(M)=y_D(M)/U_tilda(M,N);
for i=(M-1:-1:1)  %this loop calculate the vector q_tilda from the equation U_tilda*q_D_tilda=y.
    Row_U_D=U_tilda(i,(i+1:N));
    Col_q_D_tilda=q_D_tilda(i+1:N);
    q_D_tilda(i)=(y_D(i)-Row_U_D*Col_q_D_tilda)/U_tilda(i,i);
end
relative_error_q_D=abs(norma2_q-norm(q_D_tilda))/norma2_q; % calculate the relative error of q.


%section 1.5
Vh=[D,2*D,5*D,10*D,20*D,50*D];
Vkappa_A=[];
Vrelative_error_q=[];
Vrelative_error_q_c=[];
Vrelative_error_q_D=[];
%V is a sign to vector of the variable with differnt value of h
for h=[D,2*D,5*D,10*D,20*D,50*D]
    
    % section A
    for m=1:M
        for n=1:N
            A(m,n)=1/(4*pi*sqrt(h^2+(m-n)^2*D^2));
        end
    end
    v=A*q;
    norma2_q=norm(q); %norma number 2 of the q vector(||q||2)
    norma2_v=norm(v); %norma number 2 of the v vector(||v||2)
    normaF_A=sqrt(sum(A.^2,'all')); %norma of F kind of the A matrix(||A||F)
    Vkappa_A=[Vkappa_A,(max(sum(abs(A'))))*(max(sum(abs((inv (A))'))))]; %appending the kappa of A matrix to the Vkappa_A vector
    [L,U,P]=lu(A); % factorizes the matrix A into an upper triangular matrix U and a permuted lower
    % triangular matrix L such that  A=P'*L*U. P is the pivoting matrix.
    
    
    % section B
    y=zeros(18,1);
    y(1)=v(1);
    for i=(2:M)    %this loop calculate the vector y from the equation L*y=v.
        Row_L=L(i,1:(i-1));
        Col_y=y(1:i-1);
        y(i)=v(i)-Row_L*Col_y;
    end
    q_tilda=zeros(18,1); % q_tilda is the approximate solution to the Aq=v equation by the LU solving system
    q_tilda(M)=y(M)/U(M,N);
    for i=(M-1:-1:1)  %this loop calculate the vector q_tilda from the equation U*q_tilda=y.
        Row_U=U(i,(i+1:N));
        Col_q_tilda=q_tilda(i+1:N);
        q_tilda(i)=(y(i)-Row_U*Col_q_tilda)/U(i,i);
    end
    Vrelative_error_q=[Vrelative_error_q,(abs(norma2_q-norm(q_tilda))/norma2_q)]; %appending the the relative error of q to Vrelative_error_q vector.
    
    
    % section C
    v_tilda=v+0.01*norma2_v*ones(18,1); %v_tilda is the vector v plus the delta that given
    y_c=zeros(18,1);
    y_c(1)=v_tilda(1);
    for i=(2:M)    %this loop calculate the vector y_c from the equation L*y_c=v_tilda.
        Row_L_c=L(i,1:(i-1));
        Col_y_c=y_c(1:i-1);
        y_c(i)=v_tilda(i)-Row_L_c*Col_y_c;
    end
    q_c_tilda=zeros(18,1); % q_c_tilda is the approximate solution to the Aq=v_tilda equation by the LU solving system
    q_c_tilda(M)=y_c(M)/U(M,N);
    for i=(M-1:-1:1)  %this loop calculate the vector q_c_tilda from the equation U*q_tilda=y.
        Row_U_c=U(i,(i+1:N));
        Col_q_c_tilda=q_c_tilda(i+1:N);
        q_c_tilda(i)=(y_c(i)-Row_U_c*Col_q_c_tilda)/U(i,i);
    end
    Vrelative_error_q_c=[Vrelative_error_q_c, abs((norma2_q-norm(q_c_tilda))/norma2_q)]; % appending the relative error of q to Vrelative_error_q_c.
    
    
    % section D
    A_tilda=A+0.01*normaF_A*ones(M,N); %A_tilda is the matrix A plus the delta that given.
    [L_tilda,U_tilda]=lu(A_tilda); % factorizes the matrix A_tilda into an upper triangular matrix U_tilda and a permuted lower
    % triangular matrix L_tilda such that A_tilda=*L_tilda*U_tilda.
    y_D=zeros(18,1);
    y_D(1)=v(1);
    for i=(2:M)    %this loop calculate the vector y from the equation L_tilda*y_D=v.
        Row_L_D=L_tilda(i,1:(i-1));
        Col_y_D=y_D(1:i-1);
        y_D(i)=v(i)-Row_L_D*Col_y_D;
    end
    q_D_tilda=zeros(18,1); % q_D_tilda is the approximate solution to the A_tilda*q=v equation by the LU solving system
    q_D_tilda(M)=y_D(M)/U_tilda(M,N);
    for i=(M-1:-1:1)  %this loop calculate the vector q_tilda from the equation U_tilda*q_D_tilda=y.
        Row_U_D=U_tilda(i,(i+1:N));
        Col_q_D_tilda=q_D_tilda(i+1:N);
        q_D_tilda(i)=(y_D(i)-Row_U_D*Col_q_D_tilda)/U_tilda(i,i);
    end
    Vrelative_error_q_D=[Vrelative_error_q_D, abs(norma2_q-norm(q_D_tilda))/norma2_q]; % appending the relative error of q to Vrelative_error_q_D.
end
figure(1)
loglog(Vh,Vkappa_A,'-o');
title('1.5 Kappa A as a function of h')
xlabel('D<h<50D');
ylabel('Kappa A');
figure(2)
loglog(Vh,Vrelative_error_q,'-o');
title('1.5 Relative error of q in 1.2 as a function of h')
xlabel('D<h<50D');
ylabel('Relative error of q');
figure(3)
loglog(Vh,Vrelative_error_q_c,'-o');
title('1.5 Relative error of q in 1.3 as a function of h')
xlabel('D<h<50D');
ylabel('Relative error of q in section c');
figure(4)
loglog(Vh,Vrelative_error_q_D,'-o');
title('1.5 Relative error of q in 1.4 as a function of h')
xlabel('D<h<50D');
ylabel('Relative error of q in section D');


%---------------- Question 2 -----------------

clear all
M=18;
N=18;
Delta=0.1; %D=delta
A=zeros(M,N);
q=[3,1,6,3,3,3,0,7,9,2,0,6,0,1,8,7,4,9]';


%section 2.1 , 2.2
count=5;
for h=[Delta/5, Delta, Delta/2]
    % this two loops are using the formula from the task and saves each value
    % in different coordinates in the matrix A.

    for m=1:M
        for n=1:N
            A(m,n)=1/(4*pi*sqrt(h^2+(m-n)^2*Delta^2));
        end
    end
    v=A*q;
    D=diag(diag(A)); % D is matrix that contains the diagonal of the A matrix
    L=zeros(M,N);
    for i=1:M %this two loops bulding the lower triangular matrix L of A matrix
        for j=1:N
            if i>j
                L(i,j)=A(i,j);
            end
        end
    end
    U=A-L-D; %upper triangular matrix U of A matrix
    Q=L+D;
    I=diag(diag(ones(M,N))); % I is the "I" matrix
    q_series=[zeros(M,1),((inv(Q))*v),(I-inv(Q)*A)*((inv(Q))*v)+((inv(Q))*v)];
    % q_series is matrix that contains in each column the q vector of each
    % iteration
    k=3;
    relative_d=[norm(q_series(:,k)-q_series(:,k-1))/norm(q_series(:,k-1))];
    % relative_d is a vector that contains the relative distance between every
    % following q vectors after the 2nd vector. p.s. the relative distance
    % between the 1st and the 2nd q vectors is not defined (division by 0)
    relative_error=[1,norm(q_series(:,2)-q)/norm(q),norm(q_series(:,3)-q)/norm(q)];
    %relative_error is a vectoe that contain the relative error of q in every iteration
    while (norm(q_series(:,k)-q))/norm(q)>10^(-3)
        %this loop is doing the Gauss-Seidel iterations formula and calculating
        %the relative distance between each two q vectors
        q_series=[q_series,(I-inv(Q)*A)*q_series(:,k)+inv(Q)*v];
        k=k+1;
        relative_d=[relative_d, norm(q_series(:,k)-q_series(:,k-1))/norm(q_series(:,k-1))];
        relative_error=[relative_error, norm(q_series(:,k)-q)/norm(q)];
    end
    q_tilda=q_series(:,k); % q_tilda is the last vector in q_series, this is the vector q that
    %calculated by the Gauss-Seidel system after 7 iterations.
    figure(count)
    semilogy(relative_d,'-O');
    title(sprintf('Gauss-Seidel method: The relative distance and error in every iteration when h= %s',h));
    xlabel("The iteration's number");
    ylabel('Relative distance and error');
    hold on
    semilogy(relative_error,'-s');
    legend({'distance','error'},'location','southwest');
    final_relative_error=relative_error(k); % this is the last value in relative_error
    hold off
    count=count+1
end
 

% section 2.3
h=Delta/5;
% this two loops are using the formula from the task and saves each value
% in different coordinates in the matrix A.

for m=1:M
    for n=1:N
        A(m,n)=1/(4*pi*sqrt(h^2+(m-n)^2*Delta^2));
    end
end
v=A*q;
D=diag(diag(A)); % D is matrix that contains the diagonal of the A matrix
Q=D;
for i =1:N
    if A(i,i)<sum(A(i,:))-A(i,i)
        dominant_diagonal= 0;
        break
    else
        dominant_diagonal=1
    end
end

I=diag(diag(ones(M,N))); % I is the "I" matrix
q_series=[zeros(M,1),((inv(Q))*v),(I-inv(Q)*A)*((inv(Q))*v)+((inv(Q))*v)];
% q_series is matrix that contains in each column the q vector of each
% iteration
k=3;
relative_d=[norm(q_series(:,k)-q_series(:,k-1))/norm(q_series(:,k-1))];
% relative_d is a vector that contains the relative distance between every
% following q vectors after the 2nd vector. p.s. the relative distance
% between the 1st and the 2nd q vectors is not defined (division by 0)
relative_error=[1,norm(q_series(:,2)-q)/norm(q),norm(q_series(:,3)-q)/norm(q)];
%relative_error is a vectoe that contain the relative error of q in every iteration

if dominant_diagonal==1  
    while (norm(q_series(:,k)-q))/norm(q)>10^(-3)
        %this loop is doing the Gauss-Seidel iterations formula and calculating
        %the relative distance between each two q vectors
        q_series=[q_series,(I-inv(Q)*A)*q_series(:,k)+inv(Q)*v];
        k=k+1;
        relative_d=[relative_d, norm(q_series(:,k)-q_series(:,k-1))/norm(q_series(:,k-1))];
        relative_error=[relative_error, norm(q_series(:,k)-q)/norm(q)];
    end
    q_tilda=q_series(:,k); % q_tilda is the last vector in q_series, this is the vector q that
    %calculated by the Gauss-Seidel system after 7 iterations.
    figure(8)
    semilogy(relative_d,'-O');
    title(sprintf('2.3 The relative distance and relative error in every iteration when h= %s',h));
    xlabel("The iteration's number");
    ylabel('Relative distance and error');
    hold on
    semilogy(relative_error,'-s');
    legend({'distance','error'},'location','southwest');
    final_relative_error=relative_error(k); % this is the last value in relative_error
    hold off
else
    disp ('the diagonal of matrix A is not dominant, therefore Jacobi method will not work')
        
end


% section 2.4
 h=Delta/5;
% this two loops are using the formula from the task and saves each value
% in different coordinates in the matrix A.

for m=1:M
    for n=1:N
        A(m,n)=1/(4*pi*(h^2+(m-n)^2*Delta^2));
    end
end
v=A*q;
D=diag(diag(A)); % D is matrix that contains the diagonal of the A matrix
Q=D;
for i =1:N
    if A(i,i)<sum(A(i,:))-A(i,i)
        dominant_diagonal= 0;
        break
    else
        dominant_diagonal=1
    end
end

I=diag(diag(ones(M,N))); % I is the "I" matrix
q_series=[zeros(M,1),((inv(Q))*v),(I-inv(Q)*A)*((inv(Q))*v)+((inv(Q))*v)];
% q_series is matrix that contains in each column the q vector of each
% iteration
k=3;
relative_d=[norm(q_series(:,k)-q_series(:,k-1))/norm(q_series(:,k-1))];
% relative_d is a vector that contains the relative distance between every
% following q vectors after the 2nd vector. p.s. the relative distance
% between the 1st and the 2nd q vectors is not defined (division by 0)
relative_error=[1,norm(q_series(:,2)-q)/norm(q),norm(q_series(:,3)-q)/norm(q)];
%relative_error is a vectoe that contain the relative error of q in every iteration

if dominant_diagonal==1  
    while (norm(q_series(:,k)-q))/norm(q)>10^(-3)
        %this loop is doing the Gauss-Seidel iterations formula and calculating
        %the relative distance between each two q vectors
        q_series=[q_series,(I-inv(Q)*A)*q_series(:,k)+inv(Q)*v];
        k=k+1;
        relative_d=[relative_d, norm(q_series(:,k)-q_series(:,k-1))/norm(q_series(:,k-1))];
        relative_error=[relative_error, norm(q_series(:,k)-q)/norm(q)];
    end
    q_tilda=q_series(:,k); % q_tilda is the last vector in q_series, this is the vector q that
    %calculated by the Gauss-Seidel system after 7 iterations.
    figure(8)
    semilogy(relative_d,'-O');
    title(sprintf('2.4 Jacobi method: The relative distance and error in every iteration when h= %s',h));
    xlabel("The iteration's number");
    ylabel('Relative distance and error');
    hold on
    semilogy(relative_error,'-s');
    legend({'distance','error'},'location','southwest');
    final_relative_error=relative_error(k); % this is the last value in relative_error
    hold off
else
    disp ('the diagonal of matrix A is not dominant, therefore Jacobi method will not work')
        
end
  

%---------------- Question 3 -----------------
clear all
M=18;
N=18;
Delta=0.1; %D=delta
A=zeros(M,N);
q=[3,1,6,3,3,3,0,7,9,2,0,6,0,1,8,7,4,9]';

% section 3.1
h=10*Delta;
% this two loops are using the formula from the task and saves each value
 % in different coordinates in the matrix A.
for m=1:M
        for n=1:N
            A(m,n)=1/(4*pi*sqrt(h^2+(m-n)^2*Delta^2));
        end
    end
v=A*q;
det_A=det(A); %this is the determinant of the A matrix
q_tilda=(inv((A')*A))*(A')*v; %q_tilda is a vector that brings the value of A*q_tilda to the value of the vector V
relative_error=norm(q-q_tilda)/norm(q); % this is the relative error of q_tilda as oppose to q


% section 3.2
Vdet_A=[];
Vrelative_error=[];
Vh=[Delta/5, Delta/2, Delta, 2*Delta, 5*Delta, 10*Delta];
for h=[Delta/5, Delta/2, Delta, 2*Delta, 5*Delta, 10*Delta] %this loop is changing the h each iteration
 % this two loops are using the formula from the task and saves each value
 % in different coordinates in the matrix A.
    for m=1:M
        for n=1:N
            A(m,n)=1/(4*pi*sqrt(h^2+(m-n)^2*Delta^2));
        end
    end
    v=A*q;
    Vdet_A=[Vdet_A, det(A)];
    q_tilda=(inv((A')*A))*(A')*v;
    Vrelative_error=[Vrelative_error, norm(q-q_tilda)/norm(q)];
end
figure(9)
loglog(Vh,Vdet_A,'-o');
title('3.2 det A as a function of h')
xlabel('Delta/5<h<Delta*10');
ylabel('det A');
figure(10)
loglog(Vh,Vrelative_error,'-s');
title('3.2 relative error as a function of h')
xlabel('Delta/5<h<Delta*10');
ylabel('relative error');