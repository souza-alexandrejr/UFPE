% Lista de Exercicios Nº 01 %
% ------------------------- %

%% Questao 01 - Letra A

%matriz de rotacao
Ra = [ 1, 0, 0; 0, cos(pi/4), -sin(pi/4); 0, sin(pi/4), cos(pi/4)];
v = [1 5 3]'; %vetor v na base original xyz
vrotA = Ra*v; %vetor v rotacionado

% Verificacao: normas de v e vrot sao iguais
nv = norm(v);
nvrotA = norm(vrotA);

% Verificacao: se R é ortogonal
dRa = det(Ra);

% Verificacao: v = R'*vrot
v = Ra'*vrotA;

%% Questao 01 - Letra B

%matriz de rotacao
Rb = [ cos(pi/3), 0, sin(pi/3); 0, 1, 0; -sin(pi/3), 0, cos(pi/3)];
v = [1 5 3]'; %vetor v na base original xyz
vrotB = Rb*v; %vetor v rotacionado

% Verificacao: normas de v e vrot sao iguais
nv = norm(v);
nvrotB = norm(vrotB);

% Verificacao: se R é ortogonal
dRb = det(Rb);

% Verificacao: v = R'*vrot
v = Rb'*vrotB;

%% Questao 02 - Letra A

% tensor original
t = [1 0 5; 0 4 7; 5 7 2];
% tensor rotacionado
TrotA = Ra*t*Ra';

%% Questao 02 - Letra B

% tensor original
t = [1 0 5; 0 4 7; 5 7 2];
% tensor rotacionado
TrotB = Rb*t*Rb';

%% Questao 03

u = [1, 5, 3]';
v = [0, 3, 7]';
area = norm(cross(u,v));

%% Questao 04

u = [1, 2, 0]';
v = [0, 2, 5]';
w = [8, 0, 3]';
volume = dot(w,cross(u,v));

%% Questao 05, 06 e 07: feitas a mao.

%% Questao 08 - Letra A

Ma = [1 2 0; 0 1 0; 0 0 1];
[autovetoresA, autovaloresA] = eig(Ma);

%% Questao 08 - Letra B

Mb = [0 1 0; 0 0 1; 1 0 0];
[autovetoresB, autovaloresB] = eig(Mb);

%% Questao 08 - Letra C

Mc = [0 1 2; -4 0 4; 2 -1 0];
[autovetoresC, autovaloresC] = eig(Mc);

%% Questao 08 - Letra D

Md = [1 0 0; 0 2 0; 0 0 1];
[autovetoresD, autovaloresD] = eig(Md);

%% Questao 08 - Letra E

Me = [1/sqrt(2) 1/sqrt(2) 0; 1/sqrt(2) -1/sqrt(2) 0; 0 0 1];
[autovetoresE, autovaloresE] = eig(Me);

%% Questao 09

t = [100 -200 -300; -200 200 100; -300 100 -100];

% Letra A: Calculo das Invariantes do Tensor Original
I1 = trace(t);
I2 = 0.5*((trace(t))^2 - trace(t*t'));
I3 = det(t);

% Letra B: Calculo das Invariantes do Tensor Desviador
tesf = 1/3*I1*eye(3,3);
tdesv = t - tesf;

% Letra C e D: Calculo das Tensoes Principais e Cossenos Diretores
[autovetoresT, autovaloresT] = eig(t);

%% Questao 10

m = [0 100 0; 100 0 0; 0 0 20];
autovaloresM = eig(m);
mdiag = diag(autovaloresM);




