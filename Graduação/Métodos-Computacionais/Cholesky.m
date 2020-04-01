function U = Cholesky(A)

n = size(A);

U = zeros(n);

for i = 1:n(1)
    U(i,i) = sqrt(A(i,i)-sum(U(:,i).^2));
    
    for j = i+1:n
        U(i,j) = (A(i,j)-sum(U(1:i-1,i).*U(1:i-1,j)))/U(i,i);
    end
    
    disp(U);
end

