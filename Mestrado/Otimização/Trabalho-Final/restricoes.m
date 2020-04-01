function [c,ceq,GC,GCeq] = restricoes(x)
% restricoes nao-lineares c(x) <= 0 e ceq(x) = 0
% e seus respectivos gradientes

alfa = 1; % razão entre altura do pilar e vão da viga
q = 15; % carregamento uniformemente distribuída
L = 550; % comprimento do vão da viga (cm)
sigadm = 130; % tensao admissivel

x = initVariablesADI(x);
g1 = 0.5*q*L./(x(1).^2) + (q*L^2./(12+8*alfa*x(2).^4./x(1).^4))./(x(1).^3./6) - sigadm;
g2 = q*L^2./(12+8*alfa*x(2).^4./x(1).^4)./(alfa*L)./(x(2).^2) + ... 
         q*L^2./(12+8*alfa*x(2).^4./x(1).^4)./(x(2).^3./6) - sigadm;
g3 = (q*L^2./(12+8*alfa*x(2).^4./x(1).^4))./(alfa*L)./(x(2).^2) + ...
    (q*L^2./8 - q*L^2./(12+8*alfa*x(2).^4./x(1).^4))./(x(2).^3./6) - sigadm;

g = [g1; g2; g3];
c = g.val;
ceq = [];

if nargout > 2 % caso o gradiente seja solicitado
      GC = full(g.jac{1}'); % full -> transformar para double
      GCeq = [];
end

end

