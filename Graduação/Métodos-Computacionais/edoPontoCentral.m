function [x, y] = edoPontoCentral(EDO,a,b,h,yINI)
% edoPontoCentral resolve uma EDO de primeira ordem usando o metodo do
% ponto central

% Input:
% EDO, nome da fun��o (string) de um arquivo-M com a derivada da fun��o.
% a: primeiro valor do dom�nio x.
% b: �ltimo valor do dom�nio.
% h tamanho do passo de integra��o.
% yINI valor inicial de y

% Output:
% x vetor com as coordenadas de x
% y vetor solu��o com os valores de y

x(1) = a; y(1) = yINI;
N = (b-a)/h;

for i = 1:N   
 x(i+1) = x(i) + h;
 Incl1 = feval(EDO,x(i),y(i));  %Inclina��o no in�cio do intervalo
 
 xm=x(i)+h/2;
 ym=y(i)+Incl1*h/2;
 
 Incl2 = feval(EDO,xm,ym);      %Inclina��o no ponto central do intervalo
 y(i+1) = y(i) + Incl2*h;
 
end



% 
% for i = 1:N   
%  x(i+1) = x(i) + h;
%  Incl1 = feval(EDO,x(i),y(i));            %Inclina��o no in�cio do intervalo
%  Incl2 = feval(EDO,x(i)+h/2,y(i)+K1*h/2); %Inclina��o no ponto central do intervalo
%  y(i+1) = y(i) + Incl2*h;
% end