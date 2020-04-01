function states = computeWellSolution(states, fluid, W, varargin)
% Compute the well rates of a physical model
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   states = computeWellSolution(states, fluid, W, varargin)
%
% DESCRIPTION:
%
%   This function computes well rates from pressure and saturation maps
%   obtained from a simulation run. Future work will include well bhp's
%   computation, when well are controled by rates.
%
% REQUIRED PARAMETERS:
%
%   states    - State at each control step.
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
% OPTIONAL PARAMETERS:
%   
%   'model'    - Model of study (Relative permeability functions of
%                'brugge' model differ of other models).
%
% RETURNS:
%
%   states     - Updated structure which contains well rates.

opt = struct('model', 'brugge');

opt = merge_options(opt, varargin{:});

%% Setting Properties

trMult = 1;
if isfield(fluid, 'tranMultR')
    trMult = fluid.tranMultR(states.pressure);
end

pcOW = 0;
if isfield(fluid, 'pcOW')
    pcOW  = fluid.pcOW(states.s(:,1));
end

% Relative Permeability Curves (Water/Oil)
if strcmp(opt.model,'brugge')
    krW = fluid.krW(states.s(:,1));
    krO = fluid.krOW(states.s(:,2));
else
    krW = fluid.krW(states.s(:,1));
    krO = fluid.krO(states.s(:,2));
end

% Formation Volume Factor (Water/Oil)
bW = fluid.bW(states.pressure - pcOW);
bO = fluid.bO(states.pressure);

% Density at Standard Conditions (Water/Oil)
rhoS = [fluid.rhoWS, fluid.rhoOS];

% Mobility (Water/Oil)
mobW = trMult.*krW./fluid.muW(states.pressure - pcOW);
if isfield(fluid, 'BOxmuO')
    % mob0 is already multplied with b0
    mobO   = trMult.*krO./fluid.BOxmuO(states.pressure);
else
    mobO   = trMult.*krO./fluid.muO(states.pressure);
end

%% Setting Well Grid-blocks Properties

% Well connections (well grid-blocks with completion)
wc = vertcat(W.cells);

% Pressure at well connections
pw = states.pressure(wc);

% Formation Volume Factor (Water/Oil) at well connections
% Remember: b = 1/B
bw = {bW(wc), bO(wc)};

% Density (Water/Oil) at Reservoir Conditions
rhoR = rhoS.*cell2mat(bw);

% Mobility (Water/Oil) at well connections
mw   = [mobW(wc), mobO(wc)];

% Well Radius
rw   = {};

%% Update of hydrostatic pressure difference between bottom hole and connections
states.wellSol = updateConnDP(W, states.wellSol, bw, rw, rhoS, 'OW');

%% Computing Well Rates/BHP

connWcE = 0;

for k = 1:length(W)
           
    connWcS = 1 + connWcE;
    connWcE = connWcS + length(W(k).cells) - 1;
    
    % INJECTOR WELL
    if states.wellSol(k).sign == 1
        
        if strcmp(states.wellSol(k).type, 'bhp')
            
            % Pressure at Injector Well Grid-blocks
            p = pw(connWcS:connWcE);
            
            % BHP at Injector Well Grid-blocks
            pBH_tmp = repmat(states.wellSol(k).bhp,length(W(k).cells),1);
            
            % Getting drawdown
            wSol = states.wellSol;
            drawdown = getDrawdown(wSol(k), pBH_tmp, p);

            % Getting Well Transmissibility
            [Tw, ~, connInjInx] = getWellTrans(W(k));
            
            % Mobility at Injector Well Grid-blocks
            mob = [mw(connWcS:connWcE,1),mw(connWcS:connWcE,2)];
            
            % Density at Injector Well Grid-blocks
            rho = [rhoR(connWcS:connWcE,1),rhoR(connWcS:connWcE,2)];
            
            % Compute Injector Well Rate
            [~, cq_s] = computePerforationRates(W(k),...
                        connInjInx, drawdown, Tw, mob, rho, rhoS);
                    
            % Update states struct
            q_inj = cell2mat(cq_s);
            states.wellSol(k).qWs = sum(q_inj(:,1));
            states.wellSol(k).qOs = sum(q_inj(:,2));
            states.wellSol(k).cqs(:,1) = q_inj(:,1);
            states.wellSol(k).wcut = states.wellSol(k).qWs/(states.wellSol(k).qWs + states.wellSol(k).qOs);
            
        elseif strcmp(states.wellSol(k).type, 'wrat') % Water Rate
            
            % Pressure at Injector Well Grid-blocks
            p = pw(connWcS:connWcE);
            
            % Getting Well Transmissibility
            [Tw, ~, connInjInx] = getWellTrans(W(k));
                    
            % Mobility at Injector Well Grid-blocks
            mob = [mw(connWcS:connWcE,1),mw(connWcS:connWcE,2)];
            
            % Density at Injector Well Grid-blocks
            rho = [rhoR(connWcS:connWcE,1),rhoR(connWcS:connWcE,2)];
            
            % Connection Drop Pressure
            wSol = states.wellSol;
            connDropPress = vertcat(wSol(k).cdp);
            
            % Compute Injector Well BHP
            q_sp = states.wellSol(k).qWs;          
            pwf_ref = computeWellBHP(W(k), p, connDropPress, ...
                connInjInx, q_sp, Tw, mob, rho, rhoS);
           
            % Update states struct
            states.wellSol(k).bhp = pwf_ref;
            states.wellSol(k).qWs = q_sp;
        end
          
    % PRODUCER WELL 
    elseif states.wellSol(k).sign == -1
        
        if strcmp(states.wellSol(k).type, 'bhp')
            
            % Pressure at Producer Well Grid-blocks
            p = pw(connWcS:connWcE);
            
            % BHP at Producer Well Grid-blocks
            pBH_tmp = repmat(states.wellSol(k).bhp,length(W(k).cells),1);
            
            % Getting drawdown
            wSol = states.wellSol;
            drawdown = getDrawdown(wSol(k), pBH_tmp, p);

            % Getting Well Transmissibility
            [Tw, ~, connInjInx] = getWellTrans(W(k));
            
            % Mobility at Producer Well Grid-blocks
            mob = [mw(connWcS:connWcE,1),mw(connWcS:connWcE,2)];
            
            % Density at Producer Well Grid-blocks
            rho = [rhoR(connWcS:connWcE,1),rhoR(connWcS:connWcE,2)];
            
            % Compute Producer Well Rate
            [~, cq_s] = computePerforationRates(W(k),...
                        connInjInx, drawdown, Tw, mob, rho, rhoS);
          
            % Update states struct
            q_prod = cell2mat(cq_s);
            states.wellSol(k).qWs = sum(q_prod(:,1));
            states.wellSol(k).qOs = sum(q_prod(:,2));
            states.wellSol(k).cqs(:,1) = q_prod(:,1);
            states.wellSol(k).cqs(:,2) = q_prod(:,2);
            states.wellSol(k).wcut = states.wellSol(k).qWs/(states.wellSol(k).qWs + states.wellSol(k).qOs);
            
%             bhp2rates(states,fluid,W,varargin);
            
        elseif strcmp(states.wellSol(k).type, 'wrat') % Water Rate
            %%%%%% EM DESENVOLVIMENTO %%%%%%%%%%
            % Pressure at Injector Well Grid-blocks
            p = pw(connWcS:connWcE);
            
            % Getting Well Transmissibility
            [Tw, ~, connInjInx] = getWellTrans(W(k));
        
            % Mobility at Injector Well Grid-blocks
            mob = [mw(connWcS:connWcE,1),mw(connWcS:connWcE,2)];
            
            % Density at Injector Well Grid-blocks
            rho = [rhoR(connWcS:connWcE,1),rhoR(connWcS:connWcE,2)];
            
            % Connection Drop Pressure
            wSol = states.wellSol;
            connDropPress = vertcat(wSol.cdp);
            
            % Compute Injector Well BHP (MODIFICAR PRIVATE FUNCTION)
%             q_sp_sc_Wat = states.wellSol(1).qWs;
            q_sp = states.wellSol(connWcS:connWcE).qWs;
            drawdown = computePerforationDrawdown(W, connInjInx, q_sp, Tw, mob, rho, rhoS);
            pwf_ref = (p - connDropPress(connWcS:connWcE)) - drawdown;
            
            % Update states struct
            states.wellSol(k).bhp = pwf_ref;
            states.wellSol(k).qWs = q_sp;
            states.wellSol(k).qOs = q_sp_sc_Oil; %% como calcular ???
            
    %         states.wellSol(k).cqs(:,1) = q_inj(:,1); usar ????
    
        elseif strcmp(states.wellSol(k).type, 'rate') % Total Rate
            %%%%%% EM DESENVOLVIMENTO %%%%%%%%%%
        end
        
    end
end

end

%% PRIVATE FUNCTIONS %%

function drawdown = getDrawdown(wSol, pBH, p)
    % Pressure drawdown (also used to determine direction of flow)
    drawdown  = -(pBH+vertcat(wSol.cdp)) + p;

end

function [Tw, isInj, connInjInx] = getWellTrans(W)
% Original function has been modified for our purposes
    Tw = W.WI;
    
    if (W.sign == 1)
        isInj = 1;
        connInjInx = 1;
    else
        isInj = 0;
        connInjInx = 0;
    end
end

function [cq_vol, cq_s] = computePerforationRates(W, connInjInx, drawdown, Tw, mob, rho, rhoS)
    compi = W.compi;

    numPh = numel(rhoS);
    anyInjPerf  = any(connInjInx);
    anyProdPerf = any(~connInjInx);

    b = rho/rhoS;

    % producing connections phase volumerates:
    if anyProdPerf
        cq_p = zeros(length(W.cells), numPh);

        conEff = ~connInjInx.*Tw;
        for ph = 1:numPh
            cq_p(:,ph) = -conEff.*mob(:,ph).*drawdown;
        end
        % producing connections phase volumerates at standard conditions:
        cq_ps = cq_p.*b;
        
        wbq = cell(1, numPh);
        for ph = 1:numPh
             wbq{ph} = - sum(cq_ps(:,ph));
        end
 
        % compute wellbore total volumetric rates at std conds.
        wbqt = 0;
        for ph = 1:numPh
            wbqt = wbqt + wbq{ph};
        end
        
        % compute wellbore mixture at std conds
        mix_s = cell(1, numPh);
        for ph = 1:numPh
            mix_s{ph} = wbq{ph}./wbqt;
        end

    else
        mix_s = cell(1, numPh);
        for i = 1:numPh
            mix_s{i} = compi(i);
        end
    end
    
    if anyInjPerf
        % Total Mobilities:
        mt = 0;
        for ph = 1:numPh
            mt = mt + mob(:,ph);
        end
        
        % Injecting connections total volume rates
        cqt_i = -(connInjInx.*Tw).*(mt.*drawdown);

        % injecting connections total volumerates at standard conditions
        cqt_is = cqt_i.*b;
    end
    
    % connection phase volumerates at standard conditions (for output):
    cq_s = cell(1,numPh);
    
    % Reservoir condition fluxes
    cq_vol = cell(1, numPh);
    for ph = 1:numPh
        if anyInjPerf && anyProdPerf
            cq_vol{ph} = connInjInx.*cqt_i.*compi(ph) + ~connInjInx.*cq_p{ph};
            cq_s{ph} = cq_ps{ph} + mix_s{ph}.*cqt_is;
        elseif anyInjPerf
            cq_vol{ph} = cqt_i.*compi(ph);
            cq_s{ph} = mix_s{ph}.*cqt_is;
        else
            cq_vol{ph} = cq_p(:,ph);
            cq_s{ph} = cq_ps(:,ph);
        end
    end
end

function [pwf_ref] = computeWellBHP(W, p, connDropPress, connInjInx, cq_s, Tw, mob, rho, rhoS)

    compi = W.compi;

    numPh = numel(rhoS);
    anyInjPerf  = any(connInjInx);
    anyProdPerf = any(~connInjInx);

    b = rho/rhoS;
    
    % producing connections phase volumerates:
    if anyProdPerf
        %%%%%%%%%%%%%%%% EM DESENVOLVIMENTO %%%%%%%%%%%%%%%%%%%%%%%%
%         cq_p = cell(1, numPh);
%         cq_p = zeros(length(W.cells), numPh);
%         cq_p = = cq_s;
        conEff = ~connInjInx.*Tw;
        for ph = 1:numPh
%             cq_p(:,ph) = -conEff.*mob(:,ph).*drawdown;
            drawdown = -conEff.*mob(:,ph)./cq_p(:,ph);
%             cq_p{ph} = -conEff.*mob{ph}.*drawdown;
        end
        % producing connections phase volumerates at standard conditions:
%         cq_ps = conn2surf(cq_p, b, dissolved, resmodel);
        cq_ps = cq_p.*b;
        
%         isInj = double(qt_s)>0;
        wbq = cell(1, numPh);
% 
        for ph = 1:numPh
%             wbq{ph} = q_s{ph}.*(q_s{ph}>0) - sum(cq_ps{ph});
%             wbq{ph} = - sum(cq_ps{ph});
             wbq{ph} = - sum(cq_ps(:,ph));
        end
% 
        % compute wellbore total volumetric rates at std conds.
        wbqt = 0;
        for ph = 1:numPh
            wbqt = wbqt + wbq{ph};
        end
        
        mix_s = cell(1, numPh);
        for ph = 1:numPh
            mix_s{ph} = wbq{ph}./wbqt;
        end

    else
        mix_s = cell(1, numPh);
        for i = 1:numPh
            mix_s{i} = compi(i);
        end
    end
    
    if anyInjPerf
        % Total Mobilities (Water + Oil):
        mt = 0;
        for ph = 1:numPh
            mt = mt + mob(:,ph);
        end
        
        % Injecting connections total volume rates
        cqt_is = cq_s;          % at standard conditions
        cqt_i = cqt_is/b(1);    % at reservoir conditions (water injection)

        soma = 0;
        for k = 1:numel(W.cells)
            soma = soma + (Tw(k)*mt(k)*(p(k) - connDropPress(k)));
        end
        pwf_ref = (soma + cqt_i)/sum(Tw.*mt);
    end
end
