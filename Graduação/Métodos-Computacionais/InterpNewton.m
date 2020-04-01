function yint = InterpNewton(x,y,xx)
% Polinomio interpolador de Newton
% yint = Newtint(x,y,xx): Utiliza um polinomio interpolador de Newton 
%   de grau (n - 1) a partir de n pontos (x, y), para determinar
%   para determinar um valor da variavel dependente (yint)
%   em um dado valor da variavel independente, xx.
%
% Dados de entrada:
%   x = variavel independente
%   y = variavel dependente
%   xx = valor da variavel independente na qual a interpolacao é calculada
% Dados de saída:
%   yint = valor interpolado da variavel dependente

% Calcula as diferenças divididas finitas na forma de uma tabela de
% diferenças divididas (armazenadas na matriz b)

n = length(x);
if length(y)~=n, error('x e y devem ter o mesmo tamanho'); end

% inicializa a matriz b 
b = zeros(n,n);  

% atribui as variaveis dependentes à primeira coluna de b
b(:,1) = y(:); % o (:) garante que y é um vetor coluna.

for j = 2:n
  for i = 1:n-j+1
    b(i,j) = (b(i+1,j-1)-b(i,j-1))/(x(i+j-1)-x(i));
  end
end

% usa as diferenças divididas finitas para interpolar 
xt = 1;
yint = b(1,1);
for j = 1:n-1
  xt = xt*(xx-x(j));
  yint = yint+b(1,j+1)*xt;
end

save('Ch17_xi_3a6')
