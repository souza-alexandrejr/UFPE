function dx = Derivada(x,y)
% calcula a derivada de uma função para um conjunto de dados igualmente
% espaçados. usando diferenças: 
%  progressivas na extremidade esquerda
%  centradas nos pontos interiores
%  regressivas na extremidade direita

% Input:
% x  vetor com as coordenadas de x.
% y  vetor com as coordenadas de y
% Output:
% dx  vetor com o valor da derivada em cada ponto

n = length(x);
dx(1)=(y(2)-y(1))/(x(2)-x(1));  %progressiva

for i=2:n-1
    dx(i)=(y(i+1)-y(i-1))/(x(i+1)-x(i-1));  %centrada
end  
dx(n)=(y(n)-y(n-1))/(x(n)-x(n-1));  %regressiva


%Graficos
subplot(2,1,1)
plot(x,y,'.-k')
xlabel('x'); ylabel('f(x)');

subplot(2,1,2)
plot(x,dx,'.-r')
xlabel('x'); ylabel('df(x)');

end
