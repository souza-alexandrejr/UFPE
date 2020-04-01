function [ k ] = permRel(b, s)
% funcao de calculo da permeabilidade relativa

srw = .2;
sro = .2;

% da agua
% se = (s-srw)/(1-srw-sro);
% k = b(1).*se.^b(2);

% do oleo
se = (1-s-sro)/(1-srw-sro);
k = b(1).*se.^b(2);

end

