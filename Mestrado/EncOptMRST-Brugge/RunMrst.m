function  [x_star, FVAL, Converg, Resumo] = RunMrst(x,A,b, Aeq,beq,lb,ub,encopt_mrst)
% Nested function to execute FMINCON

options = optimoptions(@fmincon, 'Algorithm', num2str(encopt_mrst.Algorithm),...
    'display','iter','TolFun',encopt_mrst.TolFun,...
    'MaxIter',encopt_mrst.MaxIter,'TolX',encopt_mrst.TolX);

% Gradiente por diferenças finitas!
options = optimoptions(options,'SpecifyObjectiveGradient',false,...
    'SpecifyConstraintGradient',false);

options = optimoptions(options,'PlotFcns',{@optimplotx,@optimplotfval});

[x_star, FVAL, Converg, Resumo] = fmincon(@fun,x,A,b,Aeq,beq,lb,ub,@nonLinearConstraint,options);

function [f, Grad] = fun(x)
    
    % ---- PRIVATE ---- %
    
end

function [c, ceq] = nonLinearConstraint(x)
% c -> inequality non-linear constraint
% ceq -> equality non-linear constraint

    % ---- PRIVATE ---- %

end

end