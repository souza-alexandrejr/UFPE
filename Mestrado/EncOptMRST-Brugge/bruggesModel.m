%% BRUGGE MODEL: TWO-PHASE OIL-WATER RESERVOIR MODEL

mrstModule add ad-core ad-blackoil deckformat optimization ad-props ad-fi 

gravity reset on
pth  = fullfile(ROOTDIR,'examples','EncoptMrst-brugges','EncoptMrstDrivers','brugge-28-data');
fn = fullfile(pth, 'Brugge.DATA');

deck = readEclipseDeck(fn);
deck = convertDeckUnits(deck);

%% Setup the BRUGGE benchmark case for simulation

[state, model, schedule, nonlinear] = initEclipseProblemAD(deck);

G = model.G;
rock = model.rock;
fluid = model.fluid;

%% Changing schedule to BHP

% Number of Injector Wells
nInj = encopt_mrst.injetor_well;

for i = 1:nInj
    if encopt_mrst.var_tipo(1) == 1
        schedule.control.W(i).type = 'rate';
        schedule.control.W(i).val = (encopt_mrst.q_inj(1)+encopt_mrst.q_inj(2))/2;
    elseif encopt_mrst.var_tipo(1) == 2
        schedule.control.W(i).type = 'bhp';
        schedule.control.W(i).val = (encopt_mrst.bhp_inj(1)+encopt_mrst.bhp_inj(2))/2;   
    end
    
    schedule.control.W(i).lims.rate = Inf;
    schedule.control.W(i).lims.bhp = Inf;
    schedule.control.W(i).lims.thp = Inf;  
end

% Number of Producer Wells
nProd = encopt_mrst.producer_well;

for i = (nInj+1):(nProd+nInj)
    if encopt_mrst.var_tipo(2) == 1
        schedule.control.W(i).type = 'rate';
        schedule.control.W(i).val = (encopt_mrst.q_prod(1)+encopt_mrst.q_prod(2))/2;
    elseif encopt_mrst.var_tipo(2) == 2
        schedule.control.W(i).type = 'bhp';
        schedule.control.W(i).val = (encopt_mrst.bhp_prod(1)+encopt_mrst.bhp_prod(2))/2;   
    end

    schedule.control.W(i).lims.lrat = -Inf;
    schedule.control.W(i).lims.bhp = -Inf;
    schedule.control.W(i).lims.thp = -Inf;
end

% reshaping wells name to a logical ordering
schedule.control.W = [schedule.control.W(1);schedule.control.W(3:10);...
    schedule.control.W(2); schedule.control.W(11);schedule.control.W(22); ...
    schedule.control.W(24:30); schedule.control.W(12:21);schedule.control.W(23)];

%% Defining Sets of Control

W = schedule.control(1).W;

% Time Horizon
T = encopt_mrst.t_concessao;

% Timestep
t = encopt_mrst.t_timeStep;

% Refining initial timesteps
dt = rampupTimesteps(T, t);

% Number of Sets of Control
numControl = encopt_mrst.nc;

% Timestep to change the set of controls
stepNc = encopt_mrst.changeNc;

% Number of timesteps at each set of controls (except the first!)
step2control = round(stepNc/t);

Dt = {};
j = 1;

sum = 0;
k = 1;
while sum < stepNc
    sum = sum + dt(k);
    k = k + 1;
end

% Timesteps at the first set of controls
Dt{1,1} = dt(1:k-1); 

% Timestep index where New Set of Controls is applied
encopt_mrst.index = zeros(numControl,1);
encopt_mrst.index(1) = 1;

% Timesteps at the others set of controls
for i = 2:numControl
    if i == numControl
        Dt{numControl,1} = dt(k:end);
        encopt_mrst.index(i) = k;
    else
        Dt{i,1} = dt(k:k+step2control-1);
        encopt_mrst.index(i) = k;
        k = k + step2control; 
    end
end

% Setting Controls
ts = {Dt{:}};            
numCnt = numel(ts);
numT = numel(ts);
[schedule.control(1:numT).W] = deal(W);
schedule.step.control = rldecode((1:numT)', cellfun(@numel, ts));
schedule.step.val = vertcat(ts{:});

encopt_mrst.schedule0MRST = schedule;
encopt_mrst.scheduleMRST = encopt_mrst.schedule0MRST;
encopt_mrst.modelMRST = model;
encopt_mrst.stateMRST = state;
encopt_mrst.fluid = fluid;
encopt_mrst.W = W;
