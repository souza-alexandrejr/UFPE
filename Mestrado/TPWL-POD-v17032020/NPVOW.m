function obj = NPVOW(G, wellSols, schedule, varargin)
% Compute Net Present Value (NPV) from well solutions
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   obj = NPVOW(G, wellSols, schedule, varargin)
%
% DESCRIPTION:
%
%   This function computes the Net Present Value (NPV) of a oil field 
%   production and water injection/production, given a schedule. 
%
% REQUIRED PARAMETERS:
%
%   G           - Grid structure (cells, faces etc).
%
%   wellSols    - Well solution at each control step.
%
%   schedule    - Set of controls applied at simulation.
%
% RETURNS:
%
%   obj         - NPV evolution.

opt     = struct('OilPrice',             1.0 , ...
                 'WaterProductionCost',  0.1 , ...
                 'WaterInjectionCost',   0.1 , ...
                 'DiscountFactor',       0.0 , ...
                 'ComputePartials',      false, ...
                 'tStep' ,               []);
opt     = merge_options(opt, varargin{:});

ro  = opt.OilPrice            / stb;
rw  = opt.WaterProductionCost / stb;
ri  = opt.WaterInjectionCost  / stb;
d   = opt.DiscountFactor;

% pressure and saturaton vectors just used for place-holding
p  = zeros(G.cells.num, 1);
sW = zeros(G.cells.num, 1);

dts   = schedule.step.val;

tSteps = opt.tStep;
if isempty(tSteps) % do all
    time = 0;
    numSteps = numel(dts);
    tSteps = (1:numSteps)';
else
    time = sum(dts(1:(opt.tStep-1)));
    numSteps = 1;
    dts = dts(opt.tStep);
end

obj = repmat({[]}, numSteps, 1);

for step = 1:numSteps
    sol = wellSols{tSteps(step)};
    qWs  = vertcat(sol.qWs);
    qOs  = vertcat(sol.qOs);
    injInx  = (vertcat(sol.sign) > 0);
    status = vertcat(sol.status);

    % Remove closed well.
    qWs = qWs(status);
    qOs = qOs(status);
    injInx = injInx(status);
    nW  = numel(qWs);
    pBHP = zeros(nW, 1); % place-holder


    if opt.ComputePartials
        [qWs, qWs, qWs, qOs, pBHP] = ...
           initVariablesADI(p, sW, qWs, qOs, pBHP);                    %#ok

        clear ignore
    end

    dt = dts(step);
    time = time + dt;

    prodInx = ~injInx;
    obj{step} = ( dt*(1+d)^(-time/year) )*...
                spones(ones(1, nW))*( (-ro*prodInx).*qOs ...
                             +(rw*prodInx - ri*injInx).*qWs );
end

