function [x_star,FVAL,Converg,Resumo] = otimizacao_encopt_mrst(encopt_mrst)
%% Set up box limits for scaling and define function evaluation handle

% Number of Injector Wells
nInj = encopt_mrst.injetor_well;

% Number of Producer Wells
nProd = encopt_mrst.producer_well;

% Number of Controls
numCnt = encopt_mrst.nc;

% Bounds
Lims = repmat([repmat([0, 1], nInj, 1); repmat([0, 1], nProd, 1)], numCnt, 1);
lb = vertcat(Lims(:,1));
ub = vertcat(Lims(:,2));

% Calling simulation file
eval(encopt_mrst.Model)

%% LINEAR CONSTRAINTS

if encopt_mrst.reslinear == 1
    % Linear Constraints
    A = [];
    b = [];
    Aeq = [];
    beq = [];
elseif encopt_mrst.reslinear == 2
    % Non-Linear Constraints
    A = [];
    b = [];
    Aeq = [];
    beq = [];
end

%% LOADING NORMALIZED INITIAL POINT,

x = encopt_mrst.x0;

%% CALLING FUNCTIONS TO COMPUTE GRADIENTS BY ADJOINT OR ESSEMBLE

save encopt_mrst.mat

if encopt_mrst.gradiente == 1 
    % GRADIENT BY ADJOINT
    [x_star, FVAL, Converg, Resumo] = RunMrst(x,A,b,Aeq,beq,lb,ub,encopt_mrst);

elseif encopt_mrst.gradiente == 2
    % GRADIENT BY ENSEMBLE BASED METHOD
    [x_star,FVAL,Converg,Resumo] = RunEncopt(x,A,b,Aeq,beq,lb,ub,encopt_mrst);
end

