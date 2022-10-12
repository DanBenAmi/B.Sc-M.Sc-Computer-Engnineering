% Tom kessous - 206018749
% Dan ben ami - 316333079

global q_plus
global q_minus
global r
global delta

q_plus = 67;
q_minus = -54;

% ------------ Question 1 ------------

% section 1.A:

r = 0.05;
delta = 0.005;
i = 1;
array_n = [1,2,3,4,0];
while array_n(i) ~= 0
    global n;
    n = array_n(i)  ;
    i = i + 1;
    global teta_x;
    global teta_y;
    teta_x = [];
    teta_y = [];
    for j = 0:n
        teta_x = [teta_x, j*(pi/n)];
        teta_y = [teta_y, phi(teta_x(j+1))];
    end
    n_gag = 40;
    phi_gag = [];
    global x
    x = [];
    for h = 0:n_gag
        phi_gag = [phi_gag, Lag(h*pi/n_gag)];
        x = [x, h*pi/n_gag];
    end
    global acuurate_val
    acuurate_val =[];
    for j = 0:n_gag
        acuurate_val = [acuurate_val, phi(x(j+1))];
    end
    figure(1)
    plot(x,phi_gag)
    hold on
end
title('Question 1 - section A')
plot(x,acuurate_val,'-o')
xlabel('angle')
ylabel('electro static field')
legend({'n+1=2','n+1=3', 'n+1=4', 'n+1=5','acuurate value'},'location','northeast');
hold off
    
% section 1.B:
error = [] ; 
n_list =[] ;
for n = 1:2:19
    teta_x = [];
    teta_y = [];
    for j = 0:n
        teta_x = [teta_x, j*(pi/n)];
        teta_y = [teta_y, phi(teta_x(j+1))];
    end
    n_list = [n_list, n];
    error = [error, epsilon()] ;
end 

figure(2)
semilogy (n_list, error, 'LineWidth',1.5)
xlabel('N')
ylabel('relative error')
title('question 1 - section B')


% section 1.C:
 

r = 0.004;
array_n = [2, 6, 10, 14, 0];
i = 1;
while array_n(i) ~= 0
    global n;
    n = array_n(i)  ;
    i = i + 1;
    global teta_x;
    global teta_y;
    teta_x = [];
    teta_y = [];
    for j = 0:n
        teta_x = [teta_x, j*(pi/n)];
        teta_y = [teta_y, phi(teta_x(j+1))];
    end
    n_gag = 40;
    phi_gag = [];
    global x
    x = [];
    for h = 0:n_gag
        phi_gag = [phi_gag, Lag(h*pi/n_gag)];
        x = [x, h*pi/n_gag];
    end
    global acuurate_val
    acuurate_val =[];
    for j = 0:n_gag
        acuurate_val = [acuurate_val, phi(x(j+1))];
    end
    figure(3)
    plot(x,phi_gag)
    hold on
end
title('Question 1 - section C')
plot(x,acuurate_val,'-o')
xlabel('angle')
ylabel('electro static field')
legend({'n+1=3','n+1=7', 'n+1=11', 'n+1=15','acuurate value'},'location','northeast');
hold off

error = [] ; 
n_list =[] ;
for n = 1:2:19
    teta_x = [];
    teta_y = [];
    for j = 0:n
        teta_x = [teta_x, j*(pi/n)];
        teta_y = [teta_y, phi(teta_x(j+1))];
    end
    n_list = [n_list, n];
    error = [error, epsilon()] ;
end 

figure(4)
semilogy (n_list, error, 'LineWidth',1.5)
xlabel('N')
ylabel('relative error')
hold on

% section 1.D:

i = 1;
while array_n(i) ~= 0
    global n;
    n = array_n(i)  ;
    i = i + 1;
    global teta_x;
    global teta_y;
    teta_x = [];
    teta_y = [];
    for j = 0:n
        teta_x = [teta_x, chbi(j,n)];
        teta_y = [teta_y, phi(teta_x(j+1))];
    end
    n_gag = 40;
    phi_gag = [];
    for h = 0:n_gag
        phi_gag = [phi_gag, Lag(x(h+1))];
    end
    global acuurate_val
    acuurate_val =[];
    for j = 0:n_gag
        acuurate_val = [acuurate_val, phi(x(j+1))];
    end
    figure(5)
    plot(x,phi_gag)
    hold on
end
title('Question 1 - section D1')
plot(x,acuurate_val,'-o')
xlabel('angle')
ylabel('electro static potential')
legend({'n+1=3','n+1=7', 'n+1=11', 'n+1=15','acuurate value'},'location','northeast');
hold off

error = [] ; 
n_list =[] ;
for n = 1:2:19
    teta_x = [];
    teta_y = [];
    for j = 0:n
        teta_x = [teta_x, chbi(j,n)];
        teta_y = [teta_y, phi(teta_x(j+1))];
    end
    n_list = [n_list, n];
    error = [error, epsilon()] ;
end 

figure(4)
semilogy (n_list, error, 'LineWidth',1.5)
xlabel('N')
ylabel('relative error')
title('Question 1 - section D2')
legend({'relative error (equal intervals) 1.C' , 'relative error (chebyshev) 1.D' },'location','northeast');
hold off


% ------------ Question 2 ------------
% section 2.B:
r = 0.1;
a_gag = [];
for n = 1:3
    teta_x = [];
    teta_y = [];
    for i = 0:n
        teta_x = [teta_x, i*pi/n];
        teta_y = [teta_y, phi(teta_x(i+1))];
    end
    v= [];
    for i = 1:n+1
        v = [v ; 1, sin(teta_x(i)), cos(teta_x(i))];
    end
    teta_y = teta_y';
    global a
    a =  (inv(v'*v)*v'*teta_y);
    a_gag = [a_gag ;a'] ;
    teta_ls = [];
    for i = 0:n_gag
        teta_ls = [teta_ls, phi_ls(x(i+1), a(1), a(2), a(3))];
    end
    
    figure(6)
    plot(x,teta_ls, 'LineWidth',1.5)
    hold on
end
acuurate_val =[];
    for j = 0:n_gag
        acuurate_val = [acuurate_val, phi(x(j+1))];
    end
plot(x, acuurate_val,'-o', 'LineWidth',1.5)
title('Question 2 - section 2B')
xlabel('angle')
ylabel('electro static field')
legend({'n+1=2','n+1=3', 'n+1=4', 'acuurate value'},'location','northeast')
hold off

% section 2.C:

r = 10 ;
r_list = [];
error = [];
for i = 0:8
    r_list = [r_list, r/(2^i)];
end

for i = 1:9
    r = r_list(i);
    acuurate_val =[];
    for j = 0:n_gag
        acuurate_val = [acuurate_val, phi(x(j+1))];
    end
    teta_y=[];
    for i = 0:n
        teta_y = [teta_y, phi(teta_x(i+1))];
    end
     v= [];
    for i = 1:n+1
        v = [v ; 1, sin(teta_x(i)), cos(teta_x(i))];
    end
    teta_y = teta_y';
    a =  (inv(v'*v)*v'*teta_y);
    teta_ls = [];
    for i = 0:n_gag
        teta_ls = [teta_ls, phi_ls(x(i+1), a(1), a(2), a(3))];
    end
    
    error = [error, epsilon_ls()];
end
figure(7)
loglog(r_list, error,'-*', 'LineWidth',1.5)
title('Relative error with different radios')
xlabel('n+1')
ylabel('relative error (LS)')

% section 2.D:

r = 0.1;
error = [];
delta_j = 1+(rand -0.5)*10^(-1);
n_list = [];
for i = 0:16
    n_list = [n_list, (4*2^i)-1];
end
acuurate_val =[];
    for j = 0:n_gag
        acuurate_val = [acuurate_val, phi(x(j+1))];
    end
    
for p = 1:17
    n = n_list(p);
    teta_x = [];
    teta_y = [];
    teta_x = linspace(0,pi,n+1);
    for i = 0:n
        delta_j = 1+(rand -0.5)*10^-1;
        %teta_x = [teta_x, i*pi/n];
        teta_y = [teta_y, phi(teta_x(i+1)) * delta_j];
    end
    v= zeros(n,3);
    v(:,1)= 1;
    for i = 1:(n+1)
        v(i,2) = sin(teta_x(i));
        v(i,3) = cos(teta_x(i));
       % v = [v ; 1, sin(teta_x(i)), cos(teta_x(i))];
    end
    teta_y = teta_y';
    global a
    a =  (inv(v'*v)*v'*teta_y);
    a_gag = [a_gag ;a'] ;
    teta_ls = [];
    for i = 0:n_gag
        teta_ls = [teta_ls, phi_ls(x(i+1), a(1), a(2), a(3))];
    end
    error = [error, epsilon_ls()];
end
figure(8)
loglog(n_list, error, 'LineWidth',1.5)
title('relative error to to the accurate values of potential as function of n') 
xlabel('n+1')
ylabel('relative error (LS)')
% ------------ Question 3 ------------
r = 0.1;
n_list = [];
I_t_1_list = [];
I_t_2_list = [];
I_t_3_list = [];
I_s_1_list = [];
I_s_2_list = [];
I_s_3_list = [];
error_t_1 = [];
error_t_2 = [];
error_t_3 = [];
error_s_1 = [];
error_s_2 = [];
error_s_3 = [];
for i = 2:9
    n_list = [n_list, 2^i];
end
for i = 1:length(n_list)
    n = n_list(i);
    x = linspace(0,pi,(n+1));
    I_t_1 = 0 ;
    for i = 1:(length(x)-1)
        I_t_1 = I_t_1 + trapez(x(i), x(i+1), phi(x(i)), phi(x(i+1)));
    end
    I_t_1_list = [I_t_1_list, I_t_1];
    
    I_t_2 = 0 ;
    for i = 1:(length(x)-1)
        I_t_2 = I_t_2 + trapez(x(i), x(i+1), sin(x(i)) * phi(x(i)), sin(x(i+1))*phi(x(i+1)));
    end
    I_t_2_list = [I_t_2_list, I_t_2];
    
    I_t_3 = 0 ;
    for i = 1:(length(x)-1)
        I_t_3 = I_t_3 + trapez(x(i), x(i+1), cos(x(i)) * phi(x(i)), cos(x(i+1))*phi(x(i+1)));
    end
    I_t_3_list = [I_t_3_list, I_t_3];
    
    
    
    I_s_1 = 0 ;
    for i = 1:2:(length(x)-2)
        I_s_1 = I_s_1 + simphson(x(i), x(i+2), phi(x(i)), phi(x(i+1)), phi(x(i+2)));
    end
    I_s_1_list = [I_s_1_list, I_s_1];
    
    I_s_2 = 0 ;
    for i = 1:2:(length(x)-2)
        I_s_2 = I_s_2 + simphson(x(i), x(i+2), sin(x(i))*phi(x(i)), sin(x(i+1))*phi(x(i+1)), sin(x(i+2))*phi(x(i+2)));
    end
    I_s_2_list = [I_s_2_list, I_s_2];
    
    I_s_3 = 0 ;
    for i = 1:2:(length(x)-2)
        I_s_3 = I_s_3 + simphson(x(i), x(i+2), cos(x(i))*phi(x(i)), cos(x(i+1))*phi(x(i+1)), cos(x(i+2))*phi(x(i+2)));
    end
    I_s_3_list = [I_s_3_list, I_s_3];
   
end
    
for i = 1:7
      
    error_t_1 = [error_t_1, abs((I_t_1_list(i)-I_t_1_list(8))/ I_t_1_list(8)) ];
    error_t_2 = [error_t_2, abs((I_t_2_list(i)-I_t_2_list(8))/ I_t_2_list(8))];
    error_t_3 = [error_t_3, abs((I_t_3_list(i)-I_t_3_list(8))/ I_t_3_list(8))];
    error_s_1 = [error_s_1, abs((I_s_1_list(i)-I_s_1_list(8))/ I_s_1_list(8))];
    error_s_2 = [error_s_2, abs((I_s_2_list(i)-I_s_2_list(8))/ I_s_2_list(8))];
    error_s_3 = [error_s_3, abs((I_s_3_list(i)-I_s_3_list(8))/ I_s_3_list(8))];
end
n_plus1 = n_list+1;
n_plus1 = n_plus1(1:7);
figure(9)
semilogy(n_plus1, error_t_1, 'LineWidth',1.5)
hold on
semilogy(n_plus1, error_t_2, 'LineWidth',1.5)
semilogy(n_plus1, error_t_3, 'LineWidth',1.5)
semilogy(n_plus1, error_s_1, 'LineWidth',1.5)
semilogy(n_plus1, error_s_2, 'LineWidth',1.5)
semilogy(n_plus1, error_s_3, 'LineWidth',1.5)
legend({'f1 Trapez','f2 Trapez', 'f3 Trapez', 'f1 simpsom','f2 simpson', 'f3 simpson'},'location','northeast');
xlabel('n+1')
ylabel('Relative error')
hold off




function y = phi_ls(x, alpha, beta, gamma)
y = alpha + beta*sin(x)+ gamma*cos(x);
end

function y = chbi(x,n)
p = cos((2*x+1)/(2*n+2)*pi);
y = pi/2*p + pi/2;
end

function y = epsilon(~)
global x
global acuurate_val
sum = 0 ;
mechane = 0 ;
for i = 1:length(x)
    sum = sum + (Lag(x(i))-acuurate_val(i))^2 ;
    mechane = mechane + (acuurate_val(i))^2 ;
end
y = sqrt(sum) / sqrt(mechane);
end

function y = phi(x)
global q_plus
global q_minus
global r
global delta
    function K = r_plus(x)
    K = sqrt((r*cos(x))^2+(r*sin(x)-(delta/2))^2);
    end
    function L = r_minus(x)
    L = sqrt((r*cos(x))^2+(r*sin(x)+(delta/2))^2);
    end
r_p = r_plus(x);
r_m = r_minus(x);
y = q_plus/(4*pi*(r_p)) + q_minus/(4*pi*(r_m));
end

function y = Lag(tg)
global teta_y;
global teta_x;
global n;
lag = 0;
    function y = l(x,k)
    T = 1;
    for i = 0:n
        if i ~= k
            T = T*(x-teta_x(i+1))/(teta_x(k+1)-teta_x(i+1));
        end
    end
    y=T;
    end
for k = 0:n
    lag = lag + teta_y(k+1)*l(tg,k);
end
y = lag;
end

function y = epsilon_ls(~)
global x
global acuurate_val
global a
sum = 0 ;
mechane = 0 ;
for i = 1:length(x)
    sum = sum + (phi_ls(x(i), a(1), a(2), a(3))-acuurate_val(i))^2 ;
    mechane = mechane + (acuurate_val(i))^2 ;
end
y = sqrt(sum) / sqrt(mechane);
end

function y = trapez(a, b, ga, gb)
y = 0.5 * (b-a) * (ga + gb);
end

function y = simphson(a, b, ga,gab, gb)
y = (b-a)/6 * (ga + 4*gab + gb);
end

