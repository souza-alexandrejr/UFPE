function y2d = SegDeriv(x,y)
% Calcula a segunda derivada para dados igualmente espaçados

n = length(x); 
h = x(2)-x(1);

% Pontos internos
for i = 2:n-1
 y2d(i) = (y(i-1)-2*y(i)+y(i+1))/(h^2);
end

% Extremidades
% segunda derivada para a primeira extremidade (progressiva com 4 pontos)
y2d(1) = (2*y(1)-5*y(2)+4*y(3)-y(4))/(h^2);

% segunda derivada para a segunda extremidade (regressiva com 4 pontos)
y2d(n) = (-y(n-3)+4*y(n-2)-5*y(n-1)+2*y(n))/(h^2);

end