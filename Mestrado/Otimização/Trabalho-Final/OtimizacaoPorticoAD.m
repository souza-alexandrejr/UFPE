%% Otimização do Pórtico 2D usando AD (Derivação Automática)

alfa = 1; %razão entre altura do pilar e vão da viga
q = 15; % carregamento uniformemente distribuída
L = 550; % comprimento do vão da viga (cm)
sigadm = 130; % tensao admissivel

[x0,incr] = deal([7;30]);
u0 = [100;100];
tol = 1e-6;

% conjunto ativo: g1 e g3
while norm(incr) > tol
    x23 = initVariablesADI(x0);
    u13 = initVariablesADI(u0);
    fx = 2*alfa*L*x23(1).^2 + L*x23(2).^2;
    g1 = 0.5*q*L./(x23(1).^2) + (q*L^2./(12+8*alfa*x23(2).^4./x23(1).^4))./(x23(1).^3./6) - sigadm;
    g3 = (q*L^2./(12+8*alfa*x23(2).^4./x23(1).^4))./(alfa*L)./(x23(2).^2) + ...
    (q*L^2./8 - q*L^2./(12+8*alfa*x23(2).^4./x23(1).^4))./(x23(2).^3./6) - sigadm;
    g13 = cat(g1,g3);
    incr = -g13.jac{1}\g13.val;
    x0 = x0 + incr;
    dlag13dx1 = fx.jac{1}(1) + u13(1)*g1.jac{1}(1) + u13(2)*g3.jac{1}(1);
    dlag13dx2 = fx.jac{1}(2) + u13(1)*g1.jac{1}(2) + u13(2)*g3.jac{1}(2);
    dlag13 = cat(dlag13dx1,dlag13dx2);
    incr2 = -dlag13.jac{1}\dlag13.val;
    u0 = u0 + incr2;
    fprintf('x1_13: %.3f cm x2_13: %.3f cm Volume(x1_13,x2_13): %.3f cm³\n',x23(1),x23(2),fx);
    fprintf('u1: %.3f u3: %.3f\n',u13(1),u13(2));
end

if u13(1)<0 || u13(2)<0
    fprintf('Multiplicador de Lagrange negativo!!!\n');
else
    fprintf('Os Multiplicadores de Lagrange sao positivos!!!\n\n');
end

% reinicializando vetores iniciais
[x0,incr] = deal([25;25]);
[u0,incr2] = deal([100;100]);

% conjunto ativo: g2 e g3
while norm(incr) > tol
    x23 = initVariablesADI(x0);
    u23 = initVariablesADI(u0);
    fx = 2*alfa*L*x23(1).^2 + L*x23(2).^2;
    g2 = q*L^2./(12+8*alfa*x23(2).^4./x23(1).^4)./(alfa*L)./(x23(2).^2) + ... 
         q*L^2./(12+8*alfa*x23(2).^4./x23(1).^4)./(x23(2).^3./6) - sigadm;
    g3 = (q*L^2./(12+8*alfa*x23(2).^4./x23(1).^4))./(alfa*L)./(x23(2).^2) + ...
    (q*L^2./8 - q*L^2./(12+8*alfa*x23(2).^4./x23(1).^4))./(x23(2).^3./6) - sigadm;
    g23 = cat(g2,g3);
    incr = -g23.jac{1}\g23.val;
    x0 = x0 + incr;
    dlag23dx1 = fx.jac{1}(1) + u23(1)*g2.jac{1}(1) + u23(2)*g3.jac{1}(1);
    dlag23dx2 = fx.jac{1}(2) + u23(1)*g2.jac{1}(2) + u23(2)*g3.jac{1}(2);
    dlag23 = cat(dlag23dx1,dlag23dx2);
    incr2 = -dlag23.jac{1}\dlag23.val;
    u0 = u0 + incr2;
end

fprintf('x1_23: %.3f cm\nx2_23: %.3f cm\nVolume(x1_23,x2_23): %.3f cm³\n',x23(1),x23(2),fx);
 
fprintf('u2: %.3f\nu3: %.3f\n',u23(1),u23(2));

if u23(1)<0 || u23(2)<0
    fprintf('Multiplicador de Lagrange negativo!!!\n');
else
    fprintf('Os Multiplicadores de Lagrange sao positivos!!!\n\n');
end

%% RESPOSTA

% x(1): 6.353 cm
% x(2): 29.672 cm
% Volume(x(1),x(2)): 528629.447 cm³
% OtimizacaoPorticoAD
% x1_13: 6.353 cm
% x2_13: 29.672 cm
% Volume(x1_13,x2_13): 528629.447 cm³
% u1: 487.560
% u3: 2351.133
% Os Multiplicadores de Lagrange sao positivos!!!
% 
% x1_23: 28.093 cm
% x2_23: 23.623 cm
% Volume(x1_23,x2_23): 1175036.387 cm³
% u2: -3727.219
% u3: 9767.094
% Multiplicador de Lagrange negativo!!!
