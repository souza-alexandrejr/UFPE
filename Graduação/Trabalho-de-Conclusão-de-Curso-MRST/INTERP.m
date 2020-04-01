function [y,dy] = INTERP(x,ISW,N,xt,yt)
% A rotina busca na tabela e calcula por interpolação linear
% o valor da ordenada y no ponto x.
% Se o argumento x estiver fora do intervalo da tabela, 
% são utilizados os pontos da extremidade.
% -----------------------------------------------------------
% Dados de entrada:
% x = argumento;
% Se ISW = 0, a derivada não é calculada; 
% N = número de entradas na tabela;
% xt = vetor da variável independente;
% yt = vetor da variável dependente.
% -----------------------------------------------------------
% Dados de saída:
% y = valor interpolado;
% dy = derivada do valor interpolado.
% -----------------------------------------------------------

if x < xt(N) % Se x for maior que o maior valor da tabela
    if x > xt(1) % Se x for menor que o menor valor da tabela
        for i = 2:N  % Regra Geral      
            if x >= xt(i-1) && x < xt(i)
                y = yt(i-1) + (x-xt(i-1))*(yt(i)-yt(i-1))/(xt(i)-xt(i-1));
                if ISW ~= 0
                    dy = (yt(i)-yt(i-1))/(xt(i)-xt(i-1));
                end
            end
        end
    else
    y = yt(1);
    if ISW ~= 0
        dy = (yt(2)-yt(1))/(xt(2)-xt(1));
    end
    end
else
    y = yt(N);
    if ISW ~= 0
        dy = (yt(N)-yt(N-1))/(xt(N)-xt(N-1));
    end
end