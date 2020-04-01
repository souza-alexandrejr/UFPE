function [d2fx,dfx] = DerivFun(NameFun, xi)
% Entradas:
% NameFun: String com o nome da funcao
% xi : valor onde a derivada sera calculada

% Calculo da Primeira e Segunda Derivada a partir de uma funcao analitica

h = 0.05*xi;

% Segunda Derivada por diferenças centradas

d2fx = ( feval(NameFun,(xi-h)) - 2*feval(NameFun,xi) + feval(NameFun,(xi+h)))/(h.^2);

% Primeira Derivada

dfx = ( feval(NameFun,(xi+h)) - feval(NameFun,(xi-h)) )/(2.*h);

end

