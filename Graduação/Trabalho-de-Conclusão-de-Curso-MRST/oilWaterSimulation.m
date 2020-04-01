% --- Simulação de Fluxo Bifásico Óleo/Água --- %
% -- Em um sistema horizontal unidimensional -- %
% - Usando Método IMPES e Eliminação de Gauss - %
% --------------------------------------------- %
% ------- Número máximo de células: 100 ------- %
% --------------------------------------------- %

% LEITURA DE DADOS
% --------------- %

%% DADOS DO ARQUIVO "syst.xls"

% USO e USW = 'Upstream Weighting Factors' para óleo e água
% 1.0 para Upstream
% 0.0 para Downstream
% Valores entre 0 e 1 (Padrão = 1.0)

syst = importdata('syst.xls');

USO = syst.data(1,1);
USW = syst.data(1,2);
area  = syst.data(1,3);
N = syst.data(1,4);
dx = syst.data(:,5);
phi = syst.data(:,6);
perm = syst.data(:,7);
Swi = syst.data(1,8);
Cr = syst.data(1,9);
dt = syst.data(1,10);
tmax = syst.data(1,11);
Pinit = syst.data(1,12);
Pl = zeros(1000,1); Pr = zeros(1000,1);
Pr(1) = syst.data(1,13);
Pl(1) = syst.data(1,14);
Qwi = zeros(1000,1);
Qwi(1) = syst.data(1,15);

%Gerando as posições x(i)
x = zeros(N,1);
x(1) = dx(1)/2;
for i = 2:N
    x(i) = x(i-1) + (dx(i-1)+dx(i))/2;
end

% Condição de Contorno no lado esquerdo a ser usada
% IBC = 2, para Taxa de Injeção Constante
% IBC = 1, para Pressão Constante no lado esquerdo 

if Pl ~= 0
    Qwi = 0;
    IBC = 1;
else
    IBC = 2;
end

%% DADOS DO ARQUIVO "sat.xls"
% Tabelas de Permeabilidade Relativa e Pressão Capilar

sat = importdata('sat.xls');

Nsat = sat.data(1,1);
Pcmult = sat.data(1,2);
Swt = sat.data(:,3);
Krot = sat.data(:,4);
Krwt = sat.data(:,5);
Pct = sat.data(:,6);

for i = 1:Nsat
    Pct(i) = Pct(i)*Pcmult;
end

%% DADOS DO ARQUIVO "pvt.xls"

pvt = importdata('pvt.xls');

Npvt = pvt.data(1,1);
Pt = pvt.data(:,2);
Bot = pvt.data(:,3);
Bwt = pvt.data(:,4);
Muot = pvt.data(:,5);
Muwt = pvt.data(:,6);

% Convertendo Bo e Bw para 1/Bo e 1/Bw
for i = 1:Npvt
    Bot(i) = 1/Bot(i);
    Bwt(i) = 1/Bwt(i);
end

% INICIALIZAÇÃO
% ------------ %

t = zeros(1000);
Po = zeros(N,1); Pw = zeros(N,1); Sw = zeros(N,1);
matrizPO = zeros(N,1000);
matrizSW = zeros(N,1000);

for i = 1:N
    Po(i) = Pinit;
    Sw(i) = Swi;
end

if IBC == 2
    Pl(1) = Po(1);
end

Qop = zeros(1000,1); 
Qwp = zeros(1000,1);
Wc = zeros(1000,1);

% Inicializando vetores
Kro = zeros(N,1); Krw = zeros(N,1);
Pcow = zeros(N,1); DPcow = zeros(N,1);
Bo = zeros(N,1); DBo = zeros(N,1);
Bw = zeros(N,1); DBw = zeros(N,1);
Muo = zeros(N,1); Muw = zeros(N,1);
Lamo = zeros(N,1); Lamw = zeros(N,1);
Txom = zeros(N,1); Txwm = zeros(N,1);
Txop = zeros(N,1); Txwp = zeros(N,1);
Cpoo = zeros(N,1); Cswo = zeros(N,1);
Cpow = zeros(N,1); Csww = zeros(N,1);

A = zeros(N,1); B = zeros(N,1); C = zeros(N,1); D = zeros(N,1);

% SAÍDA DE DADOS
% ------------- %
   
phead = {'TIME','PL','P( 1)','P( 2)','P( 3)',...
'P( 4)','P( 5)','P( 6)','P( 7)','P( 8)',...
'P( 9)','P(10)','P(11)','P(12)','P(13)',...
'P(14)','P(15)','P(16)','P(17)','P(18)',...
'P(19)','P(20)','P(21)','P(22)','P(23)',...
'P(24)','P(25)','P(26)','P(27)','P(28)',...
'P(29)','P(30)','P(31)','P(32)','P(33)',...
'P(34)','P(35)','P(36)','P(37)','P(38)',...
'P(39)','P(40)','P(41)','P(42)','P(44)',...
'P(44)','P(45)','P(46)','P(47)','P(48)',...
'P(49)','P(50)','P(51)','P(52)','P(55)',...
'P(54)','P(55)','P(56)','P(57)','P(58)',...
'P(59)','P(60)','P(61)','P(62)','P(66)',...
'P(64)','P(65)','P(66)','P(67)','P(68)',...
'P(69)','P(70)','P(71)','P(72)','P(77)',...
'P(74)','P(75)','P(76)','P(77)','P(78)',...
'P(79)','P(80)','P(81)','P(82)','P(83)',...
'P(84)','P(85)','P(86)','P(87)','P(88)',...
'P(89)','P(90)','P(91)','P(92)','P(99)',...
'P(94)','P(95)','P(96)','P(97)','P(98)',...
'P(99)','P(100)','PR'};

shead = {'TIME','SW( 1)','SW( 2)','SW( 3)',...
'SW( 4)','SW( 5)','SW( 6)','SW( 7)','SW( 8)',...
'SW( 9)','SW(10)','SW(11)','SW(12)','SW(13)',...
'SW(14)','SW(15)','SW(16)','SW(17)','SW(18)',...
'SW(19)','SW(20)','SW(21)','SW(22)','SW(23)',...
'SW(24)','SW(25)','SW(26)','SW(27)','SW(28)',...
'SW(29)','SW(30)','SW(31)','SW(32)','SW(33)',...
'SW(34)','SW(35)','SW(36)','SW(37)','SW(38)',...
'SW(39)','SW(40)','SW(41)','SW(42)','SW(44)',...
'SW(44)','SW(45)','SW(46)','SW(47)','SW(48)',...
'SW(49)','SW(50)','SW(51)','SW(52)','SW(55)',...
'SW(54)','SW(55)','SW(56)','SW(57)','SW(58)',...
'SW(59)','SW(60)','SW(61)','SW(62)','SW(66)',...
'SW(64)','SW(65)','SW(66)','SW(67)','SW(68)',...
'SW(69)','SW(70)','SW(71)','SW(72)','SW(77)',...
'SW(74)','SW(75)','SW(76)','SW(77)','SW(78)',...
'SW(79)','SW(80)','SW(81)','SW(82)','SW(83)',...
'SW(84)','SW(85)','SW(86)','SW(87)','SW(88)',...
'SW(89)','SW(90)','SW(91)','SW(92)','SW(99)',...
'SW(94)','SW(95)','SW(96)','SW(97)','SW(98)',...
'SW(99)','SW(100)'};

whead = {'TIME', 'Pl', 'Qwi', 'Pr', 'Qop', 'Qwp', 'Wc'};

phead(N+3) = {'Pr'}; 

x = x'; %Transpondo x para formato da tabela

titulopo = {'TIME, RATES AND OIL PRESSURES'};
xlswrite('po.xls',titulopo,1,'A1');
xlswrite('po.xls',phead(1:N+3),1,'A2');
xlswrite('po.xls','X= ',1,'A3');
xlswrite('po.xls',x(1:N),1,'B3');

titulosw = {'TIME AND WATER SATURATIONS'};
xlswrite('sw.xls',titulosw,1,'A1');
xlswrite('sw.xls',shead(1:N+1),1,'A2');
xlswrite('sw.xls','X= ',1,'A3');
xlswrite('sw.xls',x(1:N),1,'B3');

titulowells = {'PRODUCTION/INJECTION RESULTS'};
xlswrite('wells.xls',titulowells,1,'A1');
xlswrite('wells.xls',whead,1,'A2');
    
for j = 1:1000 % Time Loop
             
    if t(j) > tmax % critério de parada
        index = j-1;
        break
    end
    
    % Interpolação nas tabelas dos dados de entrada
    % para as propriedades funções da saturação (Kro, Krw, Pcow)
    % e para as propriedades funções da pressão (Bo, Bw, Muo, Muw)
    
    for i = 1:N
        % Permeabilidade Relativa do Óleo
        Kro(i) = INTERP(Sw(i),0,Nsat,Swt,Krot);
        % Permeabilidade Relativa da Água
        Krw(i) = INTERP(Sw(i),0,Nsat,Swt,Krwt);
        % Pressão Capilar e sua Derivada
        [Pcow(i),DPcow(i)] = INTERP(Sw(i),1,Nsat,Swt,Pct);
        % (1/Bo) e sua Derivada
        [Bo(i),DBo(i)] = INTERP(Po(i),1,Npvt,Pt,Bot);
        % (1/Bw) e sua Derivada
        Pw(i) = Po(i) - Pcow(i);
        [Bw(i),DBw(i)] = INTERP(Pw(i),1,Npvt,Pt,Bwt);
        % Viscosidade do Óleo
        Muo(i) = INTERP(Po(i),0,Npvt,Pt,Muot);
        % Viscosidade da Água
        Muw(i) = INTERP(Pw(i),0,Npvt,Pt,Muwt);
        
        % Mobilidades
        Lamo(i) = Kro(i)*Bo(i)/Muo(i);
        Lamw(i) = Krw(i)*Bw(i)/Muw(i);
    end
    
    % Loop para Grid-Blocks
    
    for i = 1:N
        if i~=1
            Lamom = Lamo(i-1)*USO + Lamo(i)*(1-USO);
            Lamwm = Lamw(i-1)*USW + Lamw(i)*(1-USW);
            if Po(i-1) < Po(i)
                Lamom = Lamo(i)*USO + Lamo(i-1)*(1-USO);
            end
            if Pw(i-1) < Pw(i)
                Lamwm = Lamw(i)*USW + Lamw(i-1)*(1-USW);
            end
        else
            Lamom = Lamo(i);
            Lamwm = Lamw(i);
        end
        if i ~= N
            Lamop = Lamo(i)*USO + Lamo(i+1)*(1-USO);
            Lamwp = Lamw(i)*USW + Lamw(i+1)*(1-USW);
            if Po(i+1) > Po(i)
                Lamop = Lamo(i+1)*USO + Lamo(i)*(1-USO);
            end
            if Pw(i+1) > Pw(i)
                Lamwp = Lamw(i+1)*USW + Lamw(i)*(1-USW);
            end
        else
            Lamop = Lamo(i);
            Lamwp = Lamw(i);
        end
        
        % Transmissibilidades
        
        if i ~= 1
            Txom(i) = 2*Lamom/(dx(i)/perm(i)+dx(i-1)/perm(i-1))/dx(i);
            Txwm(i) = 2*Lamwm/(dx(i)/perm(i)+dx(i-1)/perm(i-1))/dx(i);
        else
            Txom(i) = 2*Lamom/dx(i)*perm(i)/dx(i);
            Txwm(i) = 2*Lamwm/dx(i)*perm(i)/dx(i);
       
        % Injeção de água no lado esquerdo requer somatório das transmissibilidades
        Txwm(i) = Txwm(i) + Txom(i);
        end
        
        if i ~= N
            Txwp(i) = 2*Lamwp/(dx(i+1)/perm(i+1)+dx(i)/perm(i))/dx(i);
            Txop(i) = 2*Lamop/(dx(i+1)/perm(i+1)+dx(i)/perm(i))/dx(i);
        else
            Txop(i) = 2*Lamop/dx(i)*perm(i)/dx(i);
            Txwp(i) = 2*Lamwp/dx(i)*perm(i)/dx(i);
        end
        
        % Coeficientes
        Cpoo(i) = (1-Sw(i))*phi(i)*(Cr*Bo(i)+DBo(i))/dt;
        Cswo(i) = -phi(i)*Bo(i)/dt;
        Cpow(i) = Sw(i)*phi(i)*(Cr*Bw(i)+DBw(i))/dt;
        Csww(i) = phi(i)*Bw(i)/dt-Cpow(i)*DPcow(i);
        
        % Matriz dos Coeficientes
        
        alfa = -Cswo(i)/Csww(i);
        A(i) = Txom(i)+alfa*Txwm(i);
        C(i) = Txop(i)+alfa*Txwp(i);
        if i ~= 1
            B(i) = -(Txop(i)+Txom(i)+Cpoo(i))-(Txwp(i)+Txwm(i)+Cpow(i))*alfa;
        end
        if i ~= N && i ~= 1
            D(i) = - (Cpoo(i)+alfa*Cpow(i))*Po(i)+alfa*(Txwp(i)*(Pcow(i+1)-Pcow(i))+Txwm(i)*(Pcow(i-1)-Pcow(i)));
        end
        if i == 1 && IBC == 2
            D(i) = - (Cpoo(i)+alfa*Cpow(i))*Po(i)+alfa*(Txwp(i)*(Pcow(i+1)-Pcow(i))+Qwi(j)/dx(i)/area);
            B(i) = - (Txop(i)+Cpoo(i))-(Txwp(i)+Cpow(i))*alfa;
        end
        if i == 1 && IBC == 1
            D(i) = - (Cpoo(i)+alfa*Cpow(i))*Po(i)+alfa*(Txwp(i)*(Pcow(i+1)-Pcow(i))+Txwm(i)*(Pl(j)+Pcow(1)));
            B(i) = - (Txop(i)+Cpoo(i))-(Txwp(i)+Txwm(i)+Cpow(i))*alfa;
        end
        if i == N
            D(i) = -(Cpoo(i)+alfa*Cpow(i))*Po(i)-(Txop(i)+alfa*Txwp(i))*Pr(j)+alfa*Txwm(i)*(Pcow(i-1)-Pcow(i));
        end
        
        t(j+1) = t(j) + dt;
        
    end
    
    % PRESSURE SOLUTION
    % ---------------- %
    
    Ponew = TRIDIA(N,A,B,C,D);
    
    % SATURATION SOLUTION
    % ------------------ %
    
    for i = 1:N
        matrizSW(i,j) = Sw(i);
        if i ~= N && i ~= 1
            Sw(i) = Sw(i)+(Txop(i)*(Ponew(i+1)-Ponew(i))+Txom(i)*(Ponew(i-1)-Ponew(i))-Cpoo(i)*(Ponew(i)-Po(i)))/Cswo(i);
        end
        if i == N
            Sw(i) = Sw(i) + (Txop(i)*(Pr(j)-Ponew(i))+Txom(i)*(Ponew(i-1)-Ponew(i))-Cpoo(i)*(Ponew(i)-Po(i)))/Cswo(i);
        end
        if i == 1
            Sw(i) = Sw(i) + (Txop(i)*(Ponew(i+1)-Ponew(i))-Cpoo(i)*(Ponew(i)-Po(i)))/Cswo(i);
        end
    end
    
    % Atualização das pressões
       
    for i = 1:N
        matrizPO(i,j) = Po(i);
        Po(i) = Ponew(i);
    end
    
    if IBC == 2  % Computar Pl se IBC=2
        Pl(j+1) = Po(1)-Pcow(1)-Qwi(j)/dx(1)/area/Txwm(1);
        Qwi(j+1) = Qwi(j);
    end
    
    Pr(j+1) = Pr(j); % mantém valor de Pr
      
    if IBC == 1   % Computar Qwi se IBC=1
        Qwi(j+1) = (Po(1)-Pcow(1)-Pl(j))*dx(1)*area*Txwm(1);
        Pl(j+1) = Pl(j);
    end
    
    % Computar Qop, Qwp e Wc
    
    Qop(j+1) = -(Pr(j)-Po(N))*dx(N)*area*Txop(N);
    Qwp(j+1) = -(Pr(j)-Po(N)+Pcow(N))*dx(N)*area*Txwp(N);
    Wc(j+1) = Qwp(j+1)/(Qwp(j+1)+Qop(j+1));
    
end

t = t(1:index,1);
Qwi = Qwi(1:index,1);
Qop = Qop(1:index,1);
Qwp = Qwp(1:index,1);
Wc = Wc(1:index,1);
Pl = Pl(1:index,1);
Pr = Pr(1:index,1);

matrizPO = matrizPO(1:N,1:index);
matrizPO = matrizPO'; % Transpondo para formato da planilha
planilhaPO = [t,Pl,matrizPO,Pr]; % concatenando todas as matrizes/vetores
xlswrite('po.xls',planilhaPO,1,'A4');

matrizSW = matrizSW(1:N,1:index);
matrizSW = matrizSW'; % Transpondo para formato da planilha
planilhaSW = [t,matrizSW]; % concatenando todas as matrizes/vetores
xlswrite('sw.xls',planilhaSW,1,'A4');

planilhawells = [t,Pl,Qwi,Pr,Qop,Qwp,Wc];
xlswrite('wells.xls',planilhawells,1,'A3');
