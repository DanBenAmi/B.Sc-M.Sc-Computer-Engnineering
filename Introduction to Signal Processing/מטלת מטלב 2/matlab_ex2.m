%Tom kessous 206018749
%Dan Ben Ami 316333079

%----------------------- Question 1 ----------------------
%----------------------- Section A ----------------------
N = 30;
n = 0:1:N-1;
teta1 = pi/10.25;
teta2 = 2*pi/5;
s_n = 2*cos(teta1*n);
v_n = 3*sin(teta2*n);
x_n = s_n + v_n;
figure(1)
figure(1)
plot(n,s_n,'*-b','linewidth',1.5,'MarkerSize',6);
hold on;
plot(n,v_n,'*-r','linewidth',1.5,'MarkerSize',6);
plot(n,x_n,'*-g','linewidth',1.5,'MarkerSize',6);
legend('s[n]','v[n]','x[n]');
title('Question 1-A: x[n],s[n],v[n]');
xlabel('Discrete time - n','FontSize',12);
ylabel('x[n],v[n],s[n]','FontSize',12);

%==========================================
Xd_k = fft(x_n);
sd_k = fft(s_n);
vd_k = fft(v_n);
figure(2)
stem(n,abs(sd_k),'b','linewidth',2.5,'MarkerSize',6);
hold on;
stem(n,abs(vd_k),'r','linewidth',2.5,'MarkerSize',6);
stem(n,abs(Xd_k),'--g','linewidth',2.5,'MarkerSize',6);
legend('S[k]','V[k]','X[k]');
title('Question 1-A: S[k], V[k], X[k]');
xlabel('Discrete frequency - k','FontSize',12);
ylabel('X[k],V[k],S[k]','FontSize',12);

%----------------------- Section B ----------------------
k = 0:1:44;
xz_n = [x_n,zeros(1,15)];
Xz_k = fft(xz_n);
k = 0:30/45:30-30/45;
figure(3)
stem(k,abs(Xz_k),'g','linewidth',1.5,'MarkerSize',6);
hold on;
stem(n,abs(Xd_k),'--r','linewidth',1.5,'MarkerSize',6);
legend('Xz[k]','X[k]');
title('Question 1-B: Xz[k], X[k]');
xlabel('Discrete frequency (normalized for Xz[k]) - k','FontSize',12);
ylabel('Xz[k],X[k]','FontSize',12);

%----------------------- Section C ----------------------
n1 = 0:1:N+15-1;
s_n1 = 2*cos(teta1*n1);
v_n1 = 3*sin(teta2*n1);
x2_n1 = s_n1 + v_n1;
X2_k = fft(x2_n1);
figure(4)
stem(k,abs(X2_k),'g','linewidth',1.5,'MarkerSize',6);
hold on;
stem(n,abs(Xd_k),'--r','linewidth',1.5,'MarkerSize',6);
legend('X2[k]','X[k]');
title('Question 1-C: X2[k], X[k]');
xlabel('Discrete frequency (normalized for X2[k]) - k','FontSize',12);
ylabel('X2[k],X[k]','FontSize',12);

%----------------------- Section D ----------------------
xn_parseval = x_n*x_n';
Xk_parseval = Xd_k*Xd_k'*1/N;

xz_n_parseval = xz_n*xz_n';
Xz_k_parseval = Xz_k*Xz_k'*1/(N+15);

%----------------------- Section E ----------------------
teta = 0:1/100:2*pi;
H1f_teta = (1/3)*(1+exp(-1i*teta)+exp(-2i*teta));
k = 0:1:N-1;
teta_sampeld = k.*2*pi/N;
figure(5)
plot(teta,abs(H1f_teta),'linewidth',1.5,'MarkerSize',6);
hold on
stem(teta_sampeld,abs(Xd_k),'linewidth',1.5,'MarkerSize',6);
legend('Hf(teta)','X[k]');
title('Question 1-E: Hf(teta), X[k]');
xlabel('frequency- teta','FontSize',12);
ylabel('Hf(teta),X[k]','FontSize',12);

x_n_padded =[x_n, zeros(1,2)];
h_n =[1/3,1/3,1/3, zeros(1,N-1)];
Y1d_k = fft(x_n_padded).*fft(h_n);
k = 0:1:N-1;
y1_n = ifft(Y1d_k);
Y1d_k = Y1d_k(1:N);
y1_n = y1_n(1:N);
figure(6)
stem(k,abs(Xd_k),'linewidth',1.5,'MarkerSize',6);
hold on
stem(k,abs(Y1d_k),'--g','linewidth',1.5,'MarkerSize',6);
legend('X[k]','Y1[k]');
title('Question 1-E: X[k],Y1[k]');
xlabel('Discrete frequency - k','FontSize',12);
ylabel('X[k],Y1[k]','FontSize',12);

figure(7)
stem(n,x_n,'linewidth',1.5,'MarkerSize',6);
hold on
stem(n,v_n,'--','linewidth',1.5,'MarkerSize',6);
stem(n,s_n,'linewidth',1.5,'MarkerSize',6);
stem(n,y1_n,'--','linewidth',1.5,'MarkerSize',6);
legend('x[n]','v[n]','s[n]','y1[n]');
title('Question 1-E: x[n],v[n],s[n],y1[n]');
xlabel('Discrete time - n','FontSize',12);
ylabel('x[n],v[n],s[n],y1[n]','FontSize',12);

%----------------------- Section F ----------------------
x_n_padded =[x_n, zeros(1,1)];
h2_n =[1,1, zeros(1,N-1)];
Y2d_k = fft(x_n_padded).*fft(h2_n);
y2_n = ifft(Y2d_k);     
Y2d_k = Y2d_k(1:N);
y2_n = y2_n(1:N);
H2f_teta = 1+exp(-1i*teta);
figure(8)
plot(teta,abs(H2f_teta),'linewidth',1.5,'MarkerSize',6);
hold on
stem(teta_sampeld,abs(Xd_k),'linewidth',1.5,'MarkerSize',6);
legend('H2f(teta)','X[k]');
title('Question 1-F: H2f(teta), X[k]');
xlabel('frequency- teta','FontSize',12);
ylabel('H2f(teta),X[k]','FontSize',12);

k = 0:1:N-1;
figure(9)
stem(k,abs(Xd_k),'linewidth',1.5,'MarkerSize',6);
hold on
stem(k,abs(Y2d_k),'--g','linewidth',1.5,'MarkerSize',6);
legend('X[k]','Y2[k]');
title('Question 1-E: X[k],Y2[k]');
xlabel('Discrete frequency - k','FontSize',12);
ylabel('X[k],Y2[k]','FontSize',12);


figure(10)
stem(n,x_n,'linewidth',1.5,'MarkerSize',6);
hold on
stem(n,v_n,'--','linewidth',1.5,'MarkerSize',6);
stem(n,s_n,'linewidth',1.5,'MarkerSize',6);
stem(n,y2_n,'--','linewidth',1.5,'MarkerSize',6);
legend('x[n]','v[n]','s[n]','y2[n]');
title('Question 1-E: x[n],v[n],s[n],y2[n]');
xlabel('Discrete time - n','FontSize',12);
ylabel('x[n],v[n],s[n],y2[n]','FontSize',12);

%----------------------- Question 2 ----------------------
%----------------------- Section D ----------------------
clear all;
load('data2020.mat');
x_test_padded = [x_test,zeros(1,length(y_z)-length(x_test))];
y0 = y_test-y_z;
H_recover = fft(x_test_padded)./fft(y0);
h_recover = ifft(H_recover);
n = 0:1:length(y_test)-1;
figure(11)
plot(n,h_recover);
title('Question 2-D: h-recover[n]');
xlabel('Discrete time - n','FontSize',12);
ylabel('h-recover[n]','FontSize',12);

%----------------------- Section E ----------------------

x_rec = ifft(fft(y-y_z).*H_recover);
figure(12)
plot(n,y);
hold on
plot(n,x_rec,'g');
legend('y[n]','x-recover[n]');
title('Question 1-E: y[n],x-recover[n]');
xlabel('Discrete time - n','FontSize',12);
ylabel('y[n],x-recover[n]','FontSize',12);
%----------------------- Section F ----------------------
soundsc(x_rec,44100);









