%Tom kessous , ID: 206018749
%Dan ben ami , ID: 316333079

%--------------Question 1---------------------
%section B
a=1;
b=5;
I1 = 206018749;
I2 = 316333079;
xn = a+(I1/(I1+I2))*(b-a); 
s= 3^(1/4);
V_xn = [xn];%V_xn is a list that store all the xn values from the iteration
V_error = [1]; %V_error is a list that store the distance between xn+1-xn
V_En = [a+(I1/(I1+I2))*(b-a)-s;]; %V_En is a list that store all the epsilon in each iteraion
counter = 0;
num_of_iteration = [0];
while V_error(length(V_error)) > 10^(-12) %This loop perform the newton raphson method and calculat the solution of the f(x)=0 equaition
    xn_plus_1 = xn - f(xn)/f_tag(xn);
    V_error = [V_error; abs(xn_plus_1 - xn)];
    V_En = [V_En; abs(xn_plus_1 - s)];
    counter = counter + 1;
    num_of_iteration = [num_of_iteration; counter];
    xn = xn_plus_1;
    V_xn = [V_xn;xn];
end
T = table(num_of_iteration, V_xn, V_En, V_error,'VariableNames',{'Iteration' 'Xn' 'En' 'error'});
disp (T)

%section c
En_minus_1 = log(V_En(2:7));
V_En = log(V_En(3:8));
figure(1)
plot(En_minus_1, V_En)
title('log(En) as a function of log(En-1)')
xlabel('log(En-1)')
ylabel('log(En)')

%--------------Question 2---------------------
clear all

%section A
a=1;
b=5;
I1 = 206018749;
I2 = 316333079;
s= 3^(1/4);
x0 = a+(I1/(I1+I2))*(b-a);
x1 = x0+(I1/(I1+I2))*(b-x0);
V_xn = [x0;x1]; %V_xn is a list that store all the xn values from the iteration
V_error = [0;abs(x1-x0)]; %V_error is a list that store the distance between xn+1-xn
V_En = [abs(x0-s);abs(x1-s)]; %V_En is a list that store all the epsilon in each iteraion
counter = 1;
num_of_iteration = [0;1];
while V_error(length(V_error)) > 10^(-12) %this loop perform the secant method and calculat the solution of the f(x)=0 equaition
    xn_plus_1 = V_xn(length(V_xn)) - f(V_xn(length(V_xn)))*(V_xn(length(V_xn))-V_xn(length(V_xn)-1))/(f(V_xn(length(V_xn)))-f(V_xn(length(V_xn)-1)));
    V_error = [V_error; abs(xn_plus_1 - V_xn(length(V_xn)))];
    V_En = [V_En; (xn_plus_1 - s)];
    counter = counter + 1;
    num_of_iteration = [num_of_iteration; counter];
    V_xn = [V_xn;xn_plus_1];
end
T = table(num_of_iteration, V_xn, V_En, V_error,'VariableNames',{'Iteration' 'Xn' 'En' 'error'});
disp (T)
En_minus_1 =log(V_En(2:11));
V_En = log(V_En(3:12));
figure(2)
plot(En_minus_1, V_En)
title('log(En) as a function of log(En-1)')
xlabel('log(En-1)')
ylabel('log(En)')

%--------------Question 3---------------------
clear all

%section a
xn = 5;
V_xn = [xn]; %V_xn is a list that store all the xn values from the iteration
V_error = [1]; %V_error is a list that store the distance between xn+1-xn
counter = 0;
num_of_iteration = [0];
%This loop perform the newton raphson method and calculat the solution of the f(x)=0 equaition
while V_error(length(V_error)) > 10^(-12) 
    xn_plus_1 = xn - g(xn)/g_tag(xn);
    V_error = [V_error; abs(xn_plus_1 - xn)];
    counter = counter + 1;
    num_of_iteration = [num_of_iteration; counter];
    xn = xn_plus_1;
    V_xn = [V_xn;xn];
end
s= V_xn(length(V_xn)); % s is the solution of the equaition g(x)=0
V_En = [];  %V_En is a list that store all the epsilon in each iteraion
for i=1:length(V_xn) %this loop calculate the epsilon in each iteration
    V_En =[V_En;abs(V_xn(i)-s)];
end
    
T_A = table(num_of_iteration, V_xn, V_En, V_error,'VariableNames',{'Iteration' 'Xn' 'En' 'error'});
disp (T_A)
En_minus_1 =log(V_En(2:32));
V_En = log(V_En(3:33));
figure(3)
plot(En_minus_1, V_En)
title('log(En) as a function of log(En-1)')
xlabel('log(En-1)')
ylabel('log(En)')

%section B
clear all
a=1;
b=5;
I1 = 206018749;
I2 = 316333079;
xn = a+(I1/(I1+I2))*(b-a);
s= 2;
V_xn = [xn]; %V_xn is a list that store all the xn values from the iteration
V_error = [1];  %V_error is a list that store the distance between xn+1-xn
V_En = [a+(I1/(I1+I2))*(b-a)-s;];  %V_En is a list that store all the epsilon in each iteraion
counter = 0;
num_of_iteration = [0];
%This loop perform the newton raphson method and calculat the solution of the u(x)=0 equaition
%with s from multiplicity of q
while V_error(length(V_error)) > 10^(-12) 
    xn_plus_1 = xn - u(xn)/u_tag(xn);
    V_error = [V_error; abs(xn_plus_1 - xn)];
    V_En = [V_En; abs(xn_plus_1 - s)];
    counter = counter + 1;
    num_of_iteration = [num_of_iteration; counter];
    xn = xn_plus_1;
    V_xn = [V_xn;xn];
end

T_B = table(num_of_iteration, V_xn,V_En, V_error);
disp (T_B)
En_minus_1 =log(V_En(2:4));
V_En = log(V_En(3:5));
figure(4)
plot(En_minus_1, V_En)
title('log(En) as a function of log(En-1)')
xlabel('log(En-1)')
ylabel('log(En)')

%section c
clear all

xn = 5;
V_xn = [xn]; %V_xn is a list that store all the xn values from the iteration
V_error = [1]; %V_error is a list that store the distance between xn+1-xn
counter = 0;
num_of_iteration = [0];
%This loop perform the newton raphson method and calculat the solution of the f(x)=0 equaition
while V_error(length(V_error)) > 10^(-12) 
    xn_plus_1 = xn - 3*(g(xn)/g_tag(xn));
    V_error = [V_error; abs(xn_plus_1 - xn)];
    counter = counter + 1;
    num_of_iteration = [num_of_iteration; counter];
    xn = xn_plus_1;
    V_xn = [V_xn;xn];
end
s= V_xn(length(V_xn)); % s is the solution of the equaition g(x)=0
V_En = [];  %V_En is a list that store all the epsilon in each iteraion
for i=1:length(V_xn) %this loop calculate the epsilon in each iteration
    V_En =[V_En;abs(V_xn(i)-s)];
end
    
T_A = table(num_of_iteration, V_xn, V_En, V_error,'VariableNames',{'Iteration' 'Xn' 'En' 'error'});
disp (T_A)



%--------------Question 4---------------------
clear all
%section A
xn = pi/2;
V_xn = [xn]; %V_xn is a list that store all the xn values from the iteration
V_error = [1]; %V_error is a list that store the distance between xn+1-xn
counter = 0;
num_of_iteration = [0];
%This loop perform the starday point ;) method and calculat the solution of the g(x)=x equaition
while V_error(length(V_error)) > 10^(-12) 
    xn_plus_1 = h(xn);
    V_error = [V_error; abs(xn_plus_1 - xn)];
    counter = counter + 1;
    num_of_iteration = [num_of_iteration; counter];
    xn = xn_plus_1;
    V_xn = [V_xn;xn];
end
s= V_xn(length(V_xn)); % s is the solution of the equaition g(x)=x
V_En = [];  %V_En is a list that store all the epsilon in each iteraion
for i=1:length(V_xn) %this loop calculate the epsilon in each iteration
    V_En =[V_En;abs(V_xn(i)-s)];
end
T = table(num_of_iteration, V_xn, V_En, V_error,'VariableNames',{'Iteration' 'Xn' 'En' 'error'});
disp (T)
En_minus_1 =log(V_En(2:59));
V_En = log(V_En(3:60));
figure(5)
plot(En_minus_1, V_En)
title('log(En) as a function of log(En-1)')
xlabel('log(En-1)')
ylabel('log(En)')

%section B
clear all
xn = pi/2; 
V_xn = [xn];%V_xn is a list that store all the xn values from the iteration
V_error = [1]; %V_error is a list that store the distance between xn+1-xn
counter = 0;
num_of_iteration = [0];
while V_error(length(V_error)) > 10^(-12) %This loop perform the newton raphson method and calculat the solution of the L(x)=0 equaition
    xn_plus_1 = xn - L(xn)/L_tag(xn);
    V_error = [V_error; abs(xn_plus_1 - xn)];
    counter = counter + 1;
    num_of_iteration = [num_of_iteration; counter];
    xn = xn_plus_1;
    V_xn = [V_xn;xn];
end
s= V_xn(length(V_xn)); % s is the solution of the equaition L(x)=0
V_En = [];  %V_En is a list that store all the epsilon in each iteraion
for i=1:length(V_xn) %this loop calculate the epsilon in each iteration
    V_En =[V_En;abs(V_xn(i)-s)];
end
T = table(num_of_iteration, V_xn, V_En, V_error,'VariableNames',{'Iteration' 'Xn' 'En' 'error'});
disp (T)
En_minus_1 =log(V_En(2:5));
V_En = log(V_En(3:6));
figure(6)
plot(En_minus_1, V_En)
title('log(En) as a function of log(En-1)')
xlabel('log(En-1)')
ylabel('log(En)')

%section D
clear all
xn = 1 ;
V_xn = [xn]; %V_xn is a list that store all the xn values from the iteration
V_error = [1]; %V_error is a list that store the distance between xn+1-xn
counter = 0;
num_of_iteration = [0];
%This loop perform the starday point ;) method and calculat the solution of the q(x)=x equaition
while V_error(length(V_error)) > 10^(-12) 
    xn_plus_1 = q(xn);
    V_error = [V_error; abs(xn_plus_1 - xn)];
    counter = counter + 1;
    num_of_iteration = [num_of_iteration; counter];
    xn = xn_plus_1;
    V_xn = [V_xn;xn];
end
s= V_xn(length(V_xn)); % s is the solution of the equaition q(x)=0
V_En = [];  %V_En is a list that store all the epsilon in each iteraion
for i=1:length(V_xn) %this loop calculate the epsilon in each iteration
    V_En =[V_En;abs(V_xn(i)-s)];
end
T = table(num_of_iteration, V_xn, V_En, V_error,'VariableNames',{'Iteration' 'Xn' 'En' 'error'});
disp (T)
En_minus_1 =log(V_En(2:39));
V_En = log(V_En(3:40));
figure(7)
plot(En_minus_1, V_En)
title('log(En) as a function of log(En-1)')
xlabel('log(En-1)')
ylabel('log(En)')



%---------------------------functions--------------------------------------    
    
    
function y = f(x)
y=x^(4)-3;
end
function y = f_tag(x)
y = 4*x^(3);
end
function y = g(x)
y = x^5-6*x^4+14*x^3-20*x^2+24*x-16;
end
function y = g_tag(x)
y = 5*x^4-24*x^3+42*x^2-40*x+24;
end
function y= u(x)
y = ((x - 2)*(x^2 + 2))/(5*x^2 - 4*x + 6);
end
function y = u_tag(x)
y = (5*x^4 - 8*x^3 + 16*x^2 + 16*x - 4)/(5*x^2 - 4*x + 6)^2;
end
function y = h(x)
y = 2*sin(x);
end
function y = L(x)
y = x-2*sin(x);
end
function y = L_tag(x)
y = 1-2*cos(x);
end
function y = q(x)
y = asin(x/2);
end









