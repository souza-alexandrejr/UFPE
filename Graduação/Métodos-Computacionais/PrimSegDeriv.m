function [yd,y2d] = PrimSegDeriv(x,y)
% Calcula aproximaçoes da primeira e segunda derivadas 
% com erro de truncamento de segunda ordem

n = length(x);
h = x(2)-x(1);

% Pontos interiores: Diferenças Centradas
for i = 2:n-1
 yd(i) = (y(i+1)-y(i-1))/(2*h);         %Primeira Derivada 
 y2d(i) = (y(i-1)-2*y(i)+y(i+1))/(h^2); %Segunda Derivada
end

% Extremidades
% Primeira Derivada
yd(1) = (-3*y(1)+4*y(2)-y(3))/(2*h);
yd(n) = (y(n-2)-4*y(n-1)+3*y(n))/(2*h);

% Segunda Derivada
y2d(1) = (2*y(1)-5*y(2)+4*y(3)-y(4))/(h^2);         % progressiva
y2d(n) = (-y(n-3)+4*y(n-2)-5*y(n-1)+2*y(n))/(h^2);  % regressiva

% Graficos
subplot(3,1,1)
plot(x,y,'.-k')
xlabel('x'); ylabel('f(x)');

subplot(3,1,2)
plot(x,yd,'.-')
xlabel('x'); ylabel('df/dx');

subplot(3,1,3)
plot(x,y2d,'.-r')
xlabel('x'); ylabel('d2f/dx2');
