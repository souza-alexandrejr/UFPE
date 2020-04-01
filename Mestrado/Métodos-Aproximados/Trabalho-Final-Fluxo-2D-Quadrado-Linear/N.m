function y = N(ksi,eta)
% Funcoes de forma para elemento do tipo TRIANGULO QUADRATICO
  A = [1 -3 2 -3 2 4;
       0 4 -4 0 0 -4;
       0 -1 2 0 0 0;
       0 0 0 0 0 4;
       0 0 0 -1 2 0;
       0 0 0 4 -4 -4];
  for i = 1:6
    c = zeros(6,1);
    c(i) = 1;
    y(i) = [1,ksi,ksi^2,eta,eta^2,ksi*eta]*A*c;
  end
end