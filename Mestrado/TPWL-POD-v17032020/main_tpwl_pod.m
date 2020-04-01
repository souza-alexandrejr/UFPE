%% REDUCED ORDER MODEL TPWL/POD APPLIED TO RESERVOIR SIMULATION
% Developed by Alexandre de Souza Jr. (UFPE)

clear; clc;
close all

addpath('EncoptMrstDrivers')
addpath('TPWL-POD-v17032020')

%%  -----------   MODIFIED FOR MRST AND ENCOPT   -------------------  %%

% TIPO DE SIMULAÇÃO
        
encopt_mrst.simulation = 1;     % 1 ALTA FIDELIDADE

% MODELO DE ORDEM REDUZIDA
                                % 0 HF Run
encopt_mrst.rom = 0;            % 1 TPWL
                                % 2 TPWL-POD

% TIPO DE PROJEÇÃO (POD)

encopt_mrst.projecao = 1;       % 1 BUBNOV-GALERKIN
                                % 2 PETROV-GALERKIN

% CRITÉRIO DE ENERGIA (POD)

encopt_mrst.energyMin = 0.9999;

% REALIZAR OPTIMAL HARD THRESHOLD

encopt_mrst.optHardThreshold = true;

% SELECIONE O MODELO GEOLOGICO

encopt_mrst.model = 28; 

% DEFINA O TIPO DE VARIAVEL A OTIMIZAR: [INJ, PROD] 

                                % 1   VARIAVEL VAZAO
encopt_mrst.var_tipo = [2, 2];  %    
                                % 2   VARIAVEL BHP 

% DEFINICAO DOS CONTROLES DOS POCOS      

% NUMERO TOTAL DE PRODUTORES

encopt_mrst.producer_well = 20;

% NUMERO TOTAL DE INJETORES

encopt_mrst.injetor_well = 10;

% NUMERO TOTAL DE POCOS

encopt_mrst.nwell = encopt_mrst.producer_well + encopt_mrst.injetor_well;

% DEFINICAO DAS RESTRICOES DE POCOS E CAMPO

% VAZAO MAXIMA DE PRODUCAO LIQUIDA NO CAMPO

encopt_mrst.Q_lprod = 40000;

% VAZAO MAXIMA PRODUZIDA NO CAMPO

encopt_mrst.Qwp_max = 20000;

% LIMITE DA VAZAO POR POÇO PRODUTOR

encopt_mrst.q_prod = [0, 0]*stb/day;

% LIMITE DA VAZAO POR POÇO INJETOR

encopt_mrst.q_inj = [0, 0]*stb/day;

% LIMITES DE BHP POR POCO PRODUTOR

encopt_mrst.bhp_prod = [1000, 2400]*psia;

% LIMITES DE BHP POR POCO INJETOR

encopt_mrst.bhp_inj = [2400, 3000]*psia;
              
% TEMPO DA SIMULACAO 

encopt_mrst.t_concessao = 2*year;

% TIME-STEP 

encopt_mrst.t_timeStep = 1*year/12; 

% DEFINA O NUMERO DE CICLOS DE CONTROLE

encopt_mrst.nc = 4;

% DEFINIR TEMPO EM QUE MUDA O CICLO DE CONTROLE

encopt_mrst.changeNc = encopt_mrst.t_concessao/encopt_mrst.nc;

% DADOS PARA O CALCULO DO VPL

% RECEITA LIQUIDA UNITARIA DO OLEO m3 = 6.289814*45
encopt_mrst.ro = 1; %($/stb)

% CUSTO UNITARIA DA AGUA PRODUZIDA
encopt_mrst.wp = 0; %($/stb)

% CUSTO UNITARIA DA AGUA 
encopt_mrst.wi = 0; %($/stb)

% TAXA MINIMA ATRATIVA
encopt_mrst.d = 0;

save('encopt_mrst.mat','encopt_mrst');

%% TRAINING SIMULATION

bruggesModel;

% Total Time - 2 years
T = encopt_mrst.t_concessao;
% Timestep size - 1 month
dt = encopt_mrst.t_timeStep;   
% Defines smaller time intervals initially
dt = rampupTimesteps(T, dt);

% Sets a random schedule to bruggeModel
randSchedule = 0;
if randSchedule == 0
    % constant BHP set at bruggeModel (default: average between limits!)
    schedule = simpleSchedule(dt, 'W', W);
elseif randSchedule == 1
    % setting a random schedule
    nControl = encopt_mrst.nc;
    schedule = randomSchedule(dt, W, nControl, [2600,3000]*psia, [1000, 2400]*psia);
end

[wellSols, states, report] = simulateScheduleAD(state, model, schedule);

%% MATRICES AND CONVERGED STATES EXPORTATION

close all;

TPWL = exportMatrices(wellSols, states, report, fluid, W, schedule);

% Saving Matrices and States obtained from a Training Run
save('brugge-28-training-run-2-years-4-cc-bhp-constant.mat', 'TPWL', '-v7.3');

%% HIGH FIDELITY RUN: NEW SET OF CONTROLS (SCHEDULE)

clear; clc;
close all

load('encopt_mrst.mat');

bruggesModel;

% Total Time - 2 years
T = encopt_mrst.t_concessao;
% Timestep size - 1 month
dt = encopt_mrst.t_timeStep;   
% Defines smaller time intervals initially
dt = rampupTimesteps(T, dt);

% Sets a random schedule to bruggeModel
randSchedule = 1;
if randSchedule == 0
    % constant BHP set at bruggeModel
    schedule = simpleSchedule(dt, 'W', W);
elseif randSchedule == 1
    % setting a random schedule
    nControl = encopt_mrst.nc;
    schedule = randomSchedule(dt, W, nControl, [2500,3000]*psia, [1000, 1500]*psia);
end

[wellSolsHF, statesHF] = simulateScheduleAD(state, model, schedule);

%% TPWL PERFORMANCE

close all;

load('brugge-28-training-run-2-years-4-cc-bhp-constant.mat');

[wellSolsTPWL, statesTPWL] = runScheduleTPWL(TPWL, schedule);

%% TPWL/POD PERFOMANCE

close all;

energyMin = encopt_mrst.energyMin;
optHardThresh = encopt_mrst.optHardThreshold;
projType = encopt_mrst.projecao;

if encopt_mrst.projecao == 1
    projType = 'BG';                % Bubnov-Galerkin Projection
elseif encopt_mrst.projecao == 2
    projType = 'PG';                % Petrov-Galerkin Projection
end

[wellSolsTPWLPOD, statesTPWLPOD] = runScheduleTPWL(TPWL, schedule, ...
    'verbose', true, 'POD', true, 'projType', 'PG', 'optHardThresh', optHardThresh);

save('wellSolsTPWLPOD-PG-OHT.mat','wellSolsTPWLPOD');
save('statesTPWLPOD-PG-OHT.mat','statesTPWLPOD');

%% Plotting MRST/TPWL/TPWL-POD Results

close all;

plotBruggeWellResults(wellSolsHF, wellSolsTPWL, wellSolsTPWLPOD, schedule, 'lang', 'pt-br');

%% NPV Calculation

npvopts = {'OilPrice', 80, ...
           'WaterProductionCost', 5, ...
           'WaterInjectionCost', 5, ...
           'DiscountFactor', 0.10};

NPV_hf = NPVOW(G, wellSolsHF, schedule, npvopts{:});
NPV_hf = cumsum(cell2mat(NPV_hf));

NPV_tpwl = NPVOW(G, wellSolsTPWL, schedule, npvopts{:});
NPV_tpwl = cumsum(cell2mat(NPV_tpwl));

NPV_tpwlpod = NPVOW(G, wellSolsTPWLPOD, schedule, npvopts{:});
NPV_tpwlpod = cumsum(cell2mat(NPV_tpwlpod));

fig = figure;
fig.WindowState = 'maximized';
plot(cumsum(schedule.step.val/day), NPV_hf,'k');
hold on
plot(cumsum(schedule.step.val/day), NPV_tpwl, 'r--o');
hold on
plot(cumsum(schedule.step.val/day), NPV_tpwlpod,'b--s');
title('Net Present Value Evolution');
xlabel('Time(days)')
ylabel('NPV')
legend('MRST', 'TPWL', 'TPWL-POD','Location', 'Best');
grid on
saveas(fig, 'NPV', 'png');

