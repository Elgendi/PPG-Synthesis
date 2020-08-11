function [paraFmincon_interior,history_fval,history_p,simulatePPG,r,mse] = get_opt_para(template,fs,view,Name)
%% get the optimization parameters of template
% input variables:
%         template: the template need to simulate
%         view: =0: none plot
%               =1: plot the simulate PPG and template PPG with mse and
%                   correlation
%               =2: plot the simulate PPG and temaplate ppg with mse and correlation
%                   in first subplot, plot the guassian waves in second subplot
%        Name: the name discribe in the figure
% output variables:
%         paraFmincon_interior: the optimization parameters calculate by
%                                 constraint interior-point method
%         history_fval: the value of objective function in each iteration
%         history_p: the value of parameters in each iteration
%         simulatePPG_interio: the simulate PPG of the optimation parameters
%         r: correlation between the simulated PPG and template PPG
%         mse: mean square error betweeen the simulated PPG and template
%         PPG
  if nargin <3
      view = 0;
  end
  if nargin <4
      Name = 'template';
  end
   para0 = [0.5,0,1,0.5,0,1,2,2];
   lpara = [0,-pi,0.5,0,-pi,0.5,0,0];
   upara = [1,pi,2,1,pi,2,4,4];
   rrinterval = length(template)/fs;
   objectiveFun = @(para)(sum((model(rrinterval,[para(2) para(5)],[para(1) para(4)],[para(3),para(6)],1,fs)- template).^2)+(1-corr(model(rrinterval,[para(2) para(5)],[para(1) para(4)],[para(3),para(6)],1,fs)',template')));
             
   
   %% fminunc (Find minimum of unconstrained multivariable function)
%    options = optimoptions('fminunc','PlotFcn','optimplotfval');
%    [para_fminunc,fval] = fminunc(objectiveFun,para0,options);
%    [simulatePPGfminunc,r_fminunc,mse_fminunc] = campare_result(para_fminunc,template,1,'fminunc');

  
   %% fmincon (Algorithm: interior-point)
   global history_fval history_p;
   options = optimoptions('fmincon','Algorithm','interior-point','StepTolerance',1e-10,'ConstraintTolerance',1e-10,'OutputFcn',@outfun);
   
   [paraFmincon_interior,fval,exitflag,output] = fmincon(objectiveFun,para0,[],[],[],[],lpara,upara, ...
                                   @constrainedFun,options);
   [simulatePPG,r,mse] = campare_result(paraFmincon_interior,fs,template,view,Name);

%     
    %% fmincon  (Algorithm:sqp)
%     options = optimoptions('fmincon','Algorithm','sqp','MaxIterations',2000);
%     [paraFmincon_sqp,fval,exitflag,output] = fmincon(objectiveFun,para0,[],[],[],[],lpara,upara, ...
%                                    @constrainedFun,options);
%    [simulatePPG_sqp,r_sqp,mse_sqp] = campare_result(paraFmincon_sqp,template,2,'fmincon:sqp');
%    
    %% fmincon  (Algorithm:sqp-legacy)
%     options = optimoptions('fmincon','Algorithm','sqp-legacy');
%     [paraFmincon_sqp_l,fval,exitflag,output] = fmincon(objectiveFun,para0,[],[],[],[],lpara,upara, ...
%                                    @constrainedFun,options);
%    [simulatePPG_sqp,r_sqp,mse_sqp] = campare_result(paraFmincon_sqp_l,template,2,'fmincon:sqp-legacy');
% %    
% %       
%     %% fmincon  (Algorithm:active-set)
%      options = optimoptions('fmincon','Algorithm','active-set');
%     [paraFmincon_act,fval,exitflag,output] = fmincon(objectiveFun,para0,[],[],[],[],lpara,upara, ...
%                                    @constrainedFun,options);
%     [simulatePPG_active,r_active,mse_active] = campare_result(paraFmincon_act,template,2,'fmincon:active-set');
    
    %% fmincon (trust-region-reflective) 
    % 'trust-region-reflective' requires to provide a gradient, 
    %            and allows only bounds or linear equality constraints, but not both.
    
%     %% lsqnonlin (trust-region-reflective' (default))
%     objectiveFun1 = @(para)model(1,0.01,[para(2) para(5)],[para(1) para(4)],[para(3),para(6)],256)- template;
%     options = optimoptions('lsqnonlin','Algorithm','trust-region-reflective');
%     para_lsq_trust = lsqnonlin(objectiveFun1,para0,lpara,upara,options);
%     [simulatePPG_sqp,r_sqp,mse_sqp] = campare_result(para_lsq_trust,template,2,'lsqnonlin:trust');
%     
%     %% lsqnonlin ('levenberg-marquardt')
%     objectiveFun1 = @(para)model(1,0.01,[para(2) para(5)],[para(1) para(4)],[para(3),para(6)],256)- template;
%     options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
%     para_lsq_levenberg = lsqnonlin(objectiveFun1,para0,lpara,upara,options);
%     [simulatePPG_sqp,r_sqp,mse_sqp] = campare_result(para_lsq_levenberg,template,2,'lsqnonlin:levenberg-marquardt');
%     %% Particle swarm optimization
%    nvars = 6;
% 
%    options = optimoptions('particleswarm','OutputFcn',@pswoutfun,'PlotFcn','pswplotbestf','SwarmSize',100);
% %    options = optimoptions('particleswarm','OutputFcn',@pswoutfun,'SwarmSize',100);
%    [paraPSO,fval,exitflag,output]= particleswarm(objectiveFun,nvars,lpara,upara,options);
%    saveas(gcf, '.\output\fig\particleswarm.fig');
%    open('.\output\fig\particleswarm.fig');
%    lh = findall(gca,'type','line');
%    fValIter = get(lh,'yData');
%    close(figure(gcf));

%    figure;
%    subplot(3,1,1);
%    campare_result(para_fminunc,template,1,'fminunc');
%    subplot(3,1,2);
%    campare_result(paraFmincon_interior,template,1,'fmincon');
%    subplot(3,1,3);
%    campare_result(paraPSO,template,1,'partcle swarm');
%    suptitle(Name);
   
%    option = optimoptions();
%    cons1 = para(1) - para(4) > 0;
%    cons2 = para(2) - para(5) < 0;
%    cons3 = para(3) - para(6) < 0;
     
    
end

function [simulatePPG,r,mse] = campare_result(para,fs,template,view,name)
   ti = [para(2) para(5)];
   ai = [para(1) para(4)];
   bi = [para(3) para(6)];
   rrinterval = length(template)/fs;
   [simulatePPG,points] = model(rrinterval,ti,ai,bi,1,fs);
   r = corr(simulatePPG',template');
   mse = immse(simulatePPG,template);
   t = 1/fs:1/fs:length(template)*1/fs;
   if view == 1
       plot(t,simulatePPG,'r--');
       hold on;
       plot(t,template,'k-');
       legend('Synthetic','Template'); 
       xlabel('Time (s)');
       ylabel('PPG');
       axis tight;
       title([name ': MSE=' num2str(mse) ', r=' num2str(r)]);       
   elseif view == 2
       figure;
       subplot(2,1,1);
       plot(simulatePPG,'r-');
       hold on;
       plot(template,'k-');
       legend('simulate','template');   
       title([name ': MSE=' num2str(mse) ',r=' num2str(r)]);
       subplot(2,1,2);
       x = points(:,1);
       y = points(:,2);
       theta = atan2(y,x);
       text1 = cell(1,length(ti)+2);
       text1{1,1} = '0';
       text1{1,end} = '256';
       text2 = cell(1,length(ti));
       color = ['b','k','r','c','m'];
       for i = 1:length(ti)
           c{i} = ai(i)*exp(-((theta-(ti(i))).^2)/(2*(bi(i).^2)));
           plot(c{i},[color(i) '-']);
           text1{i+1} = num2str(ceil((ti(i)+pi)/(2*pi)*length(x)));
           text2{i} = ['wave_' num2str(i)];
           hold on;
       end
       legend(text2);
       set(gca,'XTick',[0 ceil((ti+pi)/(2*pi)*length(x)) 256]);
       set(gca,'XTickLabel',text1);
%            set(gca,'xLim',[-pi pi]);
%       set(gca,'XTick',[-pi ti pi]);
%       set(gca,'XTickLabel',text1);
   end
end
