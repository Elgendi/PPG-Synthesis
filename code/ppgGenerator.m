function [PPG,errorNum] = ppgGenerator(fs,template,view,time,MeanHR,SDNN,ppgType,ratio,arrythmiaNumberType)
    if nargin <1
        fs = 125;
    end
    if nargin <2
        thetai = [-1.6184, 0.8903];
        ai = [0.7482, 0.0444];
        bi = [0.9353, 1.9499];
    else
        if isempty(template)
            thetai = [-1.6184, 0.8903];
            ai = [0.7482, 0.0444];
            bi = [0.9353, 1.9499];
        else
            [para,~,~,~,~,~] = get_opt_para(template,fs,0);
            thetai = [para(2) para(5)];
            ai = [para(1) para(4)];
            bi = [para(3) para(6)];
        end
    end
    if nargin < 3
        view = 0;
    end
    if nargin <4   
        ppinterval = 1;
        alpha = 1;
        time = 1;
        errorNum = 0;
    else
        if nargin <6
            error('please set the heart rate range.\n');
        else
            if strcmp(ppgType,'normal')
                mu = 60/MeanHR;
                sigma = SDNN/1000;
                ppinterval = get_random_NormalppInterval(time,mu,sigma);
                errorNum = 0;
            else
                if nargin <8
                    ratio = 1;
                    arrythmiaNumberType = 'Times';
                end
                if strcmp(arrythmiaNumberType,'Times')
                    times = ratio;
                    [ppinterval,errorNum] = get_random_abnormalPpInterval_times(time,MeanHR,times,ppgType);
                else
                    [ppinterval,errorNum] = get_random_abnormalPpInterval(time,MeanHR,ratio,ppgType);
                end
                
            end
%             alpha = get_random_alpha(length(ppinterval),[0.5 1]);
            alpha = ones(length(ppinterval),1);
        end
    end
    
    if errorNum == 0
        [PPG,point] = model(ppinterval,thetai,ai,bi,alpha,fs,time);
        if view == 1
            plot_xyz(point,fs);
        end   
    else
        PPG = 0;
    end
end

  function ppInterval = get_random_NormalppInterval(time,mu,sigma)
    pp0 = normrnd(mu,sigma,[time*4,1]);  
    pp1 = roundn(pp0,-3);
    for i = 1:length(pp1)
        if sum(pp1(1:i)) > time
            break;
        end
    end
    ppInterval = pp1(1:i);

  end
  

  function [ppInterval,errorNum] = get_random_abnormalPpInterval_times(time,hr,arrythmiaTimes,type)
      errorNum = 0;
      basic_beatNum = ceil(time/(60/hr));
      switch type
          case 'compensation'
              intervalRatio = [0.8 1.2];
          case 'reset'
              intervalRatio = [0.6 1.2];

          case 'interpolation'
              intervalRatio = [0.4 0.6];
          case 'reentry'
              intervalRatio = [0.3 0.4];
      end

      addedBeatNum = floor(arrythmiaTimes*2 - (intervalRatio(1) + intervalRatio(2))*arrythmiaTimes);
      beatNum = basic_beatNum + addedBeatNum;
      interval = ones(time*4,1) *60/hr;

      arrythmiaBeatNumber = arrythmiaTimes;
      if  arrythmiaBeatNumber > floor((beatNum-1)/2)
          errorNum = 1;
          ppInterval = 0;
          return
      end
      arrythmiaBeat = randperm(floor((beatNum-1)/2),arrythmiaBeatNumber)*2;

      interval(arrythmiaBeat) = interval(arrythmiaBeat)*intervalRatio(1);
      interval(arrythmiaBeat+1) = interval(arrythmiaBeat+1)*intervalRatio(2);
      for i = 1:length(interval)
          if sum(interval(1:i)) > time
              break;
          end
      end
      ppInterval = interval(1:i);
  
  end
  
  function [ppInterval,errorNum] = get_random_abnormalPpInterval(time,hr,arrythmiaRatio,type)
    errorNum = 0;
        basic_beatNum = ceil(time/(60/hr));
    switch type
          case 'compensation'
               intervalRatio = [0.8 1.2];
          case 'reset'
               intervalRatio = [0.6 1.2];
               
          case 'interpolation'
               intervalRatio = [0.4 0.6];
          case 'reentry'
               intervalRatio = [0.3 0.4];
    end
      arrythmiaTimes = ceil(floor((basic_beatNum-1)/2)*arrythmiaRatio);
      addedBeatNum = floor(arrythmiaTimes*2 - (intervalRatio(1) + intervalRatio(2))*arrythmiaTimes);
      total_addedBeatNum = addedBeatNum;
      while addedBeatNum >=1
          arrythmiaTimes = ceil(floor(addedBeatNum/2)*arrythmiaRatio);
          addedBeatNum = floor(arrythmiaTimes*2 - (intervalRatio(1) + intervalRatio(2))*arrythmiaTimes);
          total_addedBeatNum = total_addedBeatNum + addedBeatNum;
      end
      interval = ones(time*4,1) *60/hr;
      beatNum = basic_beatNum + total_addedBeatNum;
      arrythmiaBeatNumber = ceil(floor((beatNum-1)/2) * arrythmiaRatio);
      
      arrythmiaBeat = randperm(floor((beatNum-1)/2),arrythmiaBeatNumber)*2;
      
      interval(arrythmiaBeat) = interval(arrythmiaBeat)*intervalRatio(1);
      interval(arrythmiaBeat+1) = interval(arrythmiaBeat+1)*intervalRatio(2);
      for i = 1:length(interval)
            if sum(interval(1:i)) > time
                break;
            end
       end
        ppInterval = interval(1:i);

  end
  
  
  function ppInterval = get_random_abnormalPpIntervalNumber(beatNum,hr,type)
      switch type
          case 'compensation'
               intervalRatio = [0.8 1.2];
          case 'reset'
               intervalRatio = [0.6 1.2];
          case 'interpolation'
               intervalRatio = [0.4 0.6];
          case 'reentry'
               intervalRatio = [0.3 0.4];
      end
      interval = ones(beatNum,1) *60/hr;
      
      if beatNum <4
          error('The segment must has more than 3 beats.');
      end
      
      arrythmiaBeat = 2;
      
      interval(arrythmiaBeat) = interval(arrythmiaBeat)*intervalRatio(1);
      interval(arrythmiaBeat+1) = interval(arrythmiaBeat+1)*intervalRatio(2);

       ppInterval = interval;

  end 
  
 function alpha = get_random_alpha(len,range)
    alpha = rand(len,1)*(range(2)-range(1)) + range(1);
  end
  
  function plot_xyz(X,fs)
   x = X(:,1);
   y = X(:,2);
   z = X(:,3);
   t = 1/fs:1/fs:length(x)/fs;
    figure;
    subplot(4,1,1);
    plot(t,x);
    xlabel('Times (s)');
    ylabel('\itx');
    axis tight;
    title('(a)');
    subplot(4,1,2);
    plot(t,y);
    xlabel('Times (s)');
    ylabel('\ity');
    axis tight;
    title('(b)');
    subplot(4,1,3);
    theta = atan2(y,x);
    plot(t,theta);
    xlabel('Times (s)');
    ylabel('\theta');
    axis tight;
    set(gca,'YLim',[-pi pi]);
    set(gca,'YTick',[-pi 0 pi]);
    set(gca,'YTickLabel',{'-\pi' '0' '\pi'});
    title('(c)');
    subplot(4,1,4);
    plot(t,z);
    xlabel('Times (s)');
    ylabel('\itz');
    axis tight;
    title('(d)');
    figure
    subplot(2,1,1);
    plot(x,y);
    xlabel('x');
    ylabel('y');
    axis tight;
    subplot(2,1,2);
    plot(theta,z);
    xlabel('\theta');
    ylabel('z');  
    set(gca,'XLim',[-pi pi]);
    set(gca,'XTick',[-pi 0 pi]);
    set(gca,'XTickLabel',{'-\pi' '0' '\pi'});
    figure;
    length(x)
    plot3(x,y,z);
    hold on;
    plot3(x,y,zeros(length(x),1));
    plot3(zeros(length(x),1),zeros(length(x),1),z);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    figure;
    plot(z);
    
    
end