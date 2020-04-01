function xzero = Bissecao(F,a,b)
% C�lculo da raiz de uma fun��o F pelo M�todo da Bisse��o 
% a partir de um intervalo [a, b]

% Intervalo para plotagem do gr�fico
x = linspace(a,b); 

plot(x,F(x))
grid on

i = 0;
tol = 100;
xn = a;

es = input('Erro m�ximo:');

resp = input('Definir limite de itera��es?(s/n)','s');
if resp == 's'
    itemax = input('N�mero m�ximo de itera��es:');
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

fprintf('\nRaiz da fun��o: %.10f \nN�mero de itera��es: %d \nF(%.10f) = %.10f \nErro: %.10f',xzero,i,xzero,F(xzero),tol)
