function [P] = TRIDIA(N,A,B,C,D)
% A rotina usa Elimina��o de Gauss para solu��o
% de um sistema de equa��es do tipo:
% ------------------------------------------------
% A(i)*P(i-1) + B(i)*P(i) + C(i)*P(i+1) = D(i)
% ------------------------------------------------
% Dados de entrada:
% A(i), B(i), C(i), D(i) = matriz dos coeficientes
% P = Press�o
% N = n�mero de equa��es
% ------------------------------------------------

BB = zeros(N,1);
DD = zeros(N,1);

BB(1) = B(1);
DD(1) = D(1);

for i = 2:N
    X = A(i)/BB(i-1);
    BB(i) = B(i) - X*C(i-1);
    DD(i) = D(i) - X*DD(i-1);
end

P(N) = DD(N)/BB(N);

for k = 2:N
    i = N-k+1;
    P(i) = (DD(i) - C(i)*P(i+1))/BB(i);
end

end

