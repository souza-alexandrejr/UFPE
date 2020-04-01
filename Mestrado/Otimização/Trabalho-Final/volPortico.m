function [v, dv] = volPortico(x)

alfa = 1; % raz�o entre altura do pilar e v�o da viga
L = 550; % comprimento do v�o da viga (cm)

x = initVariablesADI(x);
vol = 2*alfa*L*x(1).^2 + L*x(2).^2;
v = vol.val;

if nargout > 1 % caso o gradiente seja solicitado
      dv = full(vol.jac{1}); % full -> transformar para double
end

end
