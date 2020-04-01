%% -- Lista de Exercicios - Metodos Matematicos -- %
% ------------------ Questao 02 ------------------ %

% Resolver PVI: y' = alpha*exp(beta*y^2*t) com y(0) = 2*exp(1)
close all; clear; clc

% Dados do problema:
% Incremento:
dx = 0.05;
% Final do intervalo de integracao:
xf = 0.05;
% Valores das constantes na funcao:
alpha = 1;
beta = 1;
% Tolerancia para o esquema iterativo:
tol = 10^-5;

% Esquema de integracao no loop incremental:
theta = .5; % 0 = explicito; 1 = implicito ; 0.5 = dif. centradas
% incondicionalmente estavel: theta >= 0.5

% numero de pontos:
n = xf/dx;

% Inicializacao de variaveis:
x = zeros(n,1);
y = zeros(n,1);

% Aplicacao das Condicoes Iniciais:
x(1) = 0;
y(1) = 2*exp(1);

% loop de incremento
for i = 1:n

  x(i+1) = x(i) + dx;

  y(i+1) = y(i);  % estimativa inicial do passo atual = o valor convergido do passo anterior

  erro = 9999;

  k = 0;
    
  disp('iteracoes do Metodo de Newton')
  while (erro > tol) % loop iterativo: esquema de Newton

    if k > 20
        error('nao convergiu!')
    end
       
    F = (y(i+1) - y(i))/dx - theta*alpha*exp(beta*x(i+1)*y(i+1)^2)...
        - (1 - theta)*alpha*exp(beta*x(i)*y(i)^2);

    dF = 1/dx - 2*theta*alpha*beta*x(i+1)*y(i+1)*exp(beta*x(i+1)*y(i+1)^2);

    y(i+1) = y(i+1) - F/dF;

    erro = abs(F/dF);
   
    fprintf(' k = %d   y(%ed) = %.8f \n', k, k, y(i+1));    
    
    k = k + 1;
    
  end

  disp(['RESUMO: incremento: ' num2str(i) '  iteracoes: ' num2str(k-1) '  erro: ' num2str(erro)])

end

% Resultado:
% iteracoes do Metodo de Newton
%  k = 0   y(0) = 5.57967303 
%  k = 1   y(1) = 5.58016754 
%  k = 2   y(2) = 5.58016755 
% RESUMO: incremento: 1  iteracoes: 2  erro: 6.3868e-09

% Plotando o gráfico:
plot(x,y)
xlabel('x')
ylabel('y')

