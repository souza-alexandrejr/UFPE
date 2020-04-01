% Universidade Federal de Pernambuco
% Disciplina de Otimização
% Profa. Silvana Bastos
% Programação Quadrática: Uso do fmincon.m e SQP como algoritmo
% QUESTAO 02
% -------------------------------------------------

% configurando o fmincon.m para algoritmo SQP, para visualizar histórico de
% iterações e incluir o gradiente como output da função objetivo
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

%% Funcao do Slide da Aula
x0 = [-1,2]; %ponto inicial
% restricao linear de desigualdade: A*x <= b
A = -1.*[4 1; 1 -1; -1 3; -1 -2; -5 -1];
b = -1.*[2.5; -1; 1; -4.7; -10.2];
[x,fval,~,output] = fmincon(@(x)x(1)+10*x(2),x0,A,b,[],[],[],[],[],options);

fprintf('solucao: \n x=[%.4f %.4f] \n f(x)=%.4f\n\n', x(1), x(2), fval);
fprintf('numero total de avaliacoes da funcao: %d\n', output.funcCount);

%% Funcao do help do linprog
x0 = [-1,2]; %ponto inicial
% restricao linear de desigualdade: A*x <= b
A = [1 1; 1 1/4; 1 -1; -1/4 -1; -1 -1; -1 1];
b = [2; 1; 2; 1; -1; 2];
% restricao linear de igualdade: A*x = b
Aeq = [1 1/4];
beq = 1/2;
[x,fval,~,output] = fmincon(@(x)-x(1)-x(2)/3,x0,A,b,Aeq,beq,[],[],[],options);

fprintf('solucao: \n x=[%.4f %.4f] \n f(x)=%.4f\n\n',x(1), x(2), fval);
fprintf('numero total de avaliacoes da funcao: %d\n', output.funcCount);
