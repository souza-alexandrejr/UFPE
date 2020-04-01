function schedule = randomSchedule(dt, W, nControl, injVal, prodVal, varargin)
% Generate a random schedule for a physical model.
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   schedule = randomSchedule(dt, W, nControl, injVal, prodVal, varargin)
%
% DESCRIPTION:
%
%   This function generates a schedule structure with random values,
%   applied to all injector/producer wells.
%
% REQUIRED PARAMETERS:
%
%   dt   - Array containg all timesteps;
%
%   W    - Well structure defining existing wells;
%
%   nControl - Number of set of controls;
%
%   injVal   - Bounds of injector wells control values.
%              If length(injVal) = 1, it assumes to be constant.
%
%   prodVal  - Bounds of producer wells control values.
%              If length(prodVal) = 1, it assumes to be constant.
%
% OPTIONAL PARAMETERS:
%   
%   'seed'   - Used to generate random vector (defaut s = rng(23)).
%
% RETURNS:
%
%   schedule  - Set of controls to be applied at the simulationl.

opt = struct('seed', 23);        

opt = merge_options(opt, varargin{:});

nWells = length(W);

% Simulation time
T = sum(dt);

% Time to change the set of controls
changeControlTime = T/nControl;
changeControl = changeControlTime;

% Setting cell array with control indexes
ts = cell(1,numel(nControl));
count = 1;
k = 1;
for i = 1:numel(dt)
    if (sum(dt(1:i)) > changeControl)
        ts{1,count} = dt(k:i-1);
        changeControl = changeControl + changeControlTime;
        count = count + 1;
        k = i;
    end
end
ts{1,count} = dt(k:numel(dt));      

% Saving at 'ts' struct
numCnt = numel(ts);
[schedule.control(1:numCnt).W] = deal(W);
schedule.step.control = rldecode((1:nControl)', cellfun(@numel, ts));
schedule.step.val     = vertcat(ts{:});

s = rng(opt.seed);

for j = 1:nWells
    % Injector Wells
    if ~isempty(injVal)
        % Constant value 
        if (length(injVal) == 1)
            if W(j).sign == 1
                for i = 1:nControl
                    schedule.control(i).W(j).val = injVal;
                end
            end
        % Random values 
        elseif (length(injVal) == 2)
            a = injVal(1);
            b = injVal(2);
            randInj = (b-a).*rand(nControl,1) + a;
            if W(j).sign == 1
                for i = 1:nControl
                    schedule.control(i).W(j).val = randInj(i);
                end
            end
        else
            disp('Valor inválido para injVal!');
        end
    end
    % Producer Wells
    if ~isempty(prodVal)
        % Constant value 
        if (length(prodVal) == 1)
            if W(j).sign == -1
                for i = 1:nControl
                    schedule.control(i).W(j).val = prodVal;
                end
            end
        % Random values 
        elseif (length(prodVal) == 2)
            c = prodVal(1);
            d = prodVal(2);
            randProd = (d-c).*rand(nControl,1) + c;
            if W(j).sign == -1
                for i = 1:nControl
                    schedule.control(i).W(j).val = randProd(i);
                end
            end
        else
            disp('Valor inválido para prodVal!');
        end
    end
end
rng(s);

end

