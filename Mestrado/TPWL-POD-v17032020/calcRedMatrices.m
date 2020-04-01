function redMat = calcRedMatrices(TPWL, phi, projType)
% Reduced derivate matrices computation
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   POD = calcRedMatrices(TPWL, phi, projType)
%
% DESCRIPTION:
%
%   This function calculates the reduced derivate matrices and saves the
%   projection of the Jacobian to be used for TPWL/POD.
%
% REQUIRED PARAMETERS:
%
%   TPWL     - Structure which contains original snapshots and jacobians;
%
%   phi      - Basis function, which original snapshots will be projected;
%
%   'projType'   - Projection type applied to POD, with the options:
%                   'BG': Bubnov-Galerkin projection (default);
%                   'PG': Petrov-Galerkin projection;
%
% RETURNS:
%
%   redMat      - Reduced states and derivative matrices.

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

% Normalizing all values using the function 'podnorm.m' (Hewson-modificado)
[Xp, minP, maxP] = podnorm(Xp); dXp = maxP - minP;
[Xs, minS, maxS] = podnorm(Xs); dXs = maxS - minS;

% Normalizing Control Vectors
[U, minU, maxU] = podnorm(U);
dU = maxU - minU;
      
for i = 1:nT

    % TPWL Matrices
    J = TPWL.J{i};
    A = TPWL.dA{i};
    Q = TPWL.dQ{i}; 
            
    % Normalizing Derivative Matrices
    J(:,1:nG) = J(:,1:nG)*dXp;
    J(:,nG+1:end) = J(:,nG+1:end)*dXs;
    
    A(:,1:nG) = A(:,1:nG)*dXp;
    A(:,nG+1:end) = A(:,nG+1:end)*dXs;

    Q = Q*dU;
    
    switch(projType)
    case 'BG'
        J_r = phi'*J*phi;
        dA_r = phi'*A*phi;
        dQ_r = phi'*Q;
        
        redMat.dA_r{i,1} = dA_r;
        redMat.dQ_r{i,1} = dQ_r;
        redMat.J_r{i,1} = J_r;

        clear J J_r A dA_r Q dQ_r

    case 'PG'       
        dA_r = (J*phi)'*A*phi;
        dQ_r = (J*phi)'*Q;
        J_r = (J*phi)'*J*phi;
               
        redMat.dA_r{i,1} = dA_r;
        redMat.dQ_r{i,1} = dQ_r;
        redMat.J_r{i,1} = J_r;

        clear J J_r A dA_r Q dQ_r

    end    
end

end
