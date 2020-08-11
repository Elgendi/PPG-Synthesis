function stop = outfun(x,optimValues,state)
global history_fval history_p;
stop = false;
   switch state
       case 'init'
           history_fval = [];
           history_p = [];
       case 'iter'
           % Concatenate current point and objective function
           % value with history. x must be a row vector.
           history_fval = [history_fval; optimValues.fval];
           history_p = [history_p; x];
       case 'done'
           hold off
       otherwise
   end
end
