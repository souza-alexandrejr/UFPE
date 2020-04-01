%% - PRE-PROCESSO: FLUXO DE AGUA EM MEIO POROSO SATURADO - %%
% -------- SOLUCAO VIA MEF-GALERKIN: ELEMENTO 2D --------- %%
% ---------------- TRIANGULO QUADRATICO ------------------- %
% ---------- Aplicacao de Integracao Numerica ------------- %

close all; clear; clc 
disp('PRE-PROCESSO')

%% DISCRETIZACAO DO DOMINIO: 

% Malha 10x10 (500m x 250m)
% load coordsQuad.dat
% coords = coordsQuad;
% load lnodsQuad.dat
% lnods = lnodsQuad;

% exemplo-teste
coords = [0 0; 25 0; 50 0; 75 0; 100 0;
          0 25; 25 25; 50 25; 75 25; 100 25;
          0 50; 25 50; 50 50; 75 50; 100 50;
          0 75; 25 75; 50 75; 75 75; 100 75;
          0 100; 25 100; 50 100; 75 100; 100 100];
          
lnods = [1 2 3 8 13 7;
         3 4 5 10 15 9;
         1 7 13 12 11 6;
         3 9 15 14 13 8;
         11 12 13 18 23 17;
         13 14 15 20 25 19;
         11 17 23 22 21 16;
         13 19 25 24 23 18];
     
% dimensoes do problema:
[nn, ndim] = size(coords); % numero de nos e dimensoes do problema (2D)
[nel, npe] = size(lnods);  % numero de elementos e numero de nos por elementos

% nos do contorno
faceinf = find(coords(:,2)==0);
facesup = find(coords(:,2)==250);
faceesq = find(coords(:,1)==0);
facedir = find(coords(:,1)==500);
poco = find(coords(:,1)==500&coords(:,2)==250);

ninf = size(faceinf,1);     %numero de nos na face inferior
nsup = size(facesup,1);     %numero de nos na face superior
nesq = size(faceesq,1);     %numero de nos na face esquerda
ndir = size(facedir,1);     %numero de nos na face direita

%% DADOS DO PROBLEMA:

% Inicializacao de Vetores
k1 = zeros(nel,1);      % permeabilidade na direcao principal 1 (m/s)
k2 = zeros(nel,1);      % permeabilidade na direcao principal 2 (m/s)
alfa = zeros(nel,1);    % angulo da direcao principal com o eixo X (rad)
r = zeros(nel,1);       % recarga no elemento (m3/s/m2)

% Definicao das propriedades de cada elemento (ou conjunto de elementos):
k1(1:nel) = 10^-5;
k2(1:nel) = 10^-5;
alfa(1:nel) = 0;
r(1:nel) = 10^-8;

%% CONDICOES DE CONTORNO:

q0 = zeros(nn,1);        % m3/s
gamma = zeros(nn,1);     % m2/s
h0 = zeros(nn,1);        % m

% exemplo-teste
h0(faceesq) = 20;
gamma(faceesq) = 1000;
h0(faceinf) = 20;
gamma(faceinf) = 1000;
q0(length(coords)) = -10^-4; % poco produtor

%% PROCESSO

processoFluxo2DTrianguloQuadratico

%% POS-PROCESSO

posProcessoTrianguloQuadratico
