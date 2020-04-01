function  x0 = P_inicial(encopt_mrst)

% numero de poços produtores
num_prod=encopt_mrst.producer_well;


% numero de poços injetores  
num_inj=encopt_mrst.injetor_well;


% numero total de poços 
t_pocos=encopt_mrst.nwell;

% ingresar numero de pasos de controle (ciclos de controle)
control_steps=encopt_mrst.nc;
                  
                                      % Se 1 = PONOT INICIAL POR CONTROLE 
tipo_de_media=encopt_mrst.p_inicial;  % Se 2 = PONTO INICIAL POR POÇO
                                      % Se 3 = PONTO INICIAL INFORMADO PELO USUARIO
                                

if tipo_de_media == 1                                   
    % média entre os limites de controle
    m_prod=lim_lower_prod + (lim_upper_prod-lim_lower_prod).*rand(control_steps,num_prod);
    m_inj=lim_lower_inj + (lim_upper_inj-lim_lower_inj).*rand(control_steps,num_inj);
    media_inicial=(reshape([m_prod,m_inj]',1,t_pocos*control_steps))';
    
    
    % falta levar matriz a vetor
    
elseif tipo_de_media == 2                              %  Media por controle
    % média entre os limites de controle
    m_prod=ones(control_steps,num_prod);
    m_inj=ones(control_steps,num_inj);

    for i = 1:num_prod

        m_prod(:,i)=(lim_lower_prod + (lim_upper_prod-lim_lower_prod)).*rand(1,1);

    end

    for i = 1:num_inj
        
        m_inj(:,i)=(lim_lower_inj + (lim_upper_inj-lim_lower_inj)).*rand(1,1);
        
    end
    media_inicial=(reshape([m_prod,m_inj]',1,t_pocos*control_steps))';    

else

   media_inicial=load(encopt_mrst.file_p_inicial);
   
end

x0=media_inicial;

end

