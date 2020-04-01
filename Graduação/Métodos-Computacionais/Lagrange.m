function yint = Lagrange(x,y,xx)
% Lagrange: Polinomio Interpolador de Lagrange
%   yint = Lagrange(x,y,xx): UUtiliza um polinomio interpolador de Newton 
%   de grau (n - 1) a partir de n pontos (x, y), para determinar
%   para determinar um valor da variavel dependente (yint)
%   em um dado valor da variavel independente, xx.
%
% Dados de entrada:
%   x = variavel independente
%   y = variavel dependente
%   xx = valor da variavel independente na qual a interpolacao é calculada
% Dados de saída:
%   yint = valor interpolado da variável independente
%
n = length(x);
if length(y)~=n, error('x e y devem ter o mesmo tamanho'); end

s = 0;
for i = 1:n
  produto = y(i);
  for j = 1:n
    if i ~= j
      produto = produto*(xx-x(j))/(x(i)-x(j));
    end
  end
  s = s+produto;
end
yint = s;

end