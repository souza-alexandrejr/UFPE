% Universidade Federal de Pernambuco
% Disciplina de Otimização
% Profa. Silvana Bastos
% Programação Quadrática: Uso do fmincon.m e SQP como algoritmo
% QUESTAO 03
% -------------------------------------------------

% configurando para algoritmo SQP e para visualizar histórico de iterações
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

% funcao objetivo
fun4 = @(x)2*x(1)^2 + 2*x(2)^2 - 2*x(1)*x(2) - 4*x(1) - 6*x(2);
x0 = [-1,2]; % ponto inicial
lb = [0,0]; % limite inferior
ub = [Inf,Inf];  % limite superior
% restricao linear de desigualdade: x(1) - 5*x(2) <= 5 (A*x <= b)
A = [1,-5]; 
b = 5;
% restricao não-linear: 2*x(1)^2 - x(2) <= 0
nonlcon = @const04;
[x,fval] = fmincon(fun4,x0,A,b,[],[],lb,ub,nonlcon,options);

fprintf('solucao:\n x=[%.4f %.4f] \n f(x)=%.4f\n',x(1),x(2),fval);
