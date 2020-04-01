function x = Crout(A,B)

[l,c] = size(A);
n = l;
L = zeros(n,n);
for i=1:n
    L(i,1) = A(i,1);
end

U = eye(n,n);

for j = 2:n
    U(1,j) = A(1,j)/L(1,1);
end

for i = 2:n
    for j = 2:n
        if i >= j
            L(i,j) = A(i,j) - L(i,1:j-1)*U(1:j-1,j);
        end
        if i < j
            U(i,j) = (A(i,j) - L(i,1:i-1)*U(1:i-1,j))/L(i,i);
        end
    end
end

for i = 1:n
    soma = 0;
    for k = 1:i-1
        soma = soma + L(i,k)*d(k);
    end
    d(i) = (B(i) - soma) / L(i,i);
end
for i = n:-1:1
    soma = 0;
    for k = i+1:n
        soma = soma + U(i,k)*x(k);
    end
    x(i) = d(i) - soma;
end
end

      