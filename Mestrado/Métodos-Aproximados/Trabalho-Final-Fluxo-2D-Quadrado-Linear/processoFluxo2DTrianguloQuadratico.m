%% - PRE-PROCESSO: FLUXO DE AGUA EM MEIO POROSO SATURADO - %%
% -------- SOLUCAO VIA MEF-GALERKIN: ELEMENTO 2D --------- %%
% ---------------- TRIANGULO QUADRATICO ------------------- %
% ---------- Aplicacao de Integracao Numerica ------------- %

disp('FLUXO2D')
disp('PROGRAMA MEF PARA FLUXO DE AGUA EM MEIO POROSO SATURADO')

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

M = zeros(nn,nn);
F = zeros(nn,1);
    
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

                % Matriz do elemento:     
                ke(i,j) = ke(i,j) + gradN(:,i)'*k*gradN(:,j)*det(J)*w(pg);

            end
        end
        % Vetor do elemento:
        Ne = N(ksi(pg),eta(pg));
        fe(i) = fe(i) + Ne(i)*r(e)*det(J);
    end
    
    % Montando Matriz e Vetor GLOBAL
    for i = 1:size(lnods,2)
        for j = 1:size(lnods,2)
            if j >= i
                M(ng(i),ng(j)) = M(ng(i),ng(j)) + ke(i,j);
            else
                M(ng(i),ng(j)) = M(ng(j),ng(i));
            end
        end
        F(ng(i)) = F(ng(i)) + fe(i);
    end 
end

% Aplicando as condicoes de contorno:
for i = 1:nn
   M(i,i) = M(i,i) + gamma(i);
   F(i) = F(i) + q0(i) + gamma(i)*h0(i);
end

% Resolvendo o sistema:
h = M\F;

% Calculando as vazoes nodais equivalentes:
q = zeros(nn,1);
for i = 1:nn
   q(i) = q0(i) + gamma(i)*(h0(i)-h(i));
end
