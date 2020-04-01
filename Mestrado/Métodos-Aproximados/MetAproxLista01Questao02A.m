% Questao 02 da Lista 01 de Exercicios
% ------- Metodos Aproximados -------%
% -----------------------------------%

L = 4;                  % numero de intervalos
dx = 1/L;               % tamanho do intervalo

fi0 = ones(L-1,1);      % vetor inicial
b = zeros(L-1,1);       % vetor dos termos independentes
A = zeros(L-1,L-1);     % matriz dos coeficientes

% Montagem da Matriz A e do Vetor b
for i = 1:L-1
    A(i,i) = -2;
    b(i) = dx^2*exp(fi0(i)); % rhs = 1
end

A(1,2) = 1; A(2,1) = 1;
A(2,3) = 1; A(3,2) = 1;

disp(A)
disp(b)

fi0 = A\b;
disp(fi0)

tol = 1;
while tol > 1e-3
    b(:) = dx^2.*exp(fi0(:));
    fi = A\b;
    tol = max(abs((fi(:)-fi0(:))./fi(:)));
    fi0 = fi;  
end

disp(fi)



