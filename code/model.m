function [signal,X0] = model(rrinterval,theta_i,ai,bi,alpha,fs,seconds)
%%

%%

flag = 0;
if nargin <7
    flag = 0;
elseif nargin == 7
    flag = 1;
end
dt = 1/fs;
rrn = [];
alpha1 = [];
for i = 1:length(rrinterval)
    rrn = [rrn rrinterval(i)*ones(1,ceil(fs*rrinterval(i)))];
    alpha1 = [alpha1 alpha(i)*ones(1,ceil(fs*rrinterval(i)))];
end

% set start point to theta = -pi
x0 = [-1,-0,0];

if flag == 1
    Tspan = (0:1:(ceil(seconds*fs-1)))*dt;
else 
    Tspan = 0:dt:(length(rrn)-1)*dt;
end

% theta_i = theta_i*pi/180;
[T,X0] = ode45('generatorEquations',Tspan,x0,[],rrn,fs,theta_i,ai,bi,alpha1);
% plot_dxyz(Tspan,X0,fs,u,rrn,ai,bi,theta_i);
% plot_xyz(X0);
signal = mapminmax(X0(:,3)',0,1);
X0(:,3) = signal;
end

function plot_dxyz(t,X,fs,u,rr,ai,bi,ti)
   x = X(:,1);
   y = X(:,2);
   z = X(:,3);
   dxdt = zeros(1,length(x)); 
   dydt = zeros(1,length(y)); 
   dzdt = zeros(1,length(z)); 
   theta = atan2(y,x);
   for count = 1:length(x)
       dpdt = generatorEquations(t(count),X(count,:),[],rr,fs,u,ti,ai,bi);
       dxdt(count) = dpdt(1);
       dydt(count) = dpdt(2);
       dzdt(count) = dpdt(3);
   end
    figure;
    subplot(6,2,1);
    plot(dxdt);
    xlabel('t');
    ylabel('dxdt');
    axis tight;
    subplot(6,2,3);
    plot(dydt);
    xlabel('t');
    ylabel('dydt');
    axis tight;
    subplot(6,2,5);
    plot(theta);
    xlabel('t');
    ylabel('theta');
    axis tight;
    subplot(6,2,7);
    plot(z);
    xlabel('t');
    ylabel('z');
    axis tight;
    subplot(6,2,[2,4,6]);
    plot(x,y);
    xlabel('x');
    ylabel('y');
    subplot(6,2,[8,10,12]);
    plot(theta,z);
    xlabel('theta');
    ylabel('z');
    subplot(6,2,9);
    plot(dzdt);
    xlabel('t');
    ylabel('dzdt');
    axis tight;
    subplot(6,2,11);
    plot(diff(diff(z)));
    xlabel('t');
    ylabel('(dzdt)^2');
    axis tight;
end





