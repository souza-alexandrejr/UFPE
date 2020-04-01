function TPWL = exportMatrices(wellSols, states, report, fluid, W, schedule, varargin)
% Export and store snapshots and derivative matrices (Jacobians)
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   TPWL = exportMatrices(wellSols, states, report, fluid, W, schedule)
%
% DESCRIPTION:
%
%   This function exports and stores converged states (snapshots) and 
%   derivative matrices (Jacobians), obtained by Automatic 
%   Differentiation (AD), during a training simulation, using MRST,
%   and also other properties to be used at a reduced order model.
%
% REQUIRED PARAMETERS:
%
%   wellSols  - Well solution at each control step.
%
%   states    - State at each control step.
%
%   report    - Report for the simulation.
%
%   fluid     - Struct containing the functions, as: 
%               * krW, krO, krG - Relative permeability functions
%               * rhoXS         - density of X at surface conditions
%               * bX(p)         - inverse formation volume factor
%               * muX(p)        - viscosity functions (constant)
%               * krX(s)        - rel.perm for X
%               * krOW, krOG    - (If 3ph - oil-water and oil-gas rel.perm)
%               (where X = 'W' [water], 'O' [oil] and 'G' [gas]).
%
%   W         - Well structure defining existing wells.
%
%   schedule  - Set of controls to be applied at the simulation;
%
% OPTIONAL PARAMETERS:
%   
%   'verbose'    - Whether or not to print out information on command prompt;
%
%   'POD'        - Whether or not to apply order reduction;
%
%   'projType'   - Projection type applied to POD, with the options:
%                   'BG': Bubnov-Galerkin projection (default);
%                   'PG': Petrov-Galerkin projection;
%
%   'energyMin'  - Energy criteria used to include eigenvectors/eigenvalues;
%
%   'optHardThresh' - Apply Optimal Hard Threshold to include 
%                     eigenvectors/eigenvalues, instead energy criteria;
%
%   'lang'       - Verbose language, with the options:
%                   'pt-br': Brazilian Portuguese (default)
%                   'eng': English
%
% RETURNS:
%
%   TPWL      - Structure which contains snapshots and jacobians.

opt = struct('verbose', true,...
             'POD', true,...
             'projType', 'BG',...
             'energyMin', 0.9999, ...
             'optHardThresh', false, ...
             'plotResults', false, ...
             'lang', 'pt-br');

opt = merge_options(opt, varargin{:});

%% ARRAYS INITIALIZATION
% Initializes arrays that store results

problem = cell(numel(states),1);    % 'problem' structure
dx = cell(numel(states),1);         % Newton's steps        
rt = zeros(numel(states),1);        % Relation between consecutive dt's
dt = schedule.step.val;             % Timesteps
X = cell(numel(states),1);          % Converged states (snapshots)
u = cell(numel(states),1);          % Well controls

% Accumulation yerms
dA = cell(numel(states),1);  
% Relative to current timestep
dAdx = cell(numel(states),1); 
% Relative to previous timestep
dAdpx = cell(numel(states),1);

% Jacobian matrix
Jac = cell(numel(states),1);
JacM = cell(numel(states),1);

% Well terms
dQ = cell(numel(states),1);
dQdu = cell(numel(states),1);

%% SAVING SNAPSHOTS
% Store results for each step

% Number of cells
nG = numel(states{1}.pressure);

% Number of timesteps
nT = numel(states);

for i = 1:nT
    
    % ---- PRIVATE ---- %

    if (opt.verbose)
        if (strcmp(opt.lang,'eng'))
            fprintf('Exporting matrices and states %d / %d \n', i, nT);
        elseif (strcmp(opt.lang,'pt-br'))
            fprintf('Exportando matrizes e estados %d / %d \n', i, nT);
        end
    end
end
    
%% Save structs to TPWL struct

TPWL = [];
TPWL.dA = dAdpx;
TPWL.X = X;
TPWL.J = JacM;
TPWL.dt = dt;
TPWL.states = states;
TPWL.wellSols = wellSols;
TPWL.W = W;
TPWL.fluid = fluid;
TPWL.u = u; 
TPWL.dQ = dQdu;

%% APPLY ORDER REDUCTION (POD)

% Number of Wells
nW = numel(W);

if (opt.verbose)
    if (strcmp(opt.lang,'eng'))
        disp('Matrices and states saved at TPWL struct');
    elseif (strcmp(opt.lang,'pt-br'))
        disp('Matrizes e estados salvos na estrutura TPWL');
    end
end

if (opt.POD)
    if (opt.verbose)
        if (strcmp(opt.lang,'eng'))
            disp('Applying POD...');
        elseif (strcmp(opt.lang,'pt-br'))
            disp('Aplicando POD...');
        end
    end
    
    % Putting the snapshots in the following format:
    % Each column represents the states saved in a time step.
    % The 'nG' first rows represent the PRESSURE in each cell
    % while 'nG' last rows represent the WATER SATURATION in each cell.
    snapshot = zeros(2*nG, nT); 
    U = zeros(nW, nT);
    for i = 1:nT
        snapshot(:, i) = TPWL.X{i}(:,1);
        U(:, i) = cell2mat(TPWL.u{i}(:,1));
    end
    
    Xp = snapshot(1:nG,:);         % PRESSURE snapshots matrix
    Xs = snapshot(nG+1:end,:);     % WATER SATURATION snapshots matrix

    % Normalizing all values using the function 'podnorm.m'
    [Xp, minP, maxP] = podnorm(Xp);
    [Xs, minS, maxS] = podnorm(Xs);
        
    % Calculate basis function and reduced derivative matrices
    if (opt.optHardThresh)
        [phi, Z, redMat] = applyPOD(TPWL, 'projType', opt.projType, ...
                                       'verbose', opt.verbose, ...
                                       'lang', opt.lang, ...
                                       'optHardThresh', opt.optHardThresh);
    else
        [phi, Z, redMat] = applyPOD(TPWL, 'projType', opt.projType, ...
                                       'verbose', opt.verbose, ...
                                       'lang', opt.lang, ...
                                       'energyMin', opt.energyMin);
    end
       
    TPWL.phi = phi;             % Basis function 'phi' 
    TPWL.Z = Z;                 % Reduced states
    TPWL.redMat = redMat;       % Reduced matrices 
    
    TPWL.normP = [minP, maxP];  % Maximum and minimum pressure values
    TPWL.normS = [minS, maxS];  % Maximum and minimum saturation values

end

end