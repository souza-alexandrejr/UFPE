%% PROBLEMA: Conducao Estacionaria de Calor em uma Barra Heretogenea
% --------- Lista de Exercicios 1D - Metodos Aproximados --------- %
% ------------- Solucao via MEF usando MRP-Galerkin -------------- %

close all; clear; clc;

%% PRE-PROCESSO

% DADOS DA BARRA:
L = 1; % comprimento da barra
lambdaA = 1; % condutividade termica da primeira metade da barra
lambdaB = 2; % condutividade termica da segunda metade da barra
Q = 3; % ganho/perda de calor na barra

% CONDICOES DE CONTORNO:
% Em x = 0: (Essencial)
q0 = 0;
gamma0 = 1e6;
phi0 = 1;

% Em x = L: (Natural)
qL = 2;
gammaL = 0;
phiL = 0;

% DISCRETIZACAO:
ne = 100; % numero de elementos
nn = ne + 1; % numero de pontos nodais (numero de nos)

% Coordenadas nodais:
x = zeros(nn,1);
x(1) = 0;
dx = L/ne; % incremento
for i = 2:nn
  x(i) = x(i-1) + dx;
end

%% PROCESSO

% Dimensiona matriz e vetor globais:
M = sparse(nn,nn);
F = zeros(nn,1);

% Contribuicao dos elementos no sistema global:
for e = 1:ne
  % coordenadas na numeracao global e local
  ng1 = e;
  ng2 = e+1;
  x1 = x(ng1);
  x2 = x(ng2);

  Le = x2 - x1; % tamanho do elemento
  
  % Matriz local do elemento:
  if e <= ne/2
      Ke = lambdaA/Le*[1 -1; -1  1];
  else
      Ke = lambdaB/Le*[1 -1; -1  1];
  end

  % Vetor local do elemento:
  Fe = Q*Le/2*[1; 1];

  % Monta matriz M e vetor F globais:
  M(ng1,ng1) = M(ng1,ng1) + Ke(1,1);
  M(ng1,ng2) = M(ng1,ng2) + Ke(1,2);
  M(ng2,ng1) = M(ng2,ng1) + Ke(2,1);
  M(ng2,ng2) = M(ng2,ng2) + Ke(2,2);
  F(ng1) = F(ng1) + Fe(1);
  F(ng2) = F(ng2) + Fe(2);
  
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

%% Comparacao com solucao analitica 'phia':
hold on
xa = 0:dx:L;

phiAna = zeros(nn,1);

for i = 1:nn
    if i < ceil(nn/2)
        phiAna(i) = -3/2/lambdaA*xa(i)^2 + 1*xa(i) + 1;
    else
        % restringindo que phi seja igual no ponto medio da barra
        % seja pelo lado esquerdo, seja pelo lado direito
        phiAna(i) = -3/2/lambdaB*xa(i)^2 + 1/2*xa(i) + 1.0625;
    end
end

plot(xa,phiAna,'g')

