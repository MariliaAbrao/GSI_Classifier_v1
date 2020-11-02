clear all; close all;clc;


tic

% Divisor: numero de partes em que as entradas faixas estao dvididas (usual 12 ou 6)
divisor = 12;

% diretorio = ['G:\Meu Drive\Workana\Andamento\Marilia - Doutorado - Processamente Cloud Point e ANN\Todos os traços'];
diretorio = ['G:\Meu Drive\Workana\Andamento\Marilia - Doutorado - Processamente Cloud Point e ANN\Todos os traços'];
files = dir(strcat(diretorio));

% quantidade de arquivos
n = length(files);

i=1;
% Loop passando por todos os arquivos
for ii=3:n
    
    
    
    if ~strcmp(files(ii).name,'desktop.ini')
        
        % Status run
        disp(['Processando dados: ',num2str(i),'/',num2str(n-2),' File: ',files(ii).name]);
        
        
        %     figure()
        %     pcshow(pcXYZ,pcRGB)
        %     hold on
        %
        %     %%
        %     pcXYZ{i} = data(1:end,1:3);
        %     pcRGB{i} = uint8(data(1:end,4:6));
        %
        %     pc = pointCloud(pcXYZ{i},'Color',pcRGB{i});
        
        
        
        trace{i} =importfileCSV([diretorio '\' files(ii).name]);
        
        %         pctrace = pointCloud(trace{i}(:,3:5));
        %         pcshow(pctrace)
        
        pause(0.01)
        
        s{i,1} = featuresTrace(trace{i},divisor);
        
        s{i,2} = files(ii).name;
        hold off
        
        if files(ii).name(1:4) == 'torr'  
            s{i,1} = [s{i,1} 1 0 0 0];
        elseif files(ii).name(1:4) == 'noos' 
            s{i,1} = [s{i,1} 0 1 0 0];
        elseif files(ii).name(1:4) == 'caja'  
            s{i,1} = [s{i,1} 0 0 1 0];
        elseif files(ii).name(1:4) == 'fida'
            s{i,1} = [s{i,1} 0 0 0 1];
        else
            s{i,1} = [s{i,1} 0 1 0 0];
        end
        
        if files(ii).name(end-7:end-4) == 'test'
            s{i,3} = 'test';
%         elseif files(ii).name(end-7:end-4) == 'trai'
%             s{i,3} = 'train';
        else
            s{i,3} = 'train';
        end
        
        i = i+1;
    end
    
    
    
%     title(files(ii).name)
%     close all;
end


tempo = toc


% save('caracteristicaTodosTraços.mat','s','tempo');
save('caracteristicaTodosTraços.mat','s','tempo');


