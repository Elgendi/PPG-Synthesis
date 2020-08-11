function [c,ceq] = constrainedFun(para)

    c(1) = para(4) - para(1);    % a2 < a1
    c(2) = para(2) - para(5);    % theta1 < theta2
    c(3) = para(3) - para(6);    % b1 < b2
    ceq = [];
    ceq(1) = para(2) -para(7)*para(3) +pi;  % theta1 - gamma1*b1 = -pi
    ceq(2) = para(5) + para(8)*para(6) -pi;  %theta2 + gamma2*b2 = pi
    
end