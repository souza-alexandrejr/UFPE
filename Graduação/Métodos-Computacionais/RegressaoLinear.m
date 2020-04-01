function rlin = RegressaoLinear(x,y)
% Regressão Linear

% Exemplo: Usar regressão linear para determinar os coeficientes a1  e a0 da
% função y = a1 x + a0
tit = input('titulo do exemplo :');
% x = input('Entre com os dados da variavel independente: ');
% y = input('Entre com os dados da variavel dependente: ');

% ---------------------------------------------------
% Determinacao dos coeficientes da reta de regressao
% Total de dados (pegue o comprimento do vetor x ou y) 
n = length(x);
if n ~= length(y)
    error('os vetores x e y devem ter a mesma dimensao');
end
Sx = sum(x);    Sy = sum(y);
Sxy = sum(x.*y);   Sxx = sum(x.^2);
a1 = ( n * Sxy - Sx*Sy) / (n * Sxx - Sx^2 ); 
a0 = Sy/n - (Sx/n) * a1; 

% ----------------------------------------------------

% Quantificacao do erro da regressao
% Calculo do erro global (Sr)
E = sum( (y - a0 - a1*x).^2 );

% Calculo do desvio St em relacao à media
St = sum ( (y - (Sy/n)).^2 );

% Calculo do erro-padrao da estimativa
Sy_x = sqrt(E/(n-2));

% Coeficiente de determinacao
r2 = (St-E) / St;

% Coeficiente de correlacao:
r = sqrt(r2);
rlin = r;

end