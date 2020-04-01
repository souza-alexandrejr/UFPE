function plotBruggeFieldLiquidProdOpt(wellSols, schedule, encopt_mrst, varargin)
% Plot Field Liquid Production Rate results in a single plot.
% Last update: 17/03/2020 - Developed by Alexandre de Souza Jr. (UFPE)
%
% SYNOPSIS:
%
%   plotBruggeFieldLiquidProdOpt(wellSols, schedule, encopt_mrst, varargin)
%
% DESCRIPTION:
%
%   This function plots Field Liquid Production Rate results from 
%   the Brugge model optimization and applied constraint in a single plot.
%
% REQUIRED PARAMETERS:
%
%   wellSols        - Well solution at each control step.
%
%   schedule        - Set of controls applied at simulation.
%
%   encopt_mrst     - Structure containing optimization data.
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
 
names = {'BR-P-1', 'BR-P-2', 'BR-P-3', 'BR-P-4', 'BR-P-5', 'BR-P-6', 'BR-P-7', ...
         'BR-P-8', 'BR-P-9', 'BR-P-10', 'BR-P-11', 'BR-P-12', 'BR-P-13', ...
         'BR-P-14', 'BR-P-15', 'BR-P-16', 'BR-P-17', 'BR-P-18', 'BR-P-19', ...
         'BR-P-20'};
     
nn = numel(names);

FieldWaterRate = zeros(numel(T),1);
FieldOilRate = zeros(numel(T),1);

for j = 1:nn
    name = names{j};
    FieldWaterRate = FieldWaterRate + convertTo(abs(getWellOutput(wellSols, 'qWs', name)), stb/day);
    FieldOilRate = FieldOilRate + convertTo(abs(getWellOutput(wellSols, 'qOs', name)), stb/day);
end

FieldLiquidRate = FieldOilRate + FieldWaterRate;

f1 = figure(1);
hold on
plot(T, FieldLiquidRate, '-r', 'linewidth', 2)
plot(T, repmat(encopt_mrst.Q_lprod, numel(T), 1), '--k', 'linewidth', 2)

if (strcmp(opt.lang, 'pt-br'))
    xlabel('Tempo (anos)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Vazão (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    title('Vazão de Produção Líquida do Campo','FontSize',18,'FontWeight','bold','Color','k')
elseif (strcmp(opt.lang, 'eng'))
    xlabel('Time (years)','FontSize',18,'FontWeight','bold','Color','k')
    ylabel('Rate (stb/d)','FontSize',18,'FontWeight','bold','Color','k')
    title('Field Liquid Production Rate','FontSize',18,'FontWeight','bold','Color','k')
end
    
set(gca,'FontSize',18)
axis tight
grid on
box on
hold off

if (opt.saveFig)
    saveas(f1, 'qTs_Field', 'fig');
    saveas(f1, 'qTs_Field', 'png');
end

if (opt.closeFig)
    close all;
end

end

