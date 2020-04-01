function [phi, Z, redMat] = applyPOD(TPWL, varargin)
% Create a basis function for snapshots of various values
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   [phi, Z, redMat] = applyPOD(TPWL, varargin)
%
% DESCRIPTION:
%
%   This function applies Proper Orthogonal Decomposition (POD) at
%   stored and converged states (snapshots) and 
%   derivative matrices (Jacobians), obtained by Automatic 
%   Differentiation (AD), during a training simulation, using MRST.
%
% REQUIRED PARAMETERS:
%
%   TPWL      - Structure which contains snapshots and jacobians.
%
% OPTIONAL PARAMETERS:
%   
%   'verbose'    - Whether or not to print out information on command prompt;
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
%   phi      - Basis function, which original snapshots will be projected;
%
%   Z        - Reduced states (snapshots);
% 
%   redMat   - Reduced derivative matrices.

opt = struct('verbose', false,...
             'projType', 'PG',...
             'energyMin', 0.9999, ...
             'optHardThresh', false, ...
             'lang', 'pt-br');

opt = merge_options(opt, varargin{:});

nT = numel(TPWL.dt);                     % Number of timesteps
nG = length(TPWL.states{1,1}.pressure);  % Number of cells
nW = length(TPWL.W);                     % Number of wells

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

Xp = X(1:nG,:);         % PRESSURE snapshots Matrix
Xs = X(nG+1:end,:);     % WATER SATURATION snapshots Matrix

% Normalizing all values using the function 'podnorm.m'
[Xp, minP, maxP] = podnorm(Xp);
[Xs, minS, maxS] = podnorm(Xs);

% Construct Permutation Matrix
[P, wc] = permutationConstruct(TPWL.W, nG);

% Local Resolution Scheme: x* = [x_LR ; x_G] (Hewson, 2.27)
% Isolate cells which contains well completions
Xp_ast = P'*Xp;
Xs_ast = P'*Xs;

%% SVD Performance:
% U is the (orthonormal) basis function;
% E is the matrix of singular values arranged by their magnitude;
% The columns of U are the eigenvalues of X*X' and the columns of V
% are the eigenvalues of X'*X.

% SVD for PRESSURE: it generates the phi_p_G from x_p_G
[Up,Ep,Vp] = svd(Xp_ast((length(wc)+1):end,:),'econ'); 

% SVD for WATER SATURATION: it generates the phi_s_G from x_s_G
[Us,Es,Vs] = svd(Xs_ast((length(wc)+1):end,:),'econ'); 

% Both the eigenvalues of X*X' and those of X'*X are equal to
% squared of the singular values of X, arranged in descending
% order along the diagonal of matrix E.
eigP = diag(Ep).^2;
eigS = diag(Es).^2;

% Total energy of the system:
Etp = sum(eigP);
Ets = sum(eigS);

%% BASIS FUNCTION
% Calculation of the number of singular values required
% in order to keep the part of the energy set at 'energyMin'

% ---- PRIVATE ---- %

v = v_p + v_s;
nEig = numel(eigP) + numel(eigS);

if (opt.verbose)
    if (strcmp(opt.lang,'eng'))
        fprintf('%d of %d eigenvalues included\n', v, nEig);
    elseif (strcmp(opt.lang,'pt-br'))
        fprintf('%d of %d autovalores inclusos\n', v, nEig);
    end
end

% Basis function 'phi' 
if (opt.verbose)
    if (strcmp(opt.lang,'eng'))
        disp('Generating POD basis function...');
    elseif (strcmp(opt.lang,'pt-br'))
        disp('Gerando a base do POD...');
    end
end

phi = [phi_p, zeros(length(phi_p),size(phi_s,2));
       zeros(length(phi_s),size(phi_p,2)), phi_s];
phi = sparse(phi);

%% REDUCED STATES
% Original well-gridblocks states included, at first rows.

if (opt.verbose)
    if (strcmp(opt.lang,'eng'))
        disp('Generating reduced states...');
    elseif (strcmp(opt.lang,'pt-br'))
        disp('Gerando estados reduzidos...');
    end
end
Z = [Zp_ast; Zs_ast];

%% REDUCED MATRICES

if (opt.verbose)
    if (strcmp(opt.lang,'eng'))
        disp('Generating reduced matrices...');
    elseif (strcmp(opt.lang,'pt-br'))
        disp('Gerando matrizes reduzidas...');
    end
end

redMat = calcRedMatrices(TPWL, phi, opt.projType);

% Saving number of eigenvectors and eigenvalues included
redMat.v_p = v_p;
redMat.v_s = v_s;

if (opt.verbose)
    if (strcmp(opt.lang,'eng'))
        disp('Done!');
    elseif (strcmp(opt.lang,'pt-br'))
        disp('Pronto!');
    end
end

end
