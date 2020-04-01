function plotBruggeFieldResults(wellSolsHF, wellSolsROM, schedule, varargin)
% Plot MRST/ROM (TPWL or TPWL/POD) results at a single plot (Brugge Model).
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   plotBruggeFieldResults(wellSolsHF, wellSolsROM, schedule, varargin)
%
% DESCRIPTION:
%
%   This function plots MRST/ROM results, only for the field,
%   applicable only for Brugge Model. It also computes error
%   between these results.
%
% REQUIRED PARAMETERS:
%
%   wellSolsHF    - Well solution at each control step, obtained from 
%                   a high fidelity simulation run;
%
%   wellSolsROM   - Well solution at each control step, obtained from 
%                   a reduced order model simulation (TPWL or TPWL/POD);
%
%   schedule      - Set of controls applied at MRST/ROM simulations;
%
% OPTIONAL PARAMETERS:
%   
%   'POD'        - Whether or not POD was applied (legend issue);
%
%   'saveFig'    - Whether or not to save figures ('fig' and 'png' format);
%
%   'closeFig'   - Whether or not to close all figures at the end;
%
%   'lang'       - Verbose language, with the options:
%                    'pt-br': Brazilian Portuguese (default)
%                    'eng': English

opt = struct('POD', false, ...
             'saveFig', false, ...       
             'closeFig', false, ...
             'lang', 'pt-br');        

opt = merge_options(opt, varargin{:});

% Simulation time
T = convertTo(cumsum(schedule.step.val), year);

%% Injector Wells' Water Rate

names = {'BR-I-1', 'BR-I-2', 'BR-I-3', 'BR-I-4', 'BR-I-5', ...
         'BR-I-6', 'BR-I-7', 'BR-I-8', 'BR-I-9', 'BR-I-10'};

nn = numel(names);

FieldWaterInjRate_hf = zeros(numel(T), 1);
FieldWaterInjRate_rom = zeros(numel(T), 1);

for i = 1:nn
    name = names{i};

    qWs_I_hf = convertTo(getWellOutput(wellSolsHF, 'qWs', name), stb/day);
    qWs_I_rom = convertTo(getWellOutput(wellSolsROM, 'qWs', name), stb/day);
    
    FieldWaterInjRate_hf = FieldWaterInjRate_hf + qWs_I_hf;
    FieldWaterInjRate_rom = FieldWaterInjRate_rom + qWs_I_rom;
end

%% Producer Wells' Oil Rate

names = {'BR-P-1', 'BR-P-2', 'BR-P-3', 'BR-P-4', 'BR-P-5', ...
         'BR-P-6', 'BR-P-7', 'BR-P-8', 'BR-P-9', 'BR-P-10', ...
         'BR-P-11', 'BR-P-12', 'BR-P-13', 'BR-P-14', 'BR-P-15', ...
         'BR-P-16', 'BR-P-17', 'BR-P-18', 'BR-P-19', 'BR-P-20'};

nn = numel(names);

FieldOilProdRate_hf = zeros(numel(T), 1);
FieldOilProdRate_rom = zeros(numel(T), 1);

for i = 1:nn
    name = names{i};

    qOs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qOs', name)), stb/day);
    qOs_P_rom = convertTo(abs(getWellOutput(wellSolsROM, 'qOs', name)), stb/day);
    
    FieldOilProdRate_hf = FieldOilProdRate_hf + qOs_P_hf;
    FieldOilProdRate_rom = FieldOilProdRate_rom + qOs_P_rom;
end

%% Producer Wells' Water Rate

FieldWaterProdRate_hf = zeros(numel(T),1);
FieldWaterProdRate_rom = zeros(numel(T),1);

for i = 1:nn
    name = names{i};
    
    qWs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qWs', name)), stb/day);
    qWs_P_rom = convertTo(abs(getWellOutput(wellSolsROM, 'qWs', name)), stb/day);
    
    FieldWaterProdRate_hf = FieldWaterProdRate_hf + qWs_P_hf;
    FieldWaterProdRate_rom = FieldWaterProdRate_rom + qWs_P_rom;
end

%% Plot Field Water Injection Rate

f1 = figure(1);
hold on
plot(T, FieldWaterInjRate_hf, 'k', 'linewidth', 2)
plot(T, FieldWaterInjRate_rom, 'r--o', 'linewidth', 2)
hold off
set(gca,'FontSize',18)
if ~(opt.POD)
    legend('MRST', 'TPWL', 'Location', 'Best');
elseif opt.POD
    legend('MRST', 'TPWL/POD', 'Location', 'Best');
end
axis tight
grid on
box on

if (strcmp(opt.lang, 'pt-br'))
    title('Vazão de Injeção de Água (Campo)','FontSize',18,'FontWeight','bold','Color','k')
    xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
elseif (strcmp(opt.lang, 'eng'))
    title('Water Injection Rate (Field)','FontSize',18,'FontWeight','bold','Color','k')
    xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
end

if (opt.saveFig)
    saveas(f1, 'qWs_Inj_Field', 'fig');
    saveas(f1, 'qWs_Inj_Field', 'png');
end

%% Plot Field Oil Production Rate

f2 = figure(2);
hold on
plot(T, FieldOilProdRate_hf, 'k', 'linewidth', 2)
plot(T, FieldOilProdRate_rom, 'r--o', 'linewidth', 2)
hold off
set(gca,'FontSize',18)
if ~(opt.POD)
    legend('MRST', 'TPWL', 'Location', 'Best');
elseif opt.POD
    legend('MRST', 'TPWL/POD', 'Location', 'Best');
end
axis tight
grid on
box on

if (strcmp(opt.lang, 'pt-br'))
    title('Vazão de Produção de Óleo (Campo)','FontSize',18,'FontWeight','bold','Color','k')
    xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
elseif (strcmp(opt.lang, 'eng'))
    title('Oil Production Rate (Field)','FontSize',18,'FontWeight','bold','Color','k')
    xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
end

if (opt.saveFig)
    saveas(f2, 'qOs_Field', 'fig');
    saveas(f2, 'qOs_Field', 'png');
end

%% Plot Field Water Production Rate

f3 = figure(3);
hold on
plot(T, FieldWaterProdRate_hf, 'k', 'linewidth', 2)
plot(T, FieldWaterProdRate_rom, 'r--o', 'linewidth', 2)
hold off
set(gca,'FontSize',18)
if ~(opt.POD)
    legend('MRST', 'TPWL', 'Location', 'Best');
elseif opt.POD
    legend('MRST', 'TPWL/POD', 'Location', 'Best');
end
axis tight
grid on
box on

if (strcmp(opt.lang, 'pt-br'))
    title('Vazão de Produção de Água (Campo)','FontSize',18,'FontWeight','bold','Color','k')
    xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
elseif (strcmp(opt.lang, 'eng'))
    title('Water Production Rate (Field)','FontSize',18,'FontWeight','bold','Color','k')
    xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
end

if (opt.saveFig)
    saveas(f3, 'qWs_Field', 'fig');
    saveas(f3, 'qWs_Field', 'png');
end

%% Plot Field Liquid Production Rate

f4 = figure(4);
hold on
plot(T, FieldOilProdRate_hf + FieldWaterProdRate_hf, 'k', 'linewidth', 2)
plot(T, FieldOilProdRate_rom + FieldWaterProdRate_rom, 'r--o', 'linewidth', 2)
hold off
set(gca,'FontSize',18)
if ~(opt.POD)
    legend('MRST', 'TPWL', 'Location', 'Best');
elseif opt.POD
    legend('MRST', 'TPWL/POD', 'Location', 'Best');
end
axis tight
grid on
box on

if (strcmp(opt.lang, 'pt-br'))
    title('Vazão de Produção de Líquido (Campo)','FontSize',18,'FontWeight','bold','Color','k')
    xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
elseif (strcmp(opt.lang, 'eng'))
    title('Liquid Production Rate (Field)','FontSize',18,'FontWeight','bold','Color','k')
    xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
end
    
if (opt.saveFig)
    saveas(f4, 'qTs_Field', 'fig');
    saveas(f4, 'qTs_Field', 'png');
end

if opt.closeFig
    close all;
end

%% Error Computation

% Water Injection Error
watInjErr_rom = 100*sum(abs(FieldWaterInjRate_hf - FieldWaterInjRate_rom))/sum(FieldWaterInjRate_hf);

% Oil Production Error
oilErr_rom = 100*sum(abs(FieldOilProdRate_hf - FieldOilProdRate_tpwl))/sum(FieldOilProdRate_hf);

% Water Production Error
watProdErr_rom = 100*sum(abs(FieldWaterProdRate_hf - FieldWaterProdRate_tpwl))/sum(FieldWaterProdRate_hf);

f5 = figure(5);
hold on
c = categorical({'Eo (ROM)','Ewpro (ROM)','Ewinj (ROM)'});
bar(c, [oilErr_rom, watProdErr_rom, watInjErr_rom]);
hold off
grid on
box on
set(gca,'FontSize',18)

if (strcmp(opt.lang, 'pt-br'))
    title('Erro Relativo (%)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Erro','FontSize',18,'FontWeight','bold','Color','k')
elseif (strcmp(opt.lang, 'eng'))
    title('Error Computation (%)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Error','FontSize',18,'FontWeight','bold','Color','k')
end
    
if (opt.saveFig)
    saveas(f5, 'error_comp', 'fig');
    saveas(f5, 'error_comp', 'png');
end

fprintf('Oil Production Error (MRST vs. ROM): %.5f \n', oilErr_rom);

fprintf('Water Production Error (MRST vs. ROM): %.5f \n', watProdErr_rom);

fprintf('Water Injection Error (MRST vs. ROM): %.5f \n', watInjErr_rom);

end

