% Universidade Federal de Pernambuco
% Disciplina de Otimização
% Profa. Silvana Bastos
% Programação Quadrática: Uso do fmincon.m e SQP como algoritmo
% QUESTAO 01
% ------------------------------------------------------------ %

% configurando o fmincon.m para algoritmo SQP, para visualizar histórico de
% iterações e incluir o gradiente como output da função objetivo
options = optimoptions('fmincon','Display','iter','Algorithm','sqp', ...
    'PlotFcns',{@optimplotx,@optimplotfval,@optimplotfirstorderopt});

%% Exemplo 1: Linear Inequality Constraint
x0 = [-1,2]; % ponto inicial
% restricao linear de desigualdade: x(1) + 2*x(2) <= 1 (A*x <= b)
A = [1,2]; 
b = 1;
x1 = fmincon(@rosenbrockwithgrad,x0,A,b,[],[],[],[],[],options);

%% Exemplo 2: Linear Inequality and Equality Constraint
x0 = [.5,0]; % ponto inicial
% restricao linear de desigualdade: x(1) + 2*x(2) <= 1 (A*x <= b)
A = [1,2]; 
b = 1;
% restricao linear de igualdade: 2*x(1) + x(2) = 1 (Aeq*x = beq)
Aeq = [2,1];
beq = 1;
x2 = fmincon(@rosenbrockwithgrad,x0,A,b,Aeq,beq,[],[],[],options);

%% Exemplo 3a e 8a: Bound Constraints + Obtain the objective function value
lb = [0,0]; % limite inferior
ub = [1,2]; % limite superior
x0 = [.5,1]; % ponto inicial
[x3a,fval3a] = fmincon(@fun2,x0,[],[],[],[],lb,ub,[],options);

%% Exemplo 3b e 8b: Bound Constraints + Obtain the objective function value
lb = [0,0]; % limite inferior
ub = [1,2]; % limite superior
x0 = [.1,.2]; % ponto inicial
[x3b,fval3b] = fmincon(@fun2,x0,[],[],[],[],lb,ub,[],options);

%% Exemplo 4: Nonlinear Constraints
lb = [0,0.2]; % limite inferior
ub = [0.5,0.8]; % limite superior
x0 = [1/4,1/4]; % ponto inicial
x4 = fmincon(@rosenbrockwithgrad,x0,[],[],[],[],lb,ub,@circlecon,options);

%% Exemplo 5, 9 e 10: Nondefault Options + Examine Solution Using Extra
% Outputs + Obtain all Outputs
x0 = [0,0]; % ponto inicial
[x5,fval5,exitflag5,output5,lambda,grad,hessian] = fmincon(@rosenbrockwithgrad,x0,[],[],[],[],[],[],@unitdisk,options);

%% Exemplo 6: Include Gradient 
lb = [-2,-2]; % limite inferior
ub = [2,2]; % limite superior
x0 = [-1,2]; % ponto inicial
x6 = fmincon(@rosenbrockwithgrad,x0,[],[],[],[],lb,ub,[],options);

%% Exemplo 7: Problem Structure
problem.options = options;
problem.solver = 'fmincon';
problem.x0 = [0,0];
problem.objetive = @rosenbrockwithgrad;
problem.nonlcon = @unitdisk;
x7 = fmincon(problem);
