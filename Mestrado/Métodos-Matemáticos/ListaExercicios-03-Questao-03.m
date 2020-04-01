%% -- Lista de Exercicios - Metodos Matematicos -- %
% ------------------ Questao 03 ------------------ %

% Resolver PVI: y' - 2xy = x com y(0) = 1
close all; clear; clc

% Dados do problema:
% Incremento:
dx = 0.2;
% Final do intervalo de integracao:
xf = 1.0;
% Numero de pontos:
n = xf/dx;

% Inicializacao de variaveis:
x = zeros(n,1);
y = zeros(n,1);
yExp = zeros(n,1);
yImp = zeros(n,1);
yCent = zeros(n,1);
erroExp = zeros(n,1);
erroImp = zeros(n,1);
erroCent = zeros(n,1);

% Aplicacao das Condicoes Iniciais:
x(1) = 0;
y(1) = 1;
yExp(1) = 1;
yImp(1) = 1;
yCent(1) = 1;
fprintf('i = %d   x = %.4f   yAna = %.4f   yExp = %.4f   yImp = %.4f   yCent = %.4f\n',...
        1, x(1), y(1), yExp(1), yImp(1), yCent(1));
erroExp(1) = 0;
erroImp(1) = 0;
erroCent(1) = 0;

% Integracao:
for i = 1:n
  x(i+1) = x(i) + dx;
  
  % solucao analitica
  y(i+1) = 3/2*exp(x(i+1)^2) - 1/2; 
  
  % metodo explicito
  yExp(i+1) = yExp(i) + dx*(x(i) + 2*x(i)*yExp(i)); 
  erroExp(i+1) = abs(yExp(i+1)-y(i+1))/y(i+1);
  
  % metodo implicito
  yImp(i+1) = (yImp(i) + dx*x(i+1))/(1 - 2*dx*x(i+1)); 
  erroImp(i+1) = abs(yImp(i+1)-y(i+1))/y(i+1);
  
  % diferencas centradas
  yCent(i+1) = (yCent(i)*(1 + dx*x(i)) + dx*(x(i+1) + x(i))/2)/(1 - dx*x(i+1)); 
  erroCent(i+1) = abs(yCent(i+1)-y(i+1))/y(i+1);
  
  fprintf('i = %d   x = %.4f   yAna = %.4f   yExp = %.4f   yImp = %.4f   yCent = %.4f\n',...
        i+1, x(i+1), y(i+1), yExp(i+1), yImp(i+1), yCent(i+1));
end

% Saidas:

% Resultados (Iteracoes):
% i = 1   x = 0.0000   yAna = 1.0000   yExp = 1.0000   yImp = 1.0000   yCent = 1.0000
% i = 2   x = 0.2000   yAna = 1.0612   yExp = 1.0000   yImp = 1.1304   yCent = 1.0625
% i = 3   x = 0.4000   yAna = 1.2603   yExp = 1.1200   yImp = 1.4410   yCent = 1.2663
% i = 4   x = 0.6000   yAna = 1.6500   yExp = 1.3792   yImp = 2.0539   yCent = 1.6677
% i = 5   x = 0.8000   yAna = 2.3447   yExp = 1.8302   yImp = 3.2558   yCent = 2.3903
% i = 6   x = 1.0000   yAna = 3.5774   yExp = 2.5759   yImp = 5.7597   yCent = 3.6910

% Plotando graficos
plot(x, y, x, yExp, x, yImp, x, yCent)
xlabel('x')
ylabel('y')
legend('analitica','explicita','implicita','centrada')

% Calculo do Erro Global
% Metodo Explicito
erroGlobalExp = sum(erroExp(:));
fprintf('Erro Global pelo Met. Exp. = %.4f\n', erroGlobalExp);
% Metodo Implicito
erroGlobalImp = sum(erroImp(:));
fprintf('Erro Global pelo Met. Imp. = %.4f\n', erroGlobalImp);
% Diferencas Centradas
erroGlobalCent = sum(erroCent(:));
fprintf('Erro Global por Dif. Centradas = %.4f\n', erroGlobalCent);

% Resultados (Erro Global)
% Erro Global pelo Met. Exp. = 0.8325
% Erro Global pelo Met. Imp. = 1.4520
% Erro Global por Dif. Centradas = 0.0679
