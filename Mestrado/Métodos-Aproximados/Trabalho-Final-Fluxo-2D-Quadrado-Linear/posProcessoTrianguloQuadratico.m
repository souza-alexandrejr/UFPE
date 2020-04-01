%% - POS-PROCESSO: FLUXO DE AGUA EM MEIO POROSO SATURADO - %%
% -------- SOLUCAO VIA MEF-GALERKIN: ELEMENTO 2D --------- %%
% ---------------- TRIANGULO QUADRATICO ------------------- %
% ---------- Aplicacao de Integracao Numerica ------------- %

% ESCREVENDO RESULTADOS (tela do MATLAB):
disp('Cargas hidraulicas nodais (m): ')
for i = 1:nn
  disp(['no: ', num2str(i),'      h = ', num2str(h(i))])
end

disp('Vazoes nodais (m3/s): ')
for i=1:nn
  disp(['no: ', num2str(i),'      q = ', num2str(q(i))])
end

pause

% PLOTANDO RESULTADOS:
% Monta "grid" retangular para gráficos de superfície (surf) e curva de nível (contour):
dx = (max(coords(:,1))-min(coords(:,1)))/100;
x = min(coords(:,1)):dx:max(coords(:,1));
dy = (max(coords(:,2))-min(coords(:,2)))/100;
y = min(coords(:,2)):dy:max(coords(:,2));
[X,Y] = meshgrid(x,y);
Z = griddata(coords(:,1),coords(:,2),h(:),X,Y);

escolha = 0;
while (escolha ~= 7)
   escolha = menu('Faça a opcao do tipo de saida grafica:',...
    'MALHA DE ELEMENTOS FINITOS', ...
    'CARGAS HIDRAULICAS: ELEMENTOS COLORIDOS', ...
    'CARGAS HIDRAULICAS: SUPERFICIE', ...
    'CARGAS HIDRAULICAS: CURVAS DE NIVEL', ...
    'FLUXO DE DARCY',...
    'GRADIENTE HIDRAULICO',...
    'FIM');

if (escolha == 1) 
   
% MALHA DE ELEMENTOS FINITOS:
figure
axis equal;
hold on
for i = 1:nel
  clear x y;
  for j = 1:size(lnods, 2)
    x(j) = coords(lnods(i,j),1); 
    y(j) = coords(lnods(i,j),2);
  end
  text(mean(x),mean(y),num2str(i));
  plot([x x(1)],[y y(1)],'g');
end
title('Malha de Elementos Finitos');
xlabel('x');
ylabel('y');
pause
close   
end   

if (escolha == 2) 
   
% ELEMENTOS COLORIDOS:

figure
axis equal;
Hmax = max(h);
Hmin = min(h);
Hsum = 0;
no = zeros(size(lnods,2),1);

for i = 1:nel
    for j = 1:size(lnods,2)
        no(j) = lnods(i,j);
        Hsum = Hsum + h(no(j));
    end
    Hmed = Hsum/size(lnods,2);
    cor = (62*Hmed-59*Hmin-3*Hmax)/(Hmax-Hmin);
    for j = 1:size(lnods,2)
        xp = coords(no(1:size(lnods,2)),1);
        yp = coords(no(1:size(lnods,2)),2);
        patch(xp, yp, cor);
    end
end
title('Iso Cargas Hidráulicas');
xlabel('x');
ylabel('y');
pause
close
end

if (escolha == 3) 
   
% SUPERFICIE:

figure
axis equal;
surf(X,Y,Z);
shading interp;                       
colormap(jet);                       
title('Iso Cargas Hidraulicas');
xlabel('x');
ylabel('y');
zlabel('carga hidraulica');
pause
close
   
end

if (escolha == 4) 
   
% CURVAS DE NIVEL:

figure
axis equal;
[cc,hh] = contour(X,Y,Z);
clabel(cc,hh)
shading interp;                       
colormap(jet);                       
title('Iso cargas hidráulicas');
xlabel('x');
ylabel('y');
pause
close
end

if (escolha == 5)
   
% FLUXO DE DARCY:

figure
axis equal;

% Considera contribuicoes de cada elemento na matriz e vetor globais
% Monta Matriz e Vetor do Elemento (LOCAL):
% Quadratura de Radau (Onaite, Tabela 8.2)
ksi = [1/2, 1/2, 0];
eta = [0, 1/2, 1/2];
w = [1/6, 1/6, 1/6];

% nos locais do elemento
ng = zeros(size(lnods,2),1);
% coordenadas dos nos locais
x = zeros(size(lnods,2),1);
y = zeros(size(lnods,2),1);
% coordenadas do centroide do elemento
xe = zeros(1,nel);
ye = zeros(1,nel);
% fluxo de Darcy
qw = zeros(2,nPG);

for e = 1:nel
    % Permeabilidade na direcao principal
    D = [k1(e), 0; 0, k2(e)];
    % Matriz de rotacao
    R = [cos(alfa(e)), -sin(alfa(e));
         sin(alfa(e)), cos(alfa(e))];
    % Rotacao para x e y
    k = R'*D*R;

    for j = 1:size(lnods,2)
        ng(j) = lnods(e,j);
        x(j) = coords(ng(j),1);
        y(j) = coords(ng(j),2);
    end
    
    Ae = ((y(3)-y(1))*(x(1)+x(3)) + (y(5)-y(3))*(x(3)+x(5)) + ...
         + (y(1)-y(5))*(x(5)+x(1)))/2;  
    Qx =((y(3)-y(1))*(x(1)^2+x(1)*(x(3)-x(1))+(x(3)-x(1))^2/3) ...                        
        +(y(5)-y(3))*(x(5)^2+x(5)*(x(5)-x(3))+(x(5)-x(3))^2/3) ...
        +(y(1)-y(5))*(x(5)^2+x(5)*(x(1)-x(5))+(x(1)-x(5))^2/3))/2;
    Qy = -((x(3)-x(1))*(y(1)^2+y(1)*(y(3)-y(1))+(y(3)-y(1))^2/3) ...                       
          +(x(5)-x(3))*(y(5)^2+y(5)*(y(5)-y(3))+(y(5)-y(3))^2/3) ...
          +(x(1)-x(5))*(y(5)^2+y(5)*(y(1)-y(5))+(y(1)-y(5))^2/3))/2;

    xe(e) = Qx/Ae; 
    ye(e) = Qy/Ae;

    patch([x(1) x(3) x(5)],[y(1) y(3) y(5)],'w');
    
    ke = zeros(size(lnods,2),size(lnods,2));
    fe = zeros(size(lnods,2),1);
           
    % Numero de Pontos de Gauss:
    nPG = 3;
    for i = 1:6
        for j = 1:6
            for pg = 1:nPG
                dNdksi = dN_dksi(ksi(pg),eta(pg));
                dNdeta = dN_deta(ksi(pg),eta(pg));

                dX_dksi = dNdksi*x;
                dX_deta = dNdeta*x;
                dY_dksi = dNdksi*y;
                dY_deta = dNdeta*y;

                J = [dX_dksi, dY_dksi; dX_deta, dY_deta];

                % Matriz das derivadas de N em relacao a X e Y em funcao de ksi e eta
                gradN = J\[dN_dksi(ksi(pg),eta(pg)); dN_deta(ksi(pg),eta(pg))]; 
            end
        end
    end
              
    qw(:,e) = -k*gradN*[h(ng(1)) h(ng(2)) h(ng(3)) h(ng(4)) h(ng(5)) h(ng(6))]';

end

hold on
quiver(xe, ye, qw(1,:), qw(2,:)); 
title('Vetores de Fluxo');
xlabel('x');
ylabel('y');
pause
close

end

if (escolha == 6)
   
% GRADIENTE HIDRAULICO:
   
figure
axis equal;

% Considera contribuicoes de cada elemento na matriz e vetor globais
% Monta Matriz e Vetor do Elemento (LOCAL):
% Quadratura de Radau (Onaite, Tabela 8.2)
ksi = [1/2, 1/2, 0];
eta = [0, 1/2, 1/2];
w = [1/6, 1/6, 1/6];

% nos locais do elemento
ng = zeros(size(lnods,2),1);
% coordenadas dos nos locais
x = zeros(size(lnods,2),1);
y = zeros(size(lnods,2),1);
% coordenadas do centroide do elemento
xe = zeros(1,nel);
ye = zeros(1,nel);
% gradiente hidraulico
gradH = zeros(2,nPG);

for e = 1:nel
    % Permeabilidade na direcao principal
    D = [k1(e), 0; 0, k2(e)];
    % Matriz de rotacao
    R = [cos(alfa(e)), -sin(alfa(e));
         sin(alfa(e)), cos(alfa(e))];
    % Rotacao para x e y
    k = R'*D*R;

    for j = 1:size(lnods,2)
        ng(j) = lnods(e,j);
        x(j) = coords(ng(j),1);
        y(j) = coords(ng(j),2);
    end

    Ae = ((y(3)-y(1))*(x(1)+x(3)) + (y(5)-y(3))*(x(3)+x(5)) + ...
         + (y(1)-y(5))*(x(5)+x(1)))/2;  
    Qx =((y(3)-y(1))*(x(1)^2+x(1)*(x(3)-x(1))+(x(3)-x(1))^2/3) ...                        
        +(y(5)-y(3))*(x(5)^2+x(5)*(x(5)-x(3))+(x(5)-x(3))^2/3) ...
        +(y(1)-y(5))*(x(5)^2+x(5)*(x(1)-x(5))+(x(1)-x(5))^2/3))/2;
    Qy = -((x(3)-x(1))*(y(1)^2+y(1)*(y(3)-y(1))+(y(3)-y(1))^2/3) ...                       
          +(x(5)-x(3))*(y(5)^2+y(5)*(y(5)-y(3))+(y(5)-y(3))^2/3) ...
          +(x(1)-x(5))*(y(5)^2+y(5)*(y(1)-y(5))+(y(1)-y(5))^2/3))/2;

    xe(e) = Qx/Ae; 
    ye(e) = Qy/Ae;
    
    patch([x(1) x(3) x(5)],[y(1) y(3) y(5)],'w');
    
    ke = zeros(size(lnods,2),size(lnods,2));
    fe = zeros(size(lnods,2),1);
           
    % Numero de Pontos de Gauss:
    nPG = 3;
    for i = 1:6
        for j = 1:6
            for pg = 1:nPG
                dNdksi = dN_dksi(ksi(pg),eta(pg));
                dNdeta = dN_deta(ksi(pg),eta(pg));

                dX_dksi = dNdksi*x;
                dX_deta = dNdeta*x;
                dY_dksi = dNdksi*y;
                dY_deta = dNdeta*y;

                J = [dX_dksi, dY_dksi; dX_deta, dY_deta];

        % Matriz das derivadas de N em relacao a X e Y em funcao de ksi e eta
        gradN = J\[dN_dksi(ksi(pg),eta(pg)); dN_deta(ksi(pg),eta(pg))]; 
            end
        end
    end
    
    gradH(:,e) = gradN*[h(ng(1)) h(ng(2)) h(ng(3)) h(ng(4)) h(ng(5)) h(ng(6))]'; 
    
end

hold on
quiver(xe, ye, gradH(1,:), gradH(2,:)); 
title('Vetores de Gradiente Hidraulico');
xlabel('x');
ylabel('y');
pause
close

end

end