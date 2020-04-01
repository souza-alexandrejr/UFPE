%% Otimizacao de Viga (Exemplo do dia 17/10/18) via Dif. Automática

[x0,incr] = deal([20;20;20]);
tol = 1e-6;

while norm(incr) > tol
    x = initVariablesADI(x0);
    eq1 = 3.176*x(1) - 0.6233*x(1).^2./x(2) - 53.87;
    eq2 = 21.2 + x(3).*(3.176 - 1.2466*x(1)./x(2));
    eq3 = 9 + x(3).*0.6233*x(1).^2./x(2).^2;
    eq = cat(eq1,eq2,eq3);
    incr = -eq.jac{1}\eq.val;
    x0 = x0 + incr;
end

fprintf('Area de Aço: %.3f\nBase da Viga: %.3f\nMultiplicador de Lagrange: %.3f\n', x(1),x(2),x(3));