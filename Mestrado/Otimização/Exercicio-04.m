% Universidade Federal de Pernambuco - UFPE
% Disciplina de Otimização - Profa. Silvana Bastos
% Exercício 03: Programação Linear - SIMPLEX
%------------------------------------------------%
% 
% Implementar script para programação linear via o método simplex.
% Aplicar para testar o programa o exemplo resolvido em sala.
% Escolher outros exemplos (casos com restrição de igualdade e desigualdade).
% Testar e comparar resultados usando a função linprog do Optimization
% Toolbox  do MATLAB.

%% Implementando o Algoritmo SIMPLEX
%---------------------------------%

% funcao f(x) = C'*x
C = [-1 -1/3]';
fprintf('Vetor da funcao objetivo:\n');
disp(C);

% restricoes de desigualdade do tipo A*x >= b
A = -1.*[1 1; 1 1/4; 1 -1; -1/4 -1; -1 -1; -1 1];
b = -1.*[2; 1; 2; 1; -1; 2];
fprintf('Restricoes:\n');
disp(table(A,b));

% indices das restricoes
wtotal = [1 2 3 4 5 6];

% apontador inicial
w = [2 6]; 
wleng = length(w);

Aw = A(w,:); % matriz ativa
bw = b(w); % segundo membro correspondente
x = Aw\bw; % vertice inicial

r = A*x - b; % calculo do residuo
f = C'*x;

if r < 0
    disp('restricao violada');
end

lamb = Aw'\C; % lambda inicial

fprintf('apontador inicial:\n');
disp(w);
fprintf('restricoes ativas:\n');
disp(table(Aw,bw));
fprintf('x0 = \n');
disp(x);
fprintf('f(x0): %.4f\n', f);
fprintf('\nlambda:\n');
disp(lamb);

dimAj = length(A) - length(w); % dimensao da Matriz Aj

while any(lamb<0) == 1 % criterio de parada: todos os lambda's positivos
    
    i = 2;
    while i <= wleng
        e = zeros(wleng,1);
        if abs(lamb(i)) < abs(lamb(i-1))
            e(i-1) = 1;
        else
            e(i) = 1;
        end
        i = i + 1;
    end

    P = Aw\e; % direcao do movimento
    fprintf('P =\n');
    disp(P);
   
    % inicializacao de parametros
    Aj = zeros(dimAj,2);
    bj = zeros(dimAj,1);
    wj = zeros(dimAj,1);
    i = 1; j = 1;
    sig = zeros(3,1);
    alfa = Inf;
    
    for i = 1:length(wtotal)
        if j <= dimAj
            if any(A(i,:) ~= Aw(1,:)) == 1 && any(A(i,:) ~= Aw(2,:)) == 1
               Aj(j,:) = A(i,:);
               bj(j,:) = b(i,:);
               wj(j) = wtotal(i);
               j = j + 1;
            end
        end
    end
       
    rj = Aj*x - bj; % residuo das restricoes nao pertencentes ao apontador w
    j = Aj*P;
    fprintf('Residuos das restricoes nao-ativas:\n');
    disp(rj);
    fprintf('Aj*P = \n');
    disp(j);
        
    % calculo do passo e novo apontador
    for i = 1:dimAj
        if j(i) < 0
           sig(i) = -rj(i)/j(i);
           if abs(sig(i)) <= alfa
               alfa = sig(i);
               k = 2;
               while k <= wleng
                   if abs(lamb(k)) < abs(lamb(k-1))
                       w(k-1) = wj(i);
                   else
                       w(k) = wj(i);
                   end
               k = k + 1;
               end
           end
        else
           sig(i) = Inf;
        end
    end
    
    fprintf('sigma:\n');
    disp(sig);
    fprintf('alfa:\n');
    disp(alfa);
        
    % limitacao do valor de alfa
    if alfa == Inf
        disp('Problema Ilimitado');
    else
        x = x + alfa*P; % atualizando o valor de x para a nova direcao
    end
      
    Aw = A(w,:); % atualizando a matriz ativa
    bw = b(w); % atualizando o segundo membro correspondente
    
    f = C'*x; % valor da funcao
      
    lamb = Aw'\C; % novo lambda
    
    fprintf('novo apontador:\n');
    disp(w);
    fprintf('restricoes ativas:\n');
    disp(table(Aw,bw));
    fprintf('x = \n');
    disp(x);
    fprintf('f(x): %.4f\n', f);
    fprintf('\nlambda:\n');
    disp(lamb);
    
end

fprintf('solucao 1: \n x=[%.4f %.4f] \n f(x)=%.4f\n\n',x(1), x(2), f);

%% Usando a função 'linprog.m' do MATLAB

%restricoes de desigualdade do tipo A*x <= b
%logo, deve-se multiplicar por -1
Am = -1.*A;
bm = -1.*b;

[xm, fm] = linprog(C,Am,bm);

fprintf('solucao 2: \n x=[%.4f %.4f] \n f(x)=%.4f\n',xm(1),xm(2),fm);

