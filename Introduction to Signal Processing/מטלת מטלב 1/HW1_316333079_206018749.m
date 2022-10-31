% Dan Ben Ami- 316333079        Tom Kessous- 206018749
%-------------Question1--------------------
%-------------section A -------------------
wm = 3*pi;
t = 0.2:1/100:3;        %Time line
x = 4./(wm*pi*t.^2).*(sin(wm*t)).^2.*(cos(wm*t)).*(sin(2*wm*t));      %All the value of x(t) at each point of t.
figure(1);
plot(t,x);
xlabel('t [sec]');
ylabel('x(t)');
title('continuous signal - x(t)');
%-------------section B -------------------
w = -17*pi:1/100:17*pi;             %Omega line.
XF = 2/1i*(triangularPulse(-3*wm,5*wm,w)-triangularPulse(-5*wm,3*wm,w));    %Transform fourier
figure(2);
plot(w,abs(XF));
xlabel('w [rad/sec]');
ylabel('XF(w)');
title('Fourier transform of - x(t)');
%-------------section C -------------------
Ts = 1/15;              %Sampaling time
tn = 0.2:Ts:3;          %Sampaling points
xn = 4./(wm*pi*tn.^2).*(sin(wm*tn)).^2.*(cos(wm*tn)).*(sin(2*wm*tn));   %Discrite X[n].
figure(3);
stairs(tn,xn);      %ZOH of x[n]
hold on;
plot(t,x);
xlabel('t [sec]');
ylabel('x(t)');
title('ZOH x(t) Vs continuous x(t)');
plot(tn,xn,'*r');
legend([{'ZOH - x(t)'};{'x(t)'};{'x[nTs]'}]);
%-------------section D -------------------
XFzoh = [XF(9424:10052),XF(628:10052),XF(628:1255)];    %Multiply of XF(w).
XFzoh = XFzoh.*sinc(w*Ts/(2*pi)).*exp(-1i*w*Ts/2);      %XF_ZOH(w)
figure(4);
plot(w,abs(XFzoh));
xlabel('w [rad]');
ylabel('XFzoh');
title('Fourier transform of xzoh(t)');
%-------------section E -------------------
XFrec =  XFzoh./sinc(w*Ts/(2*pi)).*exp(1i*w*Ts/2);
rect = [zeros(1,628),ones(1,9425),zeros(1,629)];
XFrec = XFrec.*rect;            %XFrect(w) = XFzoh(w)*H(w)
Xrec = 0*t;
for n=1:281
    Xrec(n) = (1/(2*pi))*trapz(w,(XFrec.*exp(1i*w*t(n))));      %Inverse fourier transporm to get xrect(t)
end
figure(5);
plot(t,x,'LineWidth',1.5);
hold on
plot(t,Xrec,'--y','LineWidth',1.5);
xlabel('t [sec]');
ylabel('x(t)& xrect(t)');
title('xrect(t) Vs. x(t)');
legend([{'x(t)'};{'xrect(t)'}]);
%--------section F --------------------
Ts = 2/27;              
tn = 0.2:Ts:3;      
xn = 4./(wm*pi*tn.^2).*(sin(wm*tn)).^2.*(cos(wm*tn)).*(sin(2*wm*tn));
XFzoh =[zeros(1,628),XF(628:10053),zeros(1,628)];
Xshicpulim = [XF(8482:10682),zeros(1,6283),XF(1:2198)];
XFzoh = XFzoh + Xshicpulim;
XFzoh = XFzoh .* sinc(w*Ts/(2*pi)).*exp(-1i*w*Ts/2);
XFrec = XFzoh ./ sinc(w*Ts/(2*pi)).*exp(1i*w*Ts/2);
rect = [zeros(1,1099),ones(1,8484),zeros(1,1099)];
XFrec = XFrec .* rect;
Xrec = 0*t;
for n=1:281
Xrec(n)= 1/(2*pi)*trapz(w,XFrec.*exp(1i*w*t(n)));
end
figure(6);
plot(t,Xrec,'b','LineWidth',1.5,'MarkerSize',10);
hold on
plot(t,x,'--r','LineWidth',1.5,'MarkerSize',10);
xlabel("t [sec]"); ylabel("x(t) Vs Xrec(t)");
title("continous signal - x(t) sampled in Ws=9Wm VS Output Xrec(t)");
legend([{'Xrec(t)'};{'x(t)'}]);

%-------------Question2--------------------
%-------------section A -------------------
clear all;
WA = 7*pi;
WB = 4*pi;
tn = 0:2/15:(2-2/15);       %Uniform sampling of the time line.
t = 0:1/100:2;              %Time line.
x = 5*cos(WA*t)-3*sin(WB*t);    %Continus signal x(t)
xn = 5*cos(WA*tn)-3*sin(WB*tn); %Discrite signal x[n]
figure(7);
plot(t,x);
hold on;
plot(tn,xn,'*r');
xlabel('t [sec]');
ylabel('x(t)');
title('Uniform 15 sampling: x[n] Vs continuous x(t)');
legend([{'x(t)'};{'x[n]'}]);
%-------------section B -------------------
F = zeros(15);
for n=1:15
    for m=1:15
        F(n,m) = exp(1i*(m-8)*pi*tn(n));        %Fourier matrix.
    end
end
a = pinv(F)*xn.';               %a from fourier series
%-------------section C -------------------
X_kova = 0*t;           %the recoverd x(t) from x[n]
sum = 0;
for k=1:201
    for n=1:15
    sum = sum +a(n)*exp(1i*(n-8)*pi*t(k));  %Fourier series
    end
    X_kova(k) = sum;
    sum = 0;
end
figure(8);
plot(t,x);
hold on;
plot(t,X_kova,'--y');
xlabel('t [sec]');
ylabel('x(t)');
title(' x(t) Recovered Vs x(t)');
legend([{'x(t)'};{'x(t) Recovered'}]);
%-------------section D -------------------
clear all;
WA = 7*pi;
WB = 4*pi;
tn = 2*rand(1,15);      %Random sampling
t = 0:1/100:2;
x = 5*cos(WA*t)-3*sin(WB*t);
xn = 5*cos(WA*tn)-3*sin(WB*tn);
figure(9);
plot(t,x);
hold on;
plot(tn,xn,'*r');
xlabel('t [sec]');
ylabel('x(t)');
title('Random 15 sampling: x[n] Vs continuous x(t)');
legend([{'x(t)'};{'x[n]'}]);

F = zeros(15);
for n=1:15
    for m=1:15
        F(n,m) = exp(1i*(m-8)*pi*tn(n));
    end
end
a = pinv(F)*xn.';
X_kova = 0*t;
sum = 0;
for k=1:201
    for n=1:15
    sum = sum +a(n)*exp(1i*(n-8)*pi*t(k));
    end
    X_kova(k) = sum;
    sum = 0;
end
figure(10);
plot(t,x);
hold on;
plot(t,X_kova,'--y');
xlabel('t [sec]');
ylabel('x(t)');
title('Random 15 sampling: x(t)Recovered Vs x(t)');
legend([{'x(t)'};{'x(t) Recovered'}]);
%-------------section E -------------------
clear all;
WA = 7*pi;
WB = 4*pi;
tn = 0:2/15:(2-2/15);       %Uniform sampling
t = 0:1/100:2;
x = 5*cos(WA*t)-3*sin(WB*t);
xn = 5*cos(WA*tn)-3*sin(WB*tn);
figure(11);
plot(t,x);
hold on;
plot(tn,xn,'*r');
xlabel('t [sec]');
ylabel('x(t)');
title('Uniform 15 sampling: x[n] Vs continuous x(t)');
legend([{'x(t)'};{'x[n]'}]);
tn_noisy = 0*tn;
F = zeros(15);
for n=1:15
    tn_noisy = tn(n)+0.01*rand(1);
    for m=1:15
        F(n,m) = exp(1i*(m-8)*pi*(tn_noisy));         %Noise
    end
end
a = pinv(F)*xn.';
cd = cond(F);
X_kova = 0*t;
sum = 0;
for k=1:201
    for n=1:15
    sum = sum +a(n)*exp(1i*(n-8)*pi*t(k));
    end
    X_kova(k) = sum;
    sum = 0;
end
figure(12);
plot(t,x);
hold on;
plot(t,X_kova);
xlabel('t [sec]');
ylabel('x(t)');
title('F noise - Uniform 15 sampling: x(t) Recovered Vs x(t)');
legend([{'x(t)'};{'x(t) Recovered'}]);
%--------- Random sampling---------------------
clear all;
WA = 7*pi;
WB = 4*pi;
tn = 2*rand(1,15);          %Random sampling
t = 0:1/100:2;
x = 5*cos(WA*t)-3*sin(WB*t);
xn = 5*cos(WA*tn)-3*sin(WB*tn);
figure(13);
plot(t,x);
hold on;
plot(tn,xn,'*r');
xlabel('t [sec]');
ylabel('x(t)');
title('Random 15 sampling: x[n] Vs continuous x(t)');
legend([{'x(t)'};{'x[n]'}]);

tn_noisy = 0*tn;
F = zeros(15);
for n=1:15
    tn_noisy = tn(n)+0.01*rand(1);
    for m=1:15
        F(n,m) = exp(1i*(m-8)*pi*(tn_noisy));         %Noise
    end
end
a = pinv(F)*xn.';
cd = cond(F);
X_kova = 0*t;
sum = 0;
for k=1:201
    for n=1:15
    sum = sum +a(n)*exp(1i*(n-8)*pi*t(k));
    end
    X_kova(k) = sum;
    sum = 0;
end
figure(14);
plot(t,x);
hold on;
plot(t,X_kova);
xlabel('t [sec]');
ylabel('x(t)');
title('F noise - Random 15 sampling -  x(t) Recovered Vs x(t)');
legend([{'x(t)'};{'x(t) Recovered'}]);
%-------------section F -------------------
clear all;
WA = 7*pi;
WB = 4*pi;
tn = 0:2/40:(2-2/40);       %40 uniform sampling
t = 0:1/100:2;
x = 5*cos(WA*t)-3*sin(WB*t);
xn = 5*cos(WA*tn)-3*sin(WB*tn);
figure(15);
plot(t,x);
hold on;
plot(tn,xn,'*r');
xlabel('t [sec]');
ylabel('x(t)');
title('Uniform 40 sampling: x[n] Vs continuous x(t)');
legend([{'x(t)'};{'x[n]'}]);

tn_noisy = 0*tn;
F = zeros(40,15);
for n=1:40
    tn_noisy = tn(n)+0.01*rand(1);
    for m=1:15
        F(n,m) = exp(1i*(m-8)*pi*(tn_noisy));         %Noise
    end
end
a = pinv(F)*xn.';
cd = cond(F);
X_kova = 0*t;
sum = 0;
for k=1:201
    for n=1:15
    sum = sum +a(n)*exp(1i*(n-8)*pi*t(k));
    end
    X_kova(k) = sum;
    sum = 0;
end
figure(16);
plot(t,x);
hold on;
plot(t,X_kova);
xlabel('t [sec]');
ylabel('x(t)');
title('F noise - Uniform 40 sampling: x(t) Recovered Vs x(t)');
legend([{'x(t)'};{'x(t) Recovered'}]);
%--------- Random sampling ---------------------
clear all;
WA = 7*pi;
WB = 4*pi;
tn = 2*rand(1,40);      % 40 Random sampling
t = 0:1/100:2;
x = 5*cos(WA*t)-3*sin(WB*t);
xn = 5*cos(WA*tn)-3*sin(WB*tn);
figure(17);
plot(t,x);
hold on;
plot(tn,xn,'*r');
xlabel('t [sec]');
ylabel('x(t)');
title('Random 40 sampling: x[n] Vs continuous x(t)');
legend([{'x(t)'};{'x[n]'}]);
tn_noisy = 0*tn;
F = zeros(40,15);
for n=1:40
    tn_noisy = tn(n)+0.01*rand(1);
    for m=1:15
        F(n,m) = exp(1i*(m-8)*pi*(tn_noisy));         %Noise
    end
end
a = pinv(F)*xn.';
cd = cond(F);
X_kova = 0*t;
sum = 0;
for k=1:201
    for n=1:15
    sum = sum +a(n)*exp(1i*(n-8)*pi*t(k));
    end
    X_kova(k) = sum;
    sum = 0;
end
figure(18);
plot(t,x);
hold on;
plot(t,X_kova);
xlabel('t [sec]');
ylabel('x(t)');
title('F noise - Random 40 sampling -  x(t) Recovered Vs x(t)');
legend([{'x(t)'};{'x(t) Recovered'}]);
%-------------Question3--------------------
clear all;
%-------------section B -------------------
T = 10;
t = 0:0.01:T-0.01;
f = 4*cos(4*pi/T*t)+sin(10*pi/T*t);
g = 2*sign(sin(6*pi/T*t))-4*sign(sin(4*pi/T*t));
n = -20:1:20;
phi_n = exp(1i*2*pi/T*t'*n);
m = 0:1:19;
ksi_m = zeros(length(t),length(m));
for i=m
    ksi_m(:,i+1) = [zeros(1,i*length(t)/20),ones(1,length(t)/20),zeros(1,(19-i)*length(t)/20)];
end
cf_phi = projection(f,phi_n);
cg_phi = projection(g,phi_n);
cf_ksi = projection(f,ksi_m);
cg_ksi = projection(g,ksi_m);
%-------------section C -------------------
f_kova_phi = (phi_n*cf_phi).';
f_kova_ksi = (ksi_m*cf_ksi).';
g_kova_phi = (phi_n*cg_phi).';
g_kova_ksi = (ksi_m*cg_ksi).';
figure(19);
plot(t,f);
hold on;
plot(t,f_kova_phi,'--y');
hold on;
plot(t,f_kova_ksi);
xlabel('t [sec]');
ylabel('f(t)');
title('f(t) Vs f(t) recovered by phi Vs f(t) recovered by ksi');
legend([{'f(t)'};{'f(t) recovered by phi'};{'f(t) recovered by ksi'}]);
figure(20);
plot(t,g);
hold on;
plot(t,g_kova_phi);
hold on;
plot(t,g_kova_ksi);
xlabel('t [sec]');
ylabel('g(t)');
title('g(t) Vs g(t) recovered by phi Vs g(t) recovered by ksi');
legend([{'g(t)'};{'g(t) recovered by phi'};{'g(t) recovered by ksi'}]);





%-------------section A -------------------
function Cn = projection(x,A)
    N = length(A(1,:));
    Cn = zeros(1,N);
   for i=1:N
       Cn(i) = trapz(x.*A(:,i)')/trapz(A(:,i).*conj(A(:,i)));
   end
   Cn = Cn.';
end




