function xzero = Bissecao(F,a,b)
% Cálculo da raiz de uma função F pelo Método da Bisseção 
% a partir de um intervalo [a, b]

% Intervalo para plotagem do gráfico
x = linspace(a,b); 

plot(x,F(x))
grid on

i = 0;
tol = 100;
xn = a;

es = input('Erro máximo:');

resp = input('Definir limite de iterações?(s/n)','s');
if resp == 's'
    itemax = input('Número máximo de iterações:');
end

while tol > es
    i = i+1;
    xv = xn;
    xn = (a+b)/2;
    
    tol = abs((xn-xv)/xn)*100;    
    tabela(i,:) = [i a b xn F(xn) tol];
    if F(xn) == 0
        break
    end
    if F(a)*F(xn)<0
        b = xn;
    else
        a = xn;
    end
    
    if resp == 's'
        if i == itemax
            break
        end
    end
end

save('tabelabis','tabela');

xzero = xn;

fprintf('\nRaiz da função: %.10f \nNúmero de iterações: %d \nF(%.10f) = %.10f \nErro: %.10f',xzero,i,xzero,F(xzero),tol)
