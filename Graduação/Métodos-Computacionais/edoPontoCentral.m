function [x, y] = edoPontoCentral(EDO,a,b,h,yINI)
% edoPontoCentral resolve uma EDO de primeira ordem usando o metodo do
% ponto central

% Input:
% EDO, nome da função (string) de um arquivo-M com a derivada da função.
% a: primeiro valor do domínio x.
% b: último valor do domínio.
% h tamanho do passo de integração.
% yINI valor inicial de y

% Output:
% x vetor com as coordenadas de x
% y vetor solução com os valores de y

x(1) = a; y(1) = yINI;
N = (b-a)/h;

for i = 1:N   
 x(i+1) = x(i) + h;
 Incl1 = feval(EDO,x(i),y(i));  %Inclinação no início do intervalo
 
 xm=x(i)+h/2;
 ym=y(i)+Incl1*h/2;
 
 Incl2 = feval(EDO,xm,ym);      %Inclinação no ponto central do intervalo
 y(i+1) = y(i) + Incl2*h;
 
end



% 
% for i = 1:N   
%  x(i+1) = x(i) + h;
%  Incl1 = feval(EDO,x(i),y(i));            %Inclinação no início do intervalo
%  Incl2 = feval(EDO,x(i)+h/2,y(i)+K1*h/2); %Inclinação no ponto central do intervalo
%  y(i+1) = y(i) + Incl2*h;
% end