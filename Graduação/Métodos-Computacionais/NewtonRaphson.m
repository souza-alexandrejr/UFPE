function xzero = NewtonRaphson(F,dF,x0)
% Metodo de Newton-Raphson

a = input('\nIntervalo para plotagem:\nLimite inferior:');
b = input('Limite superior:');

x = linspace(a,b);

plot(x,F(x))
grid on

i=0;
tol=100;
xn = x0;

es = input('Erro máximo:');

resp = input('Definir limite de iterações?(s/n)','s');
if resp == 's'
    itemax = input('Número máximo de iterações:');
end

while tol>es
    i=i+1;
    xv=xn;
    
    xn=xv-F(xv)./dF(xv);
    
    tol=abs((xn-xv)/xn)*100;
    
    tabela(i,:)=[i xv xn F(xn) tol];
    if resp == 's'
        if i == itemax
            break
        end
    end
end

save('tabelaNR','tabela');

xzero = xn;

fprintf('\nRaiz da função: %.10f \nNúmero de iterações: %d \nF(%.10f) = %.10f \nErro: %.10f',xzero,i,xzero,F(xzero),tol)
