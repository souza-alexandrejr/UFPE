function x = EliminacaoDeGauss(A,B)
% Metodo de Gauss
% A -> Matriz dos coeficientes
% B -> Vetor dos termos independentes

% Concatena-se A e B
ab = [A, B];
[L,C] = size(ab);
m = zeros(L, C);

% Eliminação de variáveis
for i = 1:L - 1
    for j = i + 1:L
        m(j,i) = ab(j,i) / ab(i,i);
        for k = 1:C
            ab(j,k) = ab(j,k) - ab(i,k) * m(j,i);
        end
    end
end  

disp(ab)

% Substituição Regressiva
x = zeros(L,1);

x(L) = ab(L,C)/ab(L,L);
for i = L-1:1
    x(i) = (ab(i,C)-ab(i,i+1:L)*x(i+1:L))/ab(i,i);
end
