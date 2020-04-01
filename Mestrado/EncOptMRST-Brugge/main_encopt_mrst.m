 clear; clc;
close all

addpath('EncoptMrstDrivers')
addpath('TPWL-POD-v17032020')
mrstModule add ad-core ad-blackoil deckformat optimization ad-props ad-fi 

%%  -----------   MODIFIED FOR MRST AND ENCOPT   -------------------  %%

encopt_mrst.contador = 1;
save -ascii c_nonlinear.dat

% TIPO DE SIMULAÇÃO INICIAL

                                % 1 ALTA FIDELIDADE
encopt_mrst.simulation = 1;     % 2 TPWL
                                % 3 TPWL-POD

% TREINAMENTO COM BHP CONSTANTE IGUAL A MÉDIA DOS BOUNDS
% load('brugge-28-training-run-21-year-14cc-bhp-constant-v2.mat');
% load('brugge-28-training-run-14-months-14cc-bhp-constant-avg.mat');
% load('brugge-28-training-run-3-years-6-cc-bhp-constant.mat');
% encopt_mrst.TPWL = TPWL;

% MODELO DE ORDEM REDUZIDA APLICADA NAS DEMAIS SIMULAÇÕES
                                % 0 ALTA FIDELIDADE
encopt_mrst.rom = 2;            % 1 TPWL
                                % 2 TPWL-POD

% TIPO DE PROJEÇÃO (POD)

encopt_mrst.projecao = 1;       % 1 BUBNOV-GALERKIN
                                % 2 PETROV-GALERKIN
                                
% FAZER TREINAMENTO NA SIMULAÇÃO INICIAL?
                                % 0 NÃO-FAZER TREINAMENTO
encopt_mrst.training = 0;                          
                                % 1 FAZER TREINAMENTO

% CRITÉRIO DE ENERGIA (POD)

% encopt_mrst.energyMin = 0.9999;
encopt_mrst.energyMin = 0.999999;

% DEFINICAO DO TIPO DE GRADIENTE PARA OTIMIZACAO 

                            %  1  BY ADJOINT 
encopt_mrst.gradiente = 1; 
                            

% SELECIONE O MODELO GEOLOGICO

encopt_mrst.model = 28; 

% DEFINA O TIPO DE VARIAVEL A OTIMIZAR: [INJ, PROD] 

                                % 1   VARIAVEL VAZAO
encopt_mrst.var_tipo = [2, 2];  %    
                                % 2   VARIAVEL BHP 

% DEFINA SE A OTIMIZACAO COMECA DE UM PONTO QUALQUER OU DA ULTIMA ITERACAO                           

                            % 1 PONTO INICIAL
encopt_mrst.restart = 1; 
                            % 2 PONTO RESTART DA ITERACAO ANTERIOR

% DEFINICAO DE VALVULAS E CONTROLES DOS POCOS      

% DEFINICAO DAS VALVULAS DOS POCOS

encopt_mrst.valvulas = 'valvulas_well.dat';

encopt_mrst.nv = load(encopt_mrst.valvulas); 

% NUMERO TOTAL DE VALVULAS DOS POCOS

encopt_mrst.nv_total = sum(load(encopt_mrst.valvulas));

% NUMERO TOTAL DE PRODUTORES

encopt_mrst.producer_well = 20;

% NUMERO TOTAL DE INJETORES

encopt_mrst.injetor_well = 10;

% NUMERO TOTAL DE POCOS

encopt_mrst.nwell = encopt_mrst.producer_well + encopt_mrst.injetor_well;

% NUMERO DE VALVULAS INJETORES

encopt_mrst.nv_inj = sum(encopt_mrst.nv(encopt_mrst.producer_well+1:encopt_mrst.nwell,1));  

% NUMERO DE VALVULAS PRODUTORES

encopt_mrst.nv_prod = sum(encopt_mrst.nv(1:encopt_mrst.producer_well,1));   

% DEFINICAO DAS RESTRICOES DE POCOS E CAMPO

% VAZAO MAXIMA DE PRODUCAO LIQUIDA NO CAMPO

encopt_mrst.Q_lprod = 40000; % stb/day

% VAZAO MAXIMA PRODUZIDA NO CAMPO

encopt_mrst.Qwp_max = 20000; % stb/day

% LIMITE DA VAZAO POR POÇO PRODUTOR

encopt_mrst.q_prod = [0, 0]*stb/day;

% LIMITE DA VAZAO POR POÇO INJETOR

encopt_mrst.q_inj = [0, 0]*stb/day;

% LIMITES DE BHP POR POCO PRODUTOR

encopt_mrst.bhp_prod = [1000, 2400]*psia;

% LIMITES DE BHP POR POCO INJETOR

encopt_mrst.bhp_inj = [2400, 3000]*psia;
              
% LIMITE DA VAZAO POR VALVULA PRODUTOR NORMALIZADO

encopt_mrst.q_valvula_prod = [0.0, 1.0];

% LIMITE DA VAZAO POR VALVULA INJETOR NORMALIZADO

encopt_mrst.q_valvula_inj = [0.0, 1.0]; 

% TEMPO DA SIMULACAO 

% encopt_mrst.t_concessao = 21*year;
% encopt_mrst.t_concessao = (1*year + 2*1*year/12); % 14 meses
encopt_mrst.t_concessao = 3*year;

% TIME-STEP 

encopt_mrst.t_timeStep = 1*year/12; % 12*30*day < 1*year !!! (1 mes)
 
% DEFINA O NUMERO DE CICLOS DE CONTROLE

encopt_mrst.nc = 6;

% DEFINIR TEMPO EM QUE MUDA O CICLO DE CONTROLE

% encopt_mrst.changeNc = 1.5*year; % 12*30*day < 1*year !!!
encopt_mrst.changeNc = 1*year/2; % 6 months

% DEFINA O TIPO DE PONTO INICIAL

                               % 1 = PONTO INICIAL POR CONTROLE 
encopt_mrst.p_inicial = 3;     % 2 = PONTO INICIAL POR POCO DEFINIDO ALEATORIAMENTE
                               % 3 = PONTO INICIAL INFORMADO PELO USUARIO

if encopt_mrst.restart == 1
    encopt_mrst.file_p_inicial = 'brugge_inicial_3years.dat';
elseif encopt_mrst.restart == 2
    encopt_mrst.file_p_inicial = 'x.dat';
end

% CRIANDO OU CHAMANDO O PONTO INICIAL DE ACORDO COM SUA ESCOLHA.

encopt_mrst.x0 = P_inicial(encopt_mrst);
% encopt_mrst.x0 = ones(420,1)*0.5;

% NUMERO TOTAL DE VARIAVEIS DE PROJETO = SOMA DE VALVULAS DO CAMPO

encopt_mrst.nx = encopt_mrst.nc*encopt_mrst.nv_total;

% CHAMADA DO TIPO DE OTIMIZACAO

% RESTRICOES LINEARES 
                            % 1 SEM RESTRICOES LINEARES
encopt_mrst.reslinear = 2;
                            % 2 COM RESTRICOES NÃO-LINEARES

% TIPO DE OTIMIZADOR 
                             
                            %  1  OTIMIZADOR SQP DO MATLAB   
encopt_mrst.otimizador = 1;
                            %  2  OTIMIZADOR SNOPT 

% UTILIZANDO O ALGORITMO "SQP" UNICAMENTE PARA MATLAB 

encopt_mrst.Algorithm = 'sqp';
% encopt_mrst.Algorithm = 'interior-point';

% TOLERANCIA DE "X" (CONTROLE)
encopt_mrst.TolX = 1.e-4;

% MAXIMO NUMERO DE ITERACOES
encopt_mrst.MaxIter = 30;

% MAXIMO NUMERO DE F-count
% encopt_mrst.MaxFunctionEvaluations = 50;

% TOLERANCIA PARA A OTIMIZACAO
encopt_mrst.TolFun = 1e-4;

% FATOR DE MULTIPLICACAO PARA O VPL
encopt_mrst.normalizador_vpl = -1e-7;

% DADOS PARA O CALCULO DO VPL

% RECEITA LIQUIDA UNITARIA DO OLEO m3 = 6.289814*45
encopt_mrst.ro = 1; %($/stb)

% CUSTO UNITARIA DA AGUA PRODUZIDA
encopt_mrst.wp = 0; %($/stb)

% CUSTO UNITARIA DA AGUA 
encopt_mrst.wi = 0; %($/stb)

% TAXA MINIMA ATRATIVA
encopt_mrst.d=0;

% DEFININDO O MODELO 

encopt_mrst.Model = 'bruggesModel';

save encopt_mrst.mat

%-----------  END MODIFIED FOR MRST AND ENCOPT -------------------

%% CHAMADA DA FUNCAO PARA GERAR OS 'BOUNDS' DOS CONTROLES 

optTimeStart = tic;
[x_star,FVAL,Converg,Resumo] = otimizacao_encopt_mrst(encopt_mrst); 
optTimeElapsed = toc(optTimeStart);
fprintf('Optimization completed in %.4f seconds\n', optTimeElapsed);
save('x_star.mat','x_star');
