% --- PLOTAGEM DOS DADOS DO EXCEL --- %

nx = 10;                    % N�mero de divis�es em X
ny = 1;                     % N�mero de divis�es em Y
Lx = 1.0*meter;             % Comprimento total em X
Ly = 1200*meter;            % Comprimento total em Y

% Criando um grid cartesiano
G = cartGrid([nx, ny], [Lx, Ly]);
G = computeGeometry(G);

t=2.5;
dtime = 2.5;
tmax = 400;

matrizSW = matrizSW';
matrizPO = matrizPO';

while t < tmax
    
    % Satura��o
    figure();
    heading = [num2str(t),  'segundos'];
    plotCellData(G, matrizSW(:,1)); colormap('jet');
    c = colorbar; c.Label.String = 'Water Saturation [-]';
    title(heading);
    print('-dtiff','-r110',['saturacao@',heading,'.tiff'])
    
    % Press�o
    figure();
    plotCellData(G, matrizPO(:,1)); colormap('jet');
    c = colorbar; c.Label.String = 'Pressao [atm]';
    title(heading);
    print('-dtiff','-r110',['pressao@',heading,'.tiff'])
 
    t = t + dtime; 
end

