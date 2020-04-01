% Lista de Exercicios Nº 02 %
% ------------------------- %

%% Questao 06 - Metodo da Bissecao

fx = @(x) 2^-x - 2*sin(x);

% intervalo de convergencia [a,b]
a = 0;
b = 1;

i = 0;
tol = 1e-3;
c = (a+b)/2;

while tol < abs(fx(c))
    fxa = fx(a);
    fxb = fx(b);
    fxc = fx(c);
    fprintf('%d %.4f %.4f %.4f %.4f %.4f %.4f\n', ...
        i, a, fx(a), b, fx(b), c, fx(c));
    if fx(c) > 0 
        a = c;
    else
        b = c;
    end
    c = (a+b)/2;
    i = i + 1;
end

% Resposta
% 0 0.0000 1.0000 1.0000 -1.1829 0.5000 -0.2517
% 1 0.0000 1.0000 0.5000 -0.2517 0.2500 0.3461
% 2 0.2500 0.3461 0.5000 -0.2517 0.3750 0.0386
% 3 0.3750 0.0386 0.5000 -0.2517 0.4375 -0.1089
% 4 0.3750 0.0386 0.4375 -0.1089 0.4063 -0.0358
% 5 0.3750 0.0386 0.4063 -0.0358 0.3906 0.0013
% 6 0.3906 0.0013 0.4063 -0.0358 0.3984 -0.0173
% 7 0.3906 0.0013 0.3984 -0.0173 0.3945 -0.0080
% 8 0.3906 0.0013 0.3945 -0.0080 0.3926 -0.0034
% 9 0.3906 0.0013 0.3926 -0.0034 0.3916 -0.0011

%% Questao 06 - Metodo do Ponto Fixo (Picard)

gx = @(x) exp(1/x);

% estimativa inicial
x0 = 1.5;
i = 0;
tol = 1e-3;

while tol < abs(gx(x0) - x0)
    fprintf('%d %.4f %.4f\n', i, x0, gx(x0));
    x0 = gx(x0);
    i = i + 1;
end

% Resposta
% 0 1.5000 1.9477
% 1 1.9477 1.6710
% 2 1.6710 1.8193
% 3 1.8193 1.7327
% 4 1.7327 1.7809
% 5 1.7809 1.7533
% 6 1.7533 1.7689
% 7 1.7689 1.7600
% 8 1.7600 1.7650
% 9 1.7650 1.7622
% 10 1.7622 1.7638

%% Questao 07 - Metodo de Newton

syms x;
h(x) = x - (1+2*x)^-1;
dh(x) = diff(h,x);

x0 = 2; %estimativa inicial
xnew = 0;

tol = 1e-6;

while tol < abs(xnew - x0)
    x0 = xnew;
    fprintf('%d %.4f %.4f\n', i, x0, h(x0));
    xnew = x0 - h(x0)/dh(x0);
    i = i + 1;
end

% Resposta
% 0 2.0000 1.8000
% 1 0.0000 -1.0000
% 2 0.3333 -0.2667
% 3 0.4884 -0.0175
% 4 0.5000 -0.0001
% 5 0.5000 -0.0000

%% Questao 08 - Metodo da Secante

fx = @(x) x*cos(x);

% estimativas iniciais
x0 = 1;
x1 = 2;
xnew = 0;

i = 0;
tol = 1e-4;
fprintf('%d %.4f %.4f\n', i, x0, fx(x0));
fprintf('%d %.4f %.4f\n', i+1, x1, fx(x1));
i = 2;

while tol < abs(x0 - x1)
    xnew = x0 - fx(x0)*(x0 - x1)/(fx(x0) - fx(x1));
    x0 = x1;
    x1 = xnew;
    fprintf('%d %.4f %.4f\n', i, xnew, fx(xnew));
    i = i + 1;
end

% Resposta
% 0 1.0000 0.5403
% 1 2.0000 -0.8323
% 2 1.3936 0.2456
% 3 1.5318 0.0597
% 4 1.5762 -0.0085
% 5 1.5707 0.0002
% 6 1.5708 0.0000

%% Questao 10 - Metodo de Newton-Raphson

syms x y z
f(x,y,z) = x + y - 3;
g(x,y,z) = y - z^x;
h(x,y,z) = y*z - 7;

df = [diff(f,x), diff(f,y), diff(f,z)];
dg = [diff(g,x), diff(g,y), diff(g,z)];
dh = [diff(h,x), diff(h,y), diff(h,z)];

r = vertcat(f,g,h);
jac = vertcat(df,dg,dh);

% estimativa inicial
x0 = [1,1,1];
xnew = [2,2,2];

i = 0;
tol = 1e-5;

while tol < norm(xnew(:) - x0(:))
    fprintf('%d %.4f %.4f %.4f %.4f %.4f %.4f\n', i, ...
        x0(1), x0(2), x0(3), f(x0(1),x0(2),x0(3)), g(x0(1),x0(2),x0(3)), h(x0(1),x0(2),x0(3)));
    x0 = xnew;
    xnew(:) = x0(:) - jac(x0(1),x0(2),x0(3))\r(x0(1),x0(2),x0(3));
    i = i + 1;
end

% Resposta
% 0 1.0000 1.0000 1.0000 -1.0000 0.0000 -6.0000
% 1 2.0000 2.0000 2.0000 1.0000 -2.0000 -3.0000
% 2 0.3275 2.6725 2.8275 0.0000 1.2671 0.5565
% 3 0.8216 2.1784 3.1420 -0.0000 -0.3830 -0.1554
% 4 0.7336 2.2664 3.0865 -0.0000 -0.0196 -0.0049
% 5 0.7288 2.2712 3.0821 0.0000 -0.0001 -0.0000
