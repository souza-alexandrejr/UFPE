%% Exercicio 01 - Algoritmo Simplex
% -------------------------------- %

% Formulacao Matematica
% Min f(x) = Ct*x
% s.a.: A*x >= b

Ct = [1 10]';

% Matriz das Restricoes A
A = [4 1; 1 -1; -1 3; -1 -2; -5 -1];

% Vetor b correspondente
b = [2.5; -1; 1; -4.7; -10.2];

% Apontador
w = [1; 2; 3; 4; 5];

Aw = zeros(2,2); % Matriz Ativa
bw = zeros(2,1); % Segundo Membro Correspondente
i = 0;

while lamb(1) < 0 || lamb(2) < 0
    if i < 5
    
    Aw(1,:) = A(2,:);
    Aw(2,:) = A(4,:);
    bw(1,:) = b(2,:);
    bw(2,:) = b(4,:);
    
    x = Aw\bw;
    r = A*x - b;
    if r(:) >= 0 % Restricao Viavel ou Ativa
        lamb = Aw\Ct;
        if lamb(1) >= lamb(2)
            e = [0 1]';
        else
            e = [1 0]';
        end
        Pk = Aw\e;
    else
        fprintf('Restricao Violada');
    end
    
    Aj = zeros(3,2);
    for j = 1:3
        for k = 1:5
            if k ~= i || k ~= i+1
                Aj(j,:) = A(k,:);
            end
        end
    end
    
    j = Aj*Pk;
    sig = zeros(3,1);
    
    for k = 1:3
        if j(k) < 0
            sig(k) = -r(k)/j(k);
        else
            sig(k) = Inf;
        end
    end
    
    alfa = min(sig);

    end
    
end
