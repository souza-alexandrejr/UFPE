% SIMULA��O DE FLUXO BIF�SICO �LEO/�GUA (MRST)
% ------------------------------------------ %

clc; clear, close all;

%% DADOS DE ENTRADA

nx = 10;                    % N�mero de divis�es em X
ny = 1;                     % N�mero de divis�es em Y
Lx = 1.0*meter;             % Comprimento total em X
Ly = 1200*meter;            % Comprimento total em Y

% Propriedades da Rocha

porosidade = 0.25;  % todos iguais
% porosidade = [...]; % todos diferentes (heterogeneo)
permeabilidade = 0.1*darcy;  % todos iguais
% permeabilidade = [...]; % todos diferentes (heterogeneo)

% Condi��es Iniciais
% Satura��o da �gua
sw0  = 0.2;
% Press�o em atm
p0  = 200;

% passo de tempo 
dtime  = 2.5*second;
tmax   = 400*second; 
nprint = 10;        % plotagem a cada 10 itera��es

% Condi��es de Contorno
% Tipos: true = Dirichlet; false = Neumman
%        [esquerda, direita]
tipoCC = [false, true];
pCC    = [p0   , 200]*atm;
qCC    = [25.  ,25.]*centi*meter.^3/second;


% Propriedades dos Fluidos
%        [�gua, �leo]
visco =  [ 1.,  0.5]*centi*poise;
dens  =  [ 1.,  0.8].*1000*kilogram/meter^3;
n_kr  =  [  2,   2];    % fator exponencial dos kr's
satr  =  [ .2,  .2]; 	% satura��es residuais
fac_A =  [  1,  1];     % fator multiplicador da kr

%% INICIALIZA��O
% Criando um grid cartesiano

G = cartGrid([nx, ny], [Lx, Ly]);
G = computeGeometry(G);

% plotando grid
% figure()
% plotGrid(G);
% hold on
% plota vetores normais das faces das celulas
% quiver(G.faces.centroids(:,1),G.faces.centroids(:,2), ...
%        G.faces.normals(:,1),G.faces.normals(:,2))
% hold off

% Criando estrutura rock
rock = makeRock(G, permeabilidade, porosidade);

% % plota distribui��o da porosidade e permeabilidade
% figure()
% subplot(2,1,1);
% plotCellData(G, rock.poro)
% title('porosidade'); colorbar;
% 
% subplot(2,1,2);
% plotCellData(G, rock.perm(:,1))
% title('permeabilidade'); colorbar;

% Criando estrutura do Reservat�rio
res = initState(G, [], p0*atm, [sw0, 1-sw0]);

% Aplicando as Condi��es de Contorno
% Lado Esquerdo
if (tipoCC(1))
    bc = pside   ([], G, 'left', pCC(1), 'sat', [1-satr(1), satr(2)]);
else
    bc = fluxside([], G, 'left', qCC(1), 'sat', [1-satr(1), satr(2)]);
end
% Lado Direito
if (tipoCC(2))
    bc = pside   (bc, G, 'right', pCC(2), 'sat', [sw0, 1-sw0]);
else
    bc = fluxside(bc, G, 'right', qCC(2), 'sat', [sw0, 1-sw0]);
end

% Adicionando m�dulo do MRST <incomp>
mrstModule add incomp

% Propriedades dos Fluidos
fluid = initCoreyFluid('mu' , visco, ...
                       'rho', dens, ...
                       'n'  , n_kr, ...
                       'sr' , satr, ...
                       'kwm', fac_A);
                   
% Plotando a Curva de Permeabilidade Relativa
figure()
s = linspace(satr(1),1-satr(2),20)'; kr=fluid.relperm(s);
plot(s, kr(:,1), 'b', s, kr(:,2), 'r', 'LineWidth',2);
title('Relative permeability curves')
xlabel('Saturation, s'); ylabel('Relative permeability, rk')
legend('Water','Oil','Location','Best')

% Solu��o para Equa��o da Press�o
T   = computeTrans(G, rock);
sol = incompTPFA(res, G, T, fluid, 'bc', bc);

%% SA�DA DAS PRESS�ES

clf;
plotCellData(G, convertTo(sol.pressure, atm()));
title('pressao inicial'), colormap('jet'), 
c = colorbar; c.Label.String = 'Pressure [atm]';
axis off

t = 0; plotNo = 0; n = 0;

while t < tmax
    sol  = explicitTransport(sol, G, dtime, rock, fluid, 'bc', bc, 'computedt', false);

    % Verifica��o de inconsist�ncia nas satura��es
    s = sol.s(:,1);
    assert(max(s) < 1+eps && min(s) > -eps);

    % Atualizando as press�es
    sol  = incompTPFA(sol, G, T, fluid, 'bc', bc);

    t = t + dtime; 
    n = n + 1;
    
    fprintf('Time step %3d done. Time: %10.4f, time step size: %10.4f\n',...
        n, t,dtime);
   
    % ----< write results  >-----
    if or(mod(n, nprint)== 0,t==tmax)
        plotNo = plotNo+1;
        
        % Plotando as Press�es e Satura��es
        figure();
        heading = [num2str(t),  'segundos'];
        plotCellData(G, sol.s(:,1)); colormap('jet');
        c = colorbar; c.Label.String = 'Water Saturation [-]';
        title(heading);
        print('-dtiff','-r110',['saturacao@',heading,'.tiff'])
        

        figure();
        plotCellData(G, convertTo(sol.pressure(:,1), atm())); colormap('jet');
        c = colorbar; c.Label.String = 'Pressao [atm]';
        title(heading);
        print('-dtiff','-r110',['pressao@',heading,'.tiff'])
    end
end
fprintf('\n\nNumber of iteration   : %d\n', n);
disp('End execution.');

% close all;
