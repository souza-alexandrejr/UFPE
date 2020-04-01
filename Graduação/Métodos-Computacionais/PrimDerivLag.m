function dy = PrimDerivLag(x,y)
% Calcula a primeira derivada para dados desigualmente espaçados.
% x=[-1 -0.6 -0.3 0 0.5 0.8 1.6 2.5 2.8 3.2 3.5 4];
% y=[-3.632 -0.8912 0.3808 1.0 0.6487 -0.3345 -5.287 -12.82 -14.92 -16.43 -15.88 -9.402];

% x: vetor da variável independente
% y: vetor da variável dependente

n = length(x);

% indice 1: xi , indice 2: xi+1, indice n: xi+2

% No primeiro ponto:
dy(1) = y(1) * ((2*x(1) - x(2) -x(3)) / ( (x(1) - x(2)) *( x(1) - x(3)) )) ...
+ y(2) *( (2*x(1) - x(1) -x(3))) / ( (x(2) - x(1))*(x(2) - x(3) ) ) ...
+ y(3) * ((2*x(1) - x(1) -x(2)) / ( (x(3) - x(1))*(x(3) - x(2)) ));
     
% Nos pontos intermediários, use a equação com x=xj e x2=j x1=j-1 x3=j+1
for j = 2:n-1
    
dy(j) = y(j-1) * ( (2*x(j) - x(j) -x(j+1)) ) / ( (x(j-1) - x(j))*(x(j-1) - x(j+1) ) ) ...
+y(j) * ( (2*x(j) - x(j-1) -x(j+1)) ) / ( (x(j) - x(j-1))*(x(j) - x(j+1)) ) ...       
+y(j+1) * ( (2*x(j) - x(j-1) -x(j)) ) / ( (x(j+1) - x(j-1))*(x(j+1) - x(j)) );
end
     
% No último ponto, use a equação com x=xn e x(3)=n x(2)=n-1 x(1)=n-2
dy(n) = y(n-2) * (2*x(n) - x(n-1) -x(n)) / ( (x(n-2) - x(n-1))*(x(n-2) - x(n)) )...
     +y(n-1) * (2*x(n) - x(n-2) -x(n)) / ( (x(n-1) - x(n-2))*(x(n-1) - x(n)) )...     
    +y(n) * (2*x(n) - x(n-2) -x(n-1)) / ( (x(n) - x(n-2))*(x(n) - x(n-1)) );

end





