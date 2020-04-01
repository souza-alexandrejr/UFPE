%% -- Lista de Exercicios - Metodos Matematicos -- %
% ------------------ Questao 01 ------------------ %

% Resolver PVI: y' - (cosx)*y = 0 com y(0) = e
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
y(1) = exp(sin(x(1)) + 1);
yExp(1) = exp(sin(x(1)) + 1);
yImp(1) = exp(sin(x(1)) + 1);
yCent(1) = exp(sin(x(1)) + 1);
fprintf('i = %d   x = %.4f   yAna = %.4f   yExp = %.4f   yImp = %.4f   yCent = %.4f\n',...
        1, x(1), y(1), yExp(1), yImp(1), yCent(1));
erroExp(1) = 0;
erroImp(1) = 0;
erroCent(1) = 0;
    
% Integracao:
for i = 1:n
    x(i+1) = x(i) + dx;
    
    % solucao analitica
    y(i+1) = exp(sin(x(i+1)) + 1);         
    
    % metodo explicito
    yExp(i+1) = yExp(i)*(1 + dx*cos(x(i)));     
    erroExp(i+1) = abs(yExp(i+1)-y(i+1))/y(i+1);
    
    % metodo implicito
    yImp(i+1) = yImp(i)/(1 - dx*cos(x(i+1)));   
    erroImp(i+1) = abs(yImp(i+1)-y(i+1))/y(i+1);
    
    % diferencas centradas
    yCent(i+1) = yCent(i)*(1 + .5*dx*cos(x(i)))/(1 - .5*dx*cos(x(i+1)));
    erroCent(i+1) = abs(yCent(i+1)-y(i+1))/y(i+1);
    
    fprintf('i = %d   x = %.4f   yAna = %.4f   yExp = %.4f   yImp = %.4f   yCent = %.4f\n',...
        i+1, x(i+1), y(i+1), yExp(i+1), yImp(i+1), yCent(i+1));
end

% Saidas:

% Iteracoes:
% i = 1   x = 0.0000   yAna = 2.7183   yExp = 2.7183   yImp = 2.7183   yCent = 2.7183
% i = 2   x = 0.2000   yAna = 3.3157   yExp = 3.2619   yImp = 3.3810   yCent = 3.3150
% i = 3   x = 0.4000   yAna = 4.0125   yExp = 3.9013   yImp = 4.1445   yCent = 4.0092
% i = 4   x = 0.6000   yAna = 4.7810   yExp = 4.6200   yImp = 4.9638   yCent = 4.7723
% i = 5   x = 0.8000   yAna = 5.5698   yExp = 5.3826   yImp = 5.7675   yCent = 5.5531
% i = 6   x = 1.0000   yAna = 6.3058   yExp = 6.1326   yImp = 6.4662   yCent = 6.2792

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
% Erro Global pelo Met. Exp. = 0.1387
% Erro Global pelo Met. Imp. = 0.1518
% Erro Global por Dif. Centradas = 0.0101

