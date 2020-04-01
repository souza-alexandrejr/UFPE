function [wellSolsTPWL, statesTPWL, reportTPWL] = runScheduleTPWL(TPWL, schedule, varargin)
% Run a schedule for a physical model using reducer order model TPWL/POD
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   wellSolsTPWL = runScheduleTPWL(TPWL, schedule, varargin)
%
%   [wellSolsTPWL, statesTPWL, reportTPWL] = runScheduleTPWL(TPWL, schedule, varargin)
%
% DESCRIPTION:
%
%   This function takes in a valid schedule file (see required parameters)
%   and runs a simulation through all timesteps, applying TPWL
%   (Trajectory Piecewise Linearization) and POD (Proper Orthogonal 
%   Decomposition) as techniques to construct a Reduced Order Model (ROM) 
%   of a High Fidelity (HF) reservoir model.
%
%   runScheduleTPWL calculates updated states from saved snapshots,
%   obtained from a Training Simulation, using MRST.
%
% REQUIRED PARAMETERS:
%
%   TPWL         - Structure which contains snapshots and jacobians;
%
%   schedule     - Set of controls to be applied at the simulation;
%
%
% OPTIONAL PARAMETERS:
%   
%   'verbose'    - Whether or not to print out information on command prompt;
%
%   'POD'        - Whether or not to apply order reduction;
%
%
%   'energyMin'  - Energy criteria used to include eigenvectors/eigenvalues;
%
%   'optHardThresh' - Apply Optimal Hard Threshold to include 
%                     eigenvectors/eigenvalues, instead energy criteria;
%
%   'plotResults'   - Whether or not to print well outputs on an 
%                     interactive interface at the end of simulation.
%
%   'lang'          - Verbose language, with the options:
%                       'pt-br': Brazilian Portuguese (default)
%                       'eng': English
%
% RETURNS:
%
%   wellSolsTPWL    - Well solution at each control step;
%
%   statesTPWL      - State at each control step;
%
%   reportTPWL      - Report for the simulation.

opt = struct('verbose', false,...
             'POD', false,...
             'energyMin', 0.9999, ...
             'optHardThresh', false, ...
             'plotResults', false, ...
             'lang', 'pt-br');

opt = merge_options(opt, varargin{:});

%% TPWL VECTORS INITIALIZATION
% Load stored states and derivatives from a training simulation

states = TPWL.states;       % Saved states (snapshots)
fluid = TPWL.fluid;         % Fluid Properties
W = TPWL.W;                 % Well struct
dt = TPWL.dt;               % Time steps

nT = length(dt);                     % Number of timesteps
nG = length(states{1,1}.pressure);   % Number of cells
nW = length(W);                      % Number of wells

X_i = zeros(2*nG, nT);              % Saved states from Training Run
X_n = zeros(2*nG, nT);              % States to be obtained from TPWL
U_n = zeros(nW, nT);                % Well controls applied at TPWL

statesTPWL{nT,1} = struct();
wellSolsTPWL{nT,1} = struct();

% Putting the snapshots in the following format:
% Each column represents the states saved in a time step.
% The 'nG' first rows represent the PRESSURE in each cell
% while 'nG' last rows represent the WATER SATURATION in each cell.
X = zeros(2*nG, nT); 
U = zeros(nW, nT);
for i = 1:nT
    X(:, i) = TPWL.X{i}(:,1);
    U(:, i) = cell2mat(TPWL.u{i}(:,1));
end

W_n = W;
wc = vertcat(W(:).cells);
    
%% WELL CONTROLS INITIALIZATION

for i = 1:nT
    inx = schedule.step.control(i);
    countinj = 0;
    countprod = 0;   
    
    % Load control values for TPWL
    for j = 1:length(states{i}.wellSol)
        % INJECTOR WELLS
        if states{i}.wellSol(j).sign == 1
            countinj = countinj + 1;
            if i == 1
                W_n(j).val = U_n(j,i);
                W_n(j).bhpLimit = schedule.control(inx).W(j).lims;
            end
            if strcmp(states{i}.wellSol(j).type,'bhp') % BHP Control
                U_n(j,i) = schedule.control(inx).W(j).val;
                statesTPWL{i}.wellSol(j).type = 'bhp';
            elseif strcmp(states{i}.wellSol(j).type,'wrat') % Water Rate Control
                U_n(j,i) = schedule.control(inx).W(j).val;
                statesTPWL{i}.wellSol(j).type = 'wrat';
            else
                disp('Invalid Control type! Set `bhp´ or `wrat´!');
                break
            end
            statesTPWL{i}.wellSol(j).mixs = [1,0];
            
            statesTPWL{i}.wellSol(j).name = states{i}.wellSol(j).name;
            statesTPWL{i}.wellSol(j).status = true;
            statesTPWL{i}.wellSol(j).val = U_n(j,i);
            statesTPWL{i}.wellSol(j).sign = states{i}.wellSol(j).sign;
            statesTPWL{i}.wellSol(j).cqs = zeros(length(W(j).cells),2);
            statesTPWL{i}.wellSol(j).cdp = zeros(length(W(j).cells),1);
            statesTPWL{i}.wellSol(j).cstatus = ones(length(W(j).cells),1);
            if (strcmp(statesTPWL{i}.wellSol(j).type,'bhp'))
                statesTPWL{i}.wellSol(j).bhp = U_n(j,i);
                statesTPWL{i}.wellSol(j).qTs = 0;
                statesTPWL{i}.wellSol(j).qWs = 0;
                statesTPWL{i}.wellSol(j).qOs = 0;
                statesTPWL{i}.wellSol(j).qGs = states{i}.wellSol(j).qGs;
                statesTPWL{i}.wellSol(j).qs = states{i}.wellSol(j).qs;
            else
                statesTPWL{i}.wellSol(j).bhp = 0;
                statesTPWL{i}.wellSol(j).qTs = 0;
                statesTPWL{i}.wellSol(j).qWs = U_n(j,i);
                statesTPWL{i}.wellSol(j).qOs = 0;
                statesTPWL{i}.wellSol(j).qGs = states{i}.wellSol(j).qGs;
                statesTPWL{i}.wellSol(j).qs = states{i}.wellSol(j).qs;
            end
            
            statesTPWL{i}.wellSol(j).mixs = states{i}.wellSol(j).mixs;
            statesTPWL{i}.wellSol(j).cstatus = states{i}.wellSol(j).cstatus;
        end
            
        % PRODUCER WELLS
        if states{i}.wellSol(j).sign == -1
            countprod = countprod + 1; 
            if i == 1
                W_n(j).val = U_n(j,i);
                W_n(j).bhpLimit = schedule.control(inx).W(j).lims;
            end
            if strcmp(states{i}.wellSol(j).type,'bhp') % BHP Control
                  U_n(j,i) = schedule.control(inx).W(j).val;
                  statesTPWL{i}.wellSol(j).type = 'bhp';
            elseif strcmp(states{i}.wellSol(j).type,'lrat') % Liquid Rate Control
                U_n(j,i) = schedule.control(inx).W(j).val;
                statesTPWL{i}.wellSol(j).type = 'lrat';
            else
                disp('Invalid Control type! Set `bhp´ or `lrat´!');
                break
            end
            statesTPWL{i}.wellSol(j).mixs = [0,1];
                       
            statesTPWL{i}.wellSol(j).name = states{i}.wellSol(j).name;
            statesTPWL{i}.wellSol(j).status = true;
            statesTPWL{i}.wellSol(j).val = U_n(j,i);
            statesTPWL{i}.wellSol(j).sign = states{i}.wellSol(j).sign;
            statesTPWL{i}.wellSol(j).cqs = zeros(length(W(j).cells),2);
            statesTPWL{i}.wellSol(j).cdp = zeros(length(W(j).cells),1);
            statesTPWL{i}.wellSol(j).cstatus = ones(length(W(j).cells),1);
            if (strcmp(statesTPWL{i}.wellSol(j).type,'bhp'))
                statesTPWL{i}.wellSol(j).bhp = U_n(j,i);
                statesTPWL{i}.wellSol(j).qTs = 0;
                statesTPWL{i}.wellSol(j).qWs = 0;
                statesTPWL{i}.wellSol(j).qOs = 0;
                statesTPWL{i}.wellSol(j).qGs = states{i}.wellSol(j).qGs;
                statesTPWL{i}.wellSol(j).qs = states{i}.wellSol(j).qs;
             elseif (strcmp(statesTPWL{i}.wellSol(j).type,'lrat'))
                % FUTURE WORK %
            end

            statesTPWL{i}.wellSol(j).mixs = states{i}.wellSol(j).mixs;
            statesTPWL{i}.wellSol(j).cstatus = states{i}.wellSol(j).cstatus;
            statesTPWL{i}.wellSol(j).wcut = states{i}.wellSol(j).wcut;
        end
    end
end

%% POD VECTORS INITIALIZATION

if (opt.POD)   
       
    minP = TPWL.normP(1);
    maxP = TPWL.normP(2);
    
    minS = TPWL.normS(1);
    maxS = TPWL.normS(2);
     
    % Normalizing Control Vectors
    [U, minU, maxU] = podnorm(U);
    U_n = (U_n - minU)/(maxU - minU);
   
    % Calculate basis function and reduced derivative matrices
    phi = TPWL.phi;
    Z = TPWL.Z;
    redMat = TPWL.redMat;
    
    % Number of eigenvalues of PRESSURE and WATER SATURATION
    v_p = TPWL.redMat.v_p;
    v_s = TPWL.redMat.v_s;
    
    % Reduced states arrays
    nRows = v_p + v_s + 2*length(wc);
    Z_i = zeros(nRows, nT);
    Z_n = zeros(nRows, nT);
end

%% TPWL/POD PERFORMANCE

timerVal = tic;
for i = 1:nT
    
    % ------ PRIVATE ------ %
    
end

timerVal = toc(timerVal);
dispif(opt.verbose, 'Completed %d iterations of %d in %.4f seconds\n', i, nT, timerVal);

%% Saving Report Struct

reportTPWL = struct();
reportTPWL.POD = opt.POD;
reportTPWL.timerVal = timerVal;

%% Plotting TPWL results (interative interface)

if opt.plotResults
    plotWellSols(wellSolsTPWL, cumsum(schedule.step.val), ...
        'datasetnames', 'Constant pressure');
end

end


