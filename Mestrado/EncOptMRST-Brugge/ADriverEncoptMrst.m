function [f,encopt_mrst] = ADriverEncoptMrst(x,encopt_mrst)

schedule = encopt_mrst.scheduleMRST;
model = encopt_mrst.modelMRST;
state = encopt_mrst.stateMRST;
G = model.G;
fluid = encopt_mrst.fluid;
W = encopt_mrst.W;

if encopt_mrst.projecao == 1
    projType = 'BG';
elseif encopt_mrst.projecao == 2
    projType = 'PG';
end

energyMin = encopt_mrst.energyMin;

% Injector Limits  
if encopt_mrst.var_tipo(1) == 1
    li = encopt_mrst.q_inj;
elseif encopt_mrst.var_tipo(1) == 2
    li = encopt_mrst.bhp_inj;
end

% Producer Limits
if encopt_mrst.var_tipo(2) == 1
    lp = encopt_mrst.q_prod;
elseif encopt_mrst.var_tipo(2) == 2
    lp = encopt_mrst.bhp_prod;
end

% Number of Injector Wells
nInj = encopt_mrst.injetor_well;

% Number of Producer Wells
nProd = encopt_mrst.producer_well;

% Number of Controls
numCnt = encopt_mrst.nc;
    
scaling.boxLims = [repmat(li, nInj, 1); repmat(lp, nProd, 1)];
boxLims = scaling.boxLims;

minU = min(x);
maxU = max(x);
if or(minU < -eps , maxU > 1+eps)
    warning('Controls are expected to lie in [0 1]');
end

% Update Schedule
schedule = control2schedule(x, schedule, scaling);

% Simulation Run:
if encopt_mrst.simulation == 1
    [wellSols, states, report] = simulateScheduleAD(state, model, schedule);
    % Training Run
    if encopt_mrst.training == 1
        TPWL = exportMatrices(wellSols, states, report, fluid, W, schedule);
    end
    encopt_mrst.TPWL = TPWL;
    encopt_mrst.simulation = encopt_mrst.rom + 1; 
    save encopt_mrst.mat
elseif encopt_mrst.simulation == 2
    [wellSols, states] = runScheduleTPWL(encopt_mrst.TPWL, schedule);
elseif encopt_mrst.simulation == 3
    [wellSols, states] = runScheduleTPWL(encopt_mrst.TPWL, schedule, 'POD', true,...
        'energyMin', energyMin, 'projType', projType);
end

% Timestep where Set of Controls is changed
index = encopt_mrst.index;

T = convertTo(cumsum(schedule.step.val), year);

%% Vector: Set of Controls x Water/Liquid Rate

names = {'BR-P-1','BR-P-2', ...
         'BR-P-3', 'BR-P-4', 'BR-P-5', 'BR-P-6', 'BR-P-7', 'BR-P-8', ...
         'BR-P-9', 'BR-P-10', 'BR-P-11', 'BR-P-12', 'BR-P-13', 'BR-P-14', ...
         'BR-P-15', 'BR-P-16', 'BR-P-17', 'BR-P-18', 'BR-P-19', 'BR-P-20'};

nn = numel(names);

FieldWaterRate = zeros(numel(T),1);
FieldOilRate = zeros(numel(T),1);
% field water rate
qWs_field = zeros(numCnt,1);
% field liquid rate
qTs_field = zeros(numCnt,1);

for j = 1:nn
    name = names{j};

    FieldWaterRate = FieldWaterRate + convertTo(abs(getWellOutput(wellSols, 'qWs', name)), stb/day);
    FieldOilRate = FieldOilRate + convertTo(abs(getWellOutput(wellSols, 'qOs', name)), stb/day);
end

FieldLiquidRate = FieldOilRate + FieldWaterRate;

for i = 1:numCnt
    qWs_field(i) = FieldWaterRate(index(i));
    qTs_field(i) = FieldLiquidRate(index(i));
end

encopt_mrst.qTs_field = qTs_field;
encopt_mrst.qWs_field = qWs_field;

save encopt_mrst.mat
    
%% NPV Computation

npvopts = {'OilPrice', encopt_mrst.ro, ...
           'WaterProductionCost', encopt_mrst.wp , ...
           'WaterInjectionCost', encopt_mrst.wi , ...
           'DiscountFactor', encopt_mrst.d };
       
objScalingVPL = encopt_mrst.normalizador_vpl;
encopt_mrst.scheduleMRST = schedule;
encopt_mrst.npvoptsMRST = npvopts;
encopt_mrst.statesMRST = states;
encopt_mrst.wellSolsMRST = wellSols;
encopt_mrst.boxLimsMRST = boxLims;

% Compute Objective Function: NPV
vals = NPVOW(G, wellSols, schedule,npvopts{:});
val = sum(cell2mat(vals))*objScalingVPL;
f = val;

end

