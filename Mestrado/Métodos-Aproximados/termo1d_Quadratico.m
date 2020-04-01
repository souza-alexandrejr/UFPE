%% PROBLEMA: Conducao Estacionaria de Calor em uma Barra Homogenea
% --------- Lista de Exercicios 1D - Metodos Aproximados --------- %
% ------------- Solucao via MEF usando MRP-Galerkin -------------- %

close all; clear; clc;

%% PRE-PROCESSO

% DADOS DA BARRA:
L = 1; % comprimento da barra
lambda = 3; % condutividade termica da barra
Q = -2; % ganho/perda de calor na barra

% CONDICOES DE CONTORNO:
% Em x = 0: 
q0 = 0;
gamma0 = 1e6;
phi0 = 1;

% Em x = L: 
qL = 0;
gammaL = 1e6;
phiL = 2;

% DISCRETIZACAO:
ne = 100; % numero de elementos
nn = 2*ne + 1; % numero de pontos nodais (numero de nos)

% Coordenadas nodais:
x = zeros(nn,1);
x(1) = 0;
dx = L/(nn - 1); % incremento
for i = 2:nn
  x(i) = x(i-1) + dx;
end

%% PROCESSO

% Dimensiona matriz e vetor globais:
M = sparse(nn,nn);
F = zeros(nn,1);

% matriz de conectividades
lnods = zeros(ne,3);
lnods(1,:) = [1 2 3];
for i = 2:ne
    lnods(i,:) = lnods(i-1,:) + [2 2 2];
end

% Contribuicao dos elementos no sistema global:
for e = 1:ne
  % coordenadas na numeracao global e local
  ng = lnods(e,:);
  x1 = x(ng(1));
  x2 = x(ng(2));
  x3 = x(ng(3));

  Le = x3 - x1; % tamanho do elemento
  
  % Matriz local do elemento:
  Ke = lambda/Le*[7/3 -8/3 1/3; -8/3 16/3 -8/3; 1/3 -8/3 7/3];

  % Vetor local do elemento:
  Fe = Q*Le*[1/6; 2/3; 1/6];

  % Monta matriz M e vetor F globais:
  M(ng(1),ng(1)) = M(ng(1),ng(1)) + Ke(1,1);
  M(ng(1),ng(2)) = M(ng(1),ng(2)) + Ke(1,2);
  M(ng(1),ng(3)) = M(ng(1),ng(3)) + Ke(1,3);
  M(ng(2),ng(1)) = M(ng(2),ng(1)) + Ke(2,1);
  M(ng(2),ng(2)) = M(ng(2),ng(2)) + Ke(2,2);
  M(ng(2),ng(3)) = M(ng(2),ng(3)) + Ke(2,3);
  M(ng(3),ng(1)) = M(ng(3),ng(1)) + Ke(3,1);
  M(ng(3),ng(2)) = M(ng(3),ng(2)) + Ke(3,2);
  M(ng(3),ng(3)) = M(ng(3),ng(3)) + Ke(3,3);
  
  F(ng(1)) = F(ng(1)) + Fe(1);
  F(ng(2)) = F(ng(2)) + Fe(2);
  F(ng(3)) = F(ng(3)) + Fe(3);

%  spy(M); % visualizacao grafica dos termos nao-nulos da matriz M
%  pause

end

% Adicionando as condicoes de contorno
% Em x = 0:
M(1,1) = M(1,1) + gamma0;
F(1) = F(1) + q0 + gamma0*phi0;

% Em x = L:
M(nn,nn) = M(nn,nn) - gammaL;
F(nn) = F(nn) - qL - gammaL*phiL;
    
% Resolvendo o sistema:
phi = M\F;

% Fluxos no contorno:
q_contorno_0 = q0 + gamma0*(phi0-phi(1));
q_contorno_L = qL + gammaL*(phiL-phi(nn));

% Balanco de energia:
E = - q_contorno_0 + q_contorno_L - Q*L;

%% POS-PROCESSO
% Escrevendo Resultados:
clc;
disp('TERMO1D.')
disp('PROGRAMA MEF PARA CONDUCAO ESTACIONARIA DE CALOR EM UMA BARRA.')
disp('Coordenadas e temperaturas:')
for i = 1:nn
  disp([ 'x = ', num2str(x(i)),'  phi = ', num2str(phi(i))])
end
disp('Fluxos:')
disp(['x = 0: ', num2str(q_contorno_0)])
disp(['x = L: ', num2str(q_contorno_L)])

% Plotando resultados:
plot(x,phi,'ro')

% Comparacao com solucao analitica 'phia' (quadratica):
hold on
xa = 0:dx:L;
phia = zeros(nn,1);

for i = 1:nn,
  phia(i) = 1/3*xa(i)^2 + 2/3*xa(i) + 1;
end

plot(xa,phia,'g')

