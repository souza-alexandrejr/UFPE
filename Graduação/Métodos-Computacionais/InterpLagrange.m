function yInt = InterpLagrange(x,y,xInt)
% intLagr acha o um valor interpolado de y(xInt)=yInt pelas fun��es de
% Lagrange. Pelo ajuste de um polinomio dos pontos de coordenadas P=(x,y)
% Vari�veis:
% x: abcissa dos pontos
% y: ordenada dos pontos
% xInt: abcissa do ponto a ser interpolado
% yInt: ordenada do ponto interpolado

% n: n�mero de pontos a interpolar
n = length(x);

% Calculo das fun��es de Lagrange
for i=1:n
    prod = 1;
    for j=1:n
        if j~=i
            prod = prod*(xInt-x(j))/(x(i)-x(j));
        end
    end
    L(i) = prod;
end

fprintf('\nCoeficientes de Lagrange:')
disp(L)

% Calculo do valor interpolado
yInt = sum(y.*L);

fprintf('\n f(%d) = %d',xInt,yInt);

end

