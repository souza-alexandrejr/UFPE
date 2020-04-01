function y = dN_deta(ksi,eta)
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
    y(i) = [0,0,0,1,2*eta,ksi]*A*c;
  end
end