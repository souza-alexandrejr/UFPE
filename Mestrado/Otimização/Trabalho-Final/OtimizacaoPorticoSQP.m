%% Otimizacao de Portico 2D usando AD e Algoritmo SQP
% -------------------------------------------------- %

% configurando o fmincon.m para algoritmo SQP, para visualizar histórico de
% iterações, incluir o gradiente como output das funçãos objetivo e de
% restrição, e plotar curvas de fval e do step size
options = optimoptions('fmincon','Display','iter','Algorithm','sqp',...
    'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,...
    'PlotFcns',{@optimplotfval,@optimplotstepsize});

% ponto inicial
x0 = [7;30];

lb = [0,0]; % limite inferior
ub = [Inf,Inf]; % limite superior

x = fmincon(@volportico,x0,[],[],[],[],lb,ub,@restricoes,options);

fprintf('x(1): %.3f cm\nx(2): %.3f cm\nVolume(x(1),x(2)): %.3f cm³\n',x(1),x(2),volportico(x));

%% RESPOSTA

%                                                           Norm of First-order
%  Iter F-count            f(x) Feasibility  Steplength        step  optimality
%     0       1    5.489000e+05   0.000e+00                           3.300e+04
%     1       2    5.268493e+05   3.399e+00   1.000e+00   8.336e-01   8.847e+03
%     2       3    5.285804e+05   1.031e-01   1.000e+00   1.140e-01   2.247e+02
%     3       4    5.286294e+05   1.043e-04   1.000e+00   3.705e-03   1.303e+00
%     4       5    5.286294e+05   1.070e-10   1.000e+00   3.757e-06   3.605e-05
% 
% Local minimum found that satisfies the constraints.
% 
% Optimization completed because the objective function is non-decreasing in 
% feasible directions, to within the default value of the optimality tolerance,
% and constraints are satisfied to within the default value of the constraint tolerance.
% 
% <stopping criteria details>
% 
% x(1): 6.353 cm
% x(2): 29.672 cm
% Volume(x(1),x(2)): 528629.447 cm³

