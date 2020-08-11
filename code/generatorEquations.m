function equations = generatorEquations(t,point,flag,rr,fs,thetai,ai,bi,alpha1)
% equations = generatorEquations(t,point,flag,rr,fs,u,thetai,ai,bi)
% ODE file for generating the synthetic PPG
% This file provides equations = F(t,point) taking input paramters: 
% rr: rr process 
% fs: sampling frequency [Hertz]
% u: the parameter of van der pol. 
% Order of extrema: [systolic peak, diastolic peak]
% thetai = angles of extrema [radians] 
% ai = z-position of extrema 
% bi = Gaussian width of peaks 



x = point(1);
y= point(2);
z = point(3);


ip = 1+floor(t*fs); 

w = 2*pi/rr(ip);
alpha = alpha1(ip);
%% when x = coswt, y = sinwt 
dxdt = -w*y;
dydt = w*x;

%% confused model
% dxdt = -w*y;
% dydt = 0.01*(1-x*x)*y + x*w;

%% van der pol,  y=x'
% dxdt = y;
% dydt = u*(1-x*x)*y - x;



theta = atan2(y,x);
diff_theta = theta - thetai;
dtheta_dt = -(y)/(x^2 + y^2)*dxdt + x/(x^2 + y^2)*dydt;

dzdt = - sum(alpha * ai.*diff_theta.*exp(-((diff_theta./bi).^2))/2)* dtheta_dt;

equations = [dxdt; dydt; dzdt];

end