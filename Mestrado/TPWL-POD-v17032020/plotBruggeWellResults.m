function plotBruggeWellResults(wellSolsHF, wellSolsTPWL, wellSolsTPWLPOD, schedule, varargin)
% Plot MRST/TPWL/TPWL-POD results at a single plot (Brugge model).
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   plotBruggeWellResults(wellSolsHF, wellSolsTPWL, wellSolsTPWLPOD, schedule, varargin)
%
% DESCRIPTION:
%
%   This function plots MRST/TPWL/TPWL-POD results, for each well and
%   for field, applicable only for Brugge Model. It also computes error
%   between these results.
%
% REQUIRED PARAMETERS:
%
%   wellSolsHF       - Well solution at each control step, obtained from 
%                      a high fidelity simulation run;
%
%   wellSolsTPWL     - Well solution at each control step, obtained from 
%                      a TPWL simulation run;
%
%   wellSolsTPWLPOD  - Well solution at each control step, obtained from 
%                      a TPWL/POD simulation run;
%
%   schedule  - Set of controls applied at MRST/TPWL/TPWL-POD simulations;
%
% OPTIONAL PARAMETERS:
%   
%   'saveFig'    - Whether or not to save figures ('fig' and 'png' format)
%
%   'closeFig'   - Whether or not to close all figures at the end;
%
%   'lang'       - Verbose language, with the options:
%                    'pt-br': Brazilian Portuguese (default)
%                    'eng': English

opt = struct('saveFig', false,...     
             'closeFig', false, ...
             'lang', 'pt-br');  

opt = merge_options(opt, varargin{:});

T = convertTo(cumsum(schedule.step.val), year);

%% Plot Injector Wells' Bottom Hole Pressure (BHP)

names = {'BR-I-1', 'BR-I-2', 'BR-I-3', 'BR-I-4', 'BR-I-5', 'BR-I-6', ...
         'BR-I-7', 'BR-I-8', 'BR-I-9', 'BR-I-10'};
     
% nn = numel(names);

f1 = figure(1);
f1.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('BHP para os Poços Injetores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Bottom-Hole Pressure for the Injector Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 1:4
    name = names{i};

    bhp_hf = convertTo(getWellOutput(wellSolsHF, 'bhp', name), psia);
    bhp_tpwl = convertTo(getWellOutput(wellSolsTPWL, 'bhp', name), psia);
    bhp_tpwl_pod = convertTo(getWellOutput(wellSolsTPWLPOD, 'bhp', name), psia);

    subplot(2, 2, k)
    hold on
    plot(T, bhp_hf, 'k', 'linewidth', 2)
    plot(T, bhp_tpwl, 'r--o', 'linewidth', 2);
    plot(T, bhp_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressão (psi)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressure (psi)','FontSize',18,'FontWeight','bold','Color','k')
    end

    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f2 = figure(2);
f2.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('BHP para os Poços Injetores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Bottom-Hole Pressure for the Injector Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 5:8 
    name = names{i};

    bhp_hf = convertTo(getWellOutput(wellSolsHF, 'bhp', name), psia);
    bhp_tpwl = convertTo(getWellOutput(wellSolsTPWL, 'bhp', name), psia);
    bhp_tpwl_pod = convertTo(getWellOutput(wellSolsTPWLPOD, 'bhp', name), psia);

    subplot(2, 2, k)
    hold on
    plot(T, bhp_hf, 'k', 'linewidth', 2)
    plot(T, bhp_tpwl, 'r--o', 'linewidth', 2);
    plot(T, bhp_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressão (psi)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressure (psi)','FontSize',18,'FontWeight','bold','Color','k')
    end

    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f3 = figure(3);
f3.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('BHP para os Poços Injetores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Bottom-Hole Pressure for the Injector Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 9:10
    name = names{i};

    bhp_hf = convertTo(getWellOutput(wellSolsHF, 'bhp', name), psia);
    bhp_tpwl = convertTo(getWellOutput(wellSolsTPWL, 'bhp', name), psia);
    bhp_tpwl_pod = convertTo(getWellOutput(wellSolsTPWLPOD, 'bhp', name), psia);

    subplot(2, 2, k)
    hold on
    plot(T, bhp_hf, 'k', 'linewidth', 2)
    plot(T, bhp_tpwl, 'r--o', 'linewidth', 2);
    plot(T, bhp_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressão (psi)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressure (psi)','FontSize',18,'FontWeight','bold','Color','k')
    end

    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');  
    
    k = k + 1;
end       

if (opt.saveFig)
    saveas(f1, 'bhp_Injectors_1-4', 'fig');
    saveas(f1, 'bhp_Injectors_1-4', 'png');
    
    saveas(f2, 'bhp_Injectors_5-8', 'fig');
    saveas(f2, 'bhp_Injectors_5-8', 'png');
    
    saveas(f3, 'bhp_Injectors_9-10', 'fig');
    saveas(f3, 'bhp_Injectors_9-10', 'png');
end

%% Plot Injector Wells' Water Rate

FieldWaterInjRate_hf = zeros(numel(T), 1);
FieldWaterInjRate_tpwl = zeros(numel(T), 1);
FieldWaterInjRate_tpwl_pod = zeros(numel(T), 1);

f4 = figure(4);
f4.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Água Injetada nos Poços Injetores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Rate for the Injector Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 1:4
    name = names{i};

    qWs_I_hf = convertTo(getWellOutput(wellSolsHF, 'qWs', name), stb/day);
    qWs_I_tpwl = convertTo(getWellOutput(wellSolsTPWL, 'qWs', name), stb/day);
    qWs_I_tpwl_pod = convertTo(getWellOutput(wellSolsTPWLPOD, 'qWs', name), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qWs_I_hf, 'k', 'linewidth', 2)
    plot(T, qWs_I_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qWs_I_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    FieldWaterInjRate_hf = FieldWaterInjRate_hf + qWs_I_hf;
    FieldWaterInjRate_tpwl = FieldWaterInjRate_tpwl + qWs_I_tpwl;
    FieldWaterInjRate_tpwl_pod = FieldWaterInjRate_tpwl_pod + qWs_I_tpwl_pod;

    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
    
end

f5 = figure(5); 
f5.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Água Injetada nos Poços Injetores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Rate for the Injector Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 5:8
    name = names{i};

    qWs_I_hf = convertTo(getWellOutput(wellSolsHF, 'qWs', name), stb/day);
    qWs_I_tpwl = convertTo(getWellOutput(wellSolsTPWL, 'qWs', name), stb/day);
    qWs_I_tpwl_pod = convertTo(getWellOutput(wellSolsTPWLPOD, 'qWs', name), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qWs_I_hf, 'k', 'linewidth', 2)
    plot(T, qWs_I_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qWs_I_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end

    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f6 = figure(6);
f6.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Água Injetada nos Poços Injetores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Rate for the Injector Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 9:10
    name = names{i};

    qWs_I_hf = convertTo(getWellOutput(wellSolsHF, 'qWs', name), stb/day);
    qWs_I_tpwl = convertTo(getWellOutput(wellSolsTPWL, 'qWs', name), stb/day);
    qWs_I_tpwl_pod = convertTo(getWellOutput(wellSolsTPWLPOD, 'qWs', name), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qWs_I_hf, 'k', 'linewidth', 2)
    plot(T, qWs_I_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qWs_I_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end

    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end  
        
if (opt.saveFig)
    saveas(f4, 'qWs_Injectors_1-4', 'png');
    saveas(f5, 'qWs_Injectors_5-8', 'png');
    saveas(f6, 'qWs_Injectors_9-10', 'png');
end

if (opt.saveFig)
    saveas(f4, 'qWs_Injectors_1-4', 'fig');
    saveas(f4, 'qWs_Injectors_1-4', 'png');
    
    saveas(f5, 'qWs_Injectors_5-8', 'fig');
    saveas(f5, 'qWs_Injectors_5-8', 'png');
    
    saveas(f6, 'qWs_Injectors_9-10', 'fig');
    saveas(f6, 'qWs_Injectors_9-10', 'png');
end

%% Plot Producer Wells' Bottom Hole Pressure (BHP)

names = {'BR-P-1', 'BR-P-2', 'BR-P-3', 'BR-P-4', 'BR-P-5', 'BR-P-6', 'BR-P-7', ...
        'BR-P-8', 'BR-P-9', 'BR-P-10', 'BR-P-11', 'BR-P-12', 'BR-P-13', ...
        'BR-P-14', 'BR-P-15', 'BR-P-16', 'BR-P-17', 'BR-P-18', 'BR-P-19', ...
        'BR-P-20'};
     
% nn = numel(names);

f7 = figure(7);
f7.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('BHP para os Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Bottom-Hole Pressure for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 1:4
    name = names{i};

    bhp_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'bhp', name)), psia);
    bhp_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'bhp', name)), psia);
    bhp_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'bhp', name)), psia);

    subplot(2, 2, k)
    hold on
    plot(T, bhp_P_hf, 'k', 'linewidth', 2)
    plot(T, bhp_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, bhp_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressão (psi)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressure (psi)','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');   
    
    k = k + 1;
end

f8 = figure(8);
f8.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('BHP para os Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Bottom-Hole Pressure for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 5:8
    name = names{i};

    bhp_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'bhp', name)), psia);
    bhp_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'bhp', name)), psia);
    bhp_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'bhp', name)), psia);

    subplot(2, 2, k)
    hold on
    plot(T, bhp_P_hf, 'k', 'linewidth', 2)
    plot(T, bhp_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, bhp_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressão (psi)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressure (psi)','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f9 = figure(9);
f9.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('BHP para os Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Bottom-Hole Pressure for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 9:12
    name = names{i};

    bhp_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'bhp', name)), psia);
    bhp_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'bhp', name)), psia);
    bhp_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'bhp', name)), psia);

    subplot(2, 2, k)
    hold on
    plot(T, bhp_P_hf, 'k', 'linewidth', 2)
    plot(T, bhp_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, bhp_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressão (psi)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressure (psi)','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');     
    
    k = k + 1;
end

f10 = figure(10);
f10.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('BHP para os Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Bottom-Hole Pressure for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 13:16
    name = names{i};

    bhp_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'bhp', name)), psia);
    bhp_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'bhp', name)), psia);
    bhp_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'bhp', name)), psia);

    subplot(2, 2, k)
    hold on
    plot(T, bhp_P_hf, 'k', 'linewidth', 2)
    plot(T, bhp_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, bhp_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressão (psi)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressure (psi)','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');  
    
    k = k + 1;
end

f11 = figure(11);
f11.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('BHP para os Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Bottom-Hole Pressure for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 17:20
    name = names{i};

    bhp_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'bhp', name)), psia);
    bhp_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'bhp', name)), psia);
    bhp_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'bhp', name)), psia);

    subplot(2, 2, k)
    hold on
    plot(T, bhp_P_hf, 'k', 'linewidth', 2)
    plot(T, bhp_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, bhp_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressão (psi)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Pressure (psi)','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

if (opt.saveFig)
    saveas(f7, 'bhp_Producers_1-4', 'fig');
    saveas(f7, 'bhp_Producers_1-4', 'png');
    
    saveas(f8, 'bhp_Producers_5-8', 'fig');
    saveas(f8, 'bhp_Producers_5-8', 'png');

    saveas(f9, 'bhp_Producers_9-12', 'fig');
    saveas(f9, 'bhp_Producers_9-12', 'png');
    
    saveas(f10, 'bhp_Producers_13-16', 'fig');
    saveas(f10, 'bhp_Producers_13-16', 'png');
    
    saveas(f11, 'bhp_Producers_17-20', 'fig');
    saveas(f11, 'bhp_Producers_17-20', 'png');
end

%% Plot Producer Wells' Oil Rate

FieldOilProdRate_hf = zeros(numel(T), 1);
FieldOilProdRate_tpwl = zeros(numel(T), 1);
FieldOilProdRate_tpwl_pod = zeros(numel(T), 1);

f12 = figure(12);
f12.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Óleo nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Oil Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 1:4
    name = names{i};

    qOs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qOs', name)), stb/day);
    qOs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qOs', name)), stb/day);
    qOs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qOs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qOs_P_hf, 'k', 'linewidth', 2)
    plot(T, qOs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qOs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
            
    FieldOilProdRate_hf = FieldOilProdRate_hf + qOs_P_hf;
    FieldOilProdRate_tpwl = FieldOilProdRate_tpwl + qOs_P_tpwl;
    FieldOilProdRate_tpwl_pod = FieldOilProdRate_tpwl_pod + qOs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');  
    
    k = k + 1;
end

f13 = figure(13);
f13.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Óleo nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Oil Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 5:8
    name = names{i};

    qOs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qOs', name)), stb/day);
    qOs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qOs', name)), stb/day);
    qOs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qOs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qOs_P_hf, 'k', 'linewidth', 2)
    plot(T, qOs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qOs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
            
    FieldOilProdRate_hf = FieldOilProdRate_hf + qOs_P_hf;
    FieldOilProdRate_tpwl = FieldOilProdRate_tpwl + qOs_P_tpwl;
    FieldOilProdRate_tpwl_pod = FieldOilProdRate_tpwl_pod + qOs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f14 = figure(14);
f14.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Óleo nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Oil Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 9:12
    name = names{i};

    qOs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qOs', name)), stb/day);
    qOs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qOs', name)), stb/day);
    qOs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qOs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qOs_P_hf, 'k', 'linewidth', 2)
    plot(T, qOs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qOs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
            
    FieldOilProdRate_hf = FieldOilProdRate_hf + qOs_P_hf;
    FieldOilProdRate_tpwl = FieldOilProdRate_tpwl + qOs_P_tpwl;
    FieldOilProdRate_tpwl_pod = FieldOilProdRate_tpwl_pod + qOs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f15 = figure(15);
f15.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Óleo nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Oil Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 13:16
    name = names{i};

    qOs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qOs', name)), stb/day);
    qOs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qOs', name)), stb/day);
    qOs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qOs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qOs_P_hf, 'k', 'linewidth', 2)
    plot(T, qOs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qOs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
            
    FieldOilProdRate_hf = FieldOilProdRate_hf + qOs_P_hf;
    FieldOilProdRate_tpwl = FieldOilProdRate_tpwl + qOs_P_tpwl;
    FieldOilProdRate_tpwl_pod = FieldOilProdRate_tpwl_pod + qOs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f16 = figure(16);
f16.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Óleo nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Oil Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 17:20
    name = names{i};

    qOs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qOs', name)), stb/day);
    qOs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qOs', name)), stb/day);
    qOs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qOs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qOs_P_hf, 'k', 'linewidth', 2)
    plot(T, qOs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qOs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
            
    FieldOilProdRate_hf = FieldOilProdRate_hf + qOs_P_hf;
    FieldOilProdRate_tpwl = FieldOilProdRate_tpwl + qOs_P_tpwl;
    FieldOilProdRate_tpwl_pod = FieldOilProdRate_tpwl_pod + qOs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

if (opt.saveFig)
    saveas(f12, 'qOs_Producers_1-4', 'fig');
    saveas(f12, 'qOs_Producers_1-4', 'png');
    
    saveas(f13, 'qOs_Producers_5-8', 'fig');
    saveas(f13, 'qOs_Producers_5-8', 'png');
    
    saveas(f14, 'qOs_Producers_9-12', 'fig');
    saveas(f14, 'qOs_Producers_9-12', 'png');
    
    saveas(f15, 'qOs_Producers_13-16', 'fig');
    saveas(f15, 'qOs_Producers_13-16', 'png');
    
    saveas(f16, 'qOs_Producers_17-20', 'fig');
    saveas(f16, 'qOs_Producers_17-20', 'png');
end

%% Plot Producer Wells' Water Rate

FieldWaterProdRate_hf = zeros(numel(T),1);
FieldWaterProdRate_tpwl = zeros(numel(T),1);
FieldWaterProdRate_tpwl_pod = zeros(numel(T),1);

f17 = figure(17);
f17.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 1:4
    name = names{i};
    
    qWs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qWs', name)), stb/day);
    qWs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qWs', name)), stb/day);
    qWs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qWs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qWs_P_hf, 'k', 'linewidth', 2)
    plot(T, qWs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qWs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
           
    FieldWaterProdRate_hf = FieldWaterProdRate_hf + qWs_P_hf;
    FieldWaterProdRate_tpwl = FieldWaterProdRate_tpwl + qWs_P_tpwl;
    FieldWaterProdRate_tpwl_pod = FieldWaterProdRate_tpwl_pod + qWs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f18 = figure(18);
f18.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 5:8
    name = names{i};
    
    qWs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qWs', name)), stb/day);
    qWs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qWs', name)), stb/day);
    qWs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qWs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qWs_P_hf, 'k', 'linewidth', 2)
    plot(T, qWs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qWs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
           
    FieldWaterProdRate_hf = FieldWaterProdRate_hf + qWs_P_hf;
    FieldWaterProdRate_tpwl = FieldWaterProdRate_tpwl + qWs_P_tpwl;
    FieldWaterProdRate_tpwl_pod = FieldWaterProdRate_tpwl_pod + qWs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');  
    
    k = k + 1;
end

f19 = figure(19);
f19.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 9:12
    name = names{i};
    
    qWs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qWs', name)), stb/day);
    qWs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qWs', name)), stb/day);
    qWs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qWs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qWs_P_hf, 'k', 'linewidth', 2)
    plot(T, qWs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qWs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
           
    FieldWaterProdRate_hf = FieldWaterProdRate_hf + qWs_P_hf;
    FieldWaterProdRate_tpwl = FieldWaterProdRate_tpwl + qWs_P_tpwl;
    FieldWaterProdRate_tpwl_pod = FieldWaterProdRate_tpwl_pod + qWs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f20 = figure(20);
f20.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 13:16
    name = names{i};
    
    qWs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qWs', name)), stb/day);
    qWs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qWs', name)), stb/day);
    qWs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qWs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qWs_P_hf, 'k', 'linewidth', 2)
    plot(T, qWs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qWs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
           
    FieldWaterProdRate_hf = FieldWaterProdRate_hf + qWs_P_hf;
    FieldWaterProdRate_tpwl = FieldWaterProdRate_tpwl + qWs_P_tpwl;
    FieldWaterProdRate_tpwl_pod = FieldWaterProdRate_tpwl_pod + qWs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');
    
    k = k + 1;
end

f21 = figure(21);
f21.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Vazão de Produção de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Rate for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 17:20
    name = names{i};
    
    qWs_P_hf = convertTo(abs(getWellOutput(wellSolsHF, 'qWs', name)), stb/day);
    qWs_P_tpwl = convertTo(abs(getWellOutput(wellSolsTPWL, 'qWs', name)), stb/day);
    qWs_P_tpwl_pod = convertTo(abs(getWellOutput(wellSolsTPWLPOD, 'qWs', name)), stb/day);

    subplot(2, 2, k)
    hold on
    plot(T, qWs_P_hf, 'k', 'linewidth', 2)
    plot(T, qWs_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, qWs_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    end
           
    FieldWaterProdRate_hf = FieldWaterProdRate_hf + qWs_P_hf;
    FieldWaterProdRate_tpwl = FieldWaterProdRate_tpwl + qWs_P_tpwl;
    FieldWaterProdRate_tpwl_pod = FieldWaterProdRate_tpwl_pod + qWs_P_tpwl_pod;
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');  
    
    k = k + 1;
end

if (opt.saveFig)
    saveas(f17, 'qWs_Producers_1-4', 'fig');
    saveas(f17, 'qWs_Producers_1-4', 'png');
    
    saveas(f18, 'qWs_Producers_5-8', 'fig');
    saveas(f18, 'qWs_Producers_5-8', 'png');
    
    saveas(f19, 'qWs_Producers_9-12', 'fig');
    saveas(f19, 'qWs_Producers_9-12', 'png');
    
    saveas(f20, 'qWs_Producers_13-16', 'fig');
    saveas(f20, 'qWs_Producers_13-16', 'png');
    
    saveas(f21, 'qWs_Producers_17-20', 'fig');
    saveas(f21, 'qWs_Producers_17-20', 'png');
end

%% Plot Producer Wells' Water Cut

f22 = figure(22);
f22.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Corte de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Cut for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 1:4
    name = names{i};
    
    wc_P_hf = abs(getWellOutput(wellSolsHF, 'wcut', name));
    wc_P_tpwl = abs(getWellOutput(wellSolsTPWL, 'wcut', name));
    wc_P_tpwl_pod = abs(getWellOutput(wellSolsTPWLPOD, 'wcut', name));

    subplot(2, 2, k)
    hold on
    plot(T, wc_P_hf, 'k', 'linewidth', 2)
    plot(T, wc_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, wc_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Corte de Água','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Water Cut','FontSize',18,'FontWeight','bold','Color','k')
    end
        
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');  
    
    k = k + 1;
end

f23 = figure(23);
f23.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Corte de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Cut for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 5:8
    name = names{i};
    
    wc_P_hf = abs(getWellOutput(wellSolsHF, 'wcut', name));
    wc_P_tpwl = abs(getWellOutput(wellSolsTPWL, 'wcut', name));
    wc_P_tpwl_pod = abs(getWellOutput(wellSolsTPWLPOD, 'wcut', name));

    subplot(2, 2, k)
    hold on
    plot(T, wc_P_hf, 'k', 'linewidth', 2)
    plot(T, wc_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, wc_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Corte de Água','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Water Cut','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f24 = figure(24);
f24.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Corte de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Cut for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 9:12
    name = names{i};
    
    wc_P_hf = abs(getWellOutput(wellSolsHF, 'wcut', name));
    wc_P_tpwl = abs(getWellOutput(wellSolsTPWL, 'wcut', name));
    wc_P_tpwl_pod = abs(getWellOutput(wellSolsTPWLPOD, 'wcut', name));

    subplot(2, 2, k)
    hold on
    plot(T, wc_P_hf, 'k', 'linewidth', 2)
    plot(T, wc_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, wc_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Corte de Água','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Water Cut','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best'); 
    
    k = k + 1;
end

f25 = figure(25);
f25.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Corte de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Cut for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 13:16
    name = names{i};
    
    wc_P_hf = abs(getWellOutput(wellSolsHF, 'wcut', name));
    wc_P_tpwl = abs(getWellOutput(wellSolsTPWL, 'wcut', name));
    wc_P_tpwl_pod = abs(getWellOutput(wellSolsTPWLPOD, 'wcut', name));

    subplot(2, 2, k)
    hold on
    plot(T, wc_P_hf, 'k', 'linewidth', 2)
    plot(T, wc_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, wc_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Corte de Água','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Water Cut','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');    
    
    k = k + 1;
end

f26 = figure(26);
f26.WindowState = 'maximized';
if (strcmp(opt.lang, 'pt-br'))
    suptitle('Corte de Água nos Poços Produtores')
elseif (strcmp(opt.lang, 'eng'))
    suptitle('Water Cut for the Producer Wells')
end
k = 1;
set(gca,'FontSize',18)
for i = 17:20
    name = names{i};
    
    wc_P_hf = abs(getWellOutput(wellSolsHF, 'wcut', name));
    wc_P_tpwl = abs(getWellOutput(wellSolsTPWL, 'wcut', name));
    wc_P_tpwl_pod = abs(getWellOutput(wellSolsTPWLPOD, 'wcut', name));

    subplot(2, 2, k)
    hold on
    plot(T, wc_P_hf, 'k', 'linewidth', 2)
    plot(T, wc_P_tpwl, 'r--o', 'linewidth', 2);
    plot(T, wc_P_tpwl_pod, 'b--s', 'linewidth', 2);
    hold off   
    title(name)
    axis tight
    grid on
    box on

    if (strcmp(opt.lang, 'pt-br'))
        xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Corte de Água','FontSize',18,'FontWeight','bold','Color','k')
    elseif (strcmp(opt.lang, 'eng'))
        xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
        ylabel('Water Cut','FontSize',18,'FontWeight','bold','Color','k')
    end
    
    legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');  
    
    k = k + 1;
end

if (opt.saveFig)
    saveas(f22, 'wc_Producers_1-4', 'fig');
    saveas(f22, 'wc_Producers_1-4', 'png');
    
    saveas(f23, 'wc_Producers_5-8', 'fig');
    saveas(f23, 'wc_Producers_5-8', 'png');
    
    saveas(f24, 'wc_Producers_9-12', 'fig');
    saveas(f24, 'wc_Producers_9-12', 'png');
    
    saveas(f25, 'wc_Producers_13-16', 'fig');
    saveas(f25, 'wc_Producers_13-16', 'png');
    
    saveas(f26, 'wc_Producers_17-20', 'fig');
    saveas(f26, 'wc_Producers_17-20', 'png');
end

%% Field Production Oil Rate

f27 = figure(27);
f27.WindowState = 'maximized';
hold on
plot(T, FieldOilProdRate_hf, 'k', 'linewidth', 2)
plot(T, FieldOilProdRate_tpwl, 'r--o', 'linewidth', 2)
plot(T, FieldOilProdRate_tpwl_pod, 'b--s', 'linewidth', 2)
hold off
set(gca,'FontSize',18)
legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');
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
    saveas(f27, 'qOs_Field', 'fig');
    saveas(f27, 'qOs_Field', 'png');
end

%% Field Production Water Rate

f28 = figure(28);
f28.WindowState = 'maximized';
hold on
plot(T, FieldWaterProdRate_hf, 'k', 'linewidth', 2)
plot(T, FieldWaterProdRate_tpwl, 'r--o', 'linewidth', 2)
plot(T, FieldWaterProdRate_tpwl_pod, 'b--s', 'linewidth', 2)
hold off
set(gca,'FontSize',18)
legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');
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
    saveas(f28, 'qWs_Field', 'fig');
    saveas(f28, 'qWs_Field', 'png');
end

%% Field Production Liquid Rate

f29 = figure(29);
f29.WindowState = 'maximized';
hold on
plot(T, FieldOilProdRate_hf + FieldWaterProdRate_hf, 'k', 'linewidth', 2)
plot(T, FieldOilProdRate_tpwl + FieldWaterProdRate_tpwl, 'r--o', 'linewidth', 2)
plot(T, FieldOilProdRate_tpwl_pod + FieldWaterProdRate_tpwl_pod, 'b--s', 'linewidth', 2)
hold off
set(gca,'FontSize',18)
legend('MRST', 'TPWL', 'TPWL-POD', 'Location', 'Best');
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
    saveas(f29, 'qTs_Field', 'fig');
    saveas(f29, 'qTs_Field', 'png');
end

if opt.closeFig
    close all;
end

%% Error Computation

% Oil Production Error
oilErr_tpwl = 100*sum(abs(FieldOilProdRate_hf - FieldOilProdRate_tpwl))/sum(FieldOilProdRate_hf);
oilErr_tpwl_pod = 100*sum(abs(FieldOilProdRate_hf - FieldOilProdRate_tpwl_pod))/sum(FieldOilProdRate_hf);

% Water Production Error
watProdErr_tpwl = 100*sum(abs(FieldWaterProdRate_hf - FieldWaterProdRate_tpwl))/sum(FieldWaterProdRate_hf);
watProdErr_tpwl_pod = 100*sum(abs(FieldWaterProdRate_hf - FieldWaterProdRate_tpwl_pod))/sum(FieldWaterProdRate_hf);

% Water Injection Error
watInjErr_tpwl = 100*sum(abs(FieldWaterInjRate_hf - FieldWaterInjRate_tpwl))/sum(FieldWaterInjRate_hf);
watInjErr_tpwl_pod = 100*sum(abs(FieldWaterInjRate_hf - FieldWaterInjRate_tpwl_pod))/sum(FieldWaterInjRate_hf);

f30 = figure(30);
f30.WindowState = 'maximized';
hold on
c = categorical({'Eo (TPWL)','Ewpro (TPWL)','Ewinj (TPWL)'; ...
            'Eo (TPWL/POD)','Ewpro (TPWL/POD)','Ewinj (TPWL/POD)'});
bar(c, [oilErr_tpwl, watProdErr_tpwl, watInjErr_tpwl; oilErr_tpwl_pod, watProdErr_tpwl_pod, watInjErr_tpwl_pod]);
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
    saveas(f30, 'error_comp', 'fig');
    saveas(f30, 'error_comp', 'png');
end

fprintf('Oil Production Error (MRST vs. TPWL): %.5f \n', oilErr_tpwl);
fprintf('Oil Production Error (MRST vs. TPWL/POD): %.5f \n', oilErr_tpwl_pod);

fprintf('Water Production Error (MRST vs. TPWL): %.5f \n', watProdErr_tpwl);
fprintf('Water Production Error (MRST vs. TPWL/POD): %.5f \n', watProdErr_tpwl_pod);

fprintf('Water Injection Error (MRST vs. TPWL): %.5f \n', watInjErr_tpwl);
fprintf('Water Injection Error (MRST vs. TPWL/POD): %.5f \n', watInjErr_tpwl_pod);

end

