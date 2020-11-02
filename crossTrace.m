function [ncross nang f] = crossTrace(traces,pctrace,divisor)

ncross = 0;

% extrai ID dos traços
ntrace = unique(traces(:,1));

% quantidade de traços
qtrace = length(ntrace);

% define radio de busca de vizinhos
dx = pctrace.XLimits(2)-pctrace.XLimits(1);
dy = pctrace.YLimits(2)-pctrace.YLimits(1);
dz = pctrace.ZLimits(2)-pctrace.ZLimits(1);
r  = sqrt(dx^2+dy^2+dz^2)*0.005;

%% Calculo do angulo de cada traço
% define e retira eixo com meno variação transformando nuvem de pontos em um conjunto 2d
if (dx < dy && dx < dz)
    angtrace = traces(:,[1 4:5]);
elseif (dy < dx && dy < dz)
    angtrace = traces(:,[1 3 5]);
elseif (dz < dx && dz < dy)
    angtrace = traces(:,[1 3:4]);
end

% figure()
% plot(angtrace(:,2),angtrace(:,3),'b.')
% hold on


f = zeros(1,divisor);
% calculo angulo
for i=1:qtrace
    
    % separa traço a ser analisado
    ind = find(angtrace(:,1)==ntrace(i));
    trace2 = angtrace(ind,2:3);
    
    % REgressão linear
    [p S]   = polyfit(trace2(:,1),trace2(:,2),1);
    [p1 S1] = polyfit(trace2(:,2),trace2(:,1),1);
    %     disp(S.normr)
    
    inverte = 0;
    if (S1.normr<S.normr)
        p = p1;
        inverte =1;
        %         disp(S1.normr)
    end
    
    
    
    
    
    if inverte ==0
        x1 = [min(trace2(:,1)):0.0001:max(trace2(:,1))];
        y1 = p(1)*x1 + p(2);
    else
        y1 = [min(trace2(:,2)):0.0001:max(trace2(:,2))];
        x1 = p(1)*y1 + p(2);
    end
    
    %     plot(x1,y1,'r.');
    
    % Converte coificiente angular em radianos
    if inverte ==0
        ang(i) = atan(p(1));
    else
        ang(i) = atan(p(1));
        ang(i) = pi()/2-ang(i);
    end
    
    % caso o angulo seja negativo é utilizado sem complementar para que
    % seque se trabalhe entre 0 e pi() (0º e 180º)
    if (ang(i))<0
        ang(i) = pi()+ang(i);
    end
    
    
    % faixas de angulo
    for idiv=1:divisor
        
        if idiv == 1
            if ((ang(i) >= 0) && (ang(i) <= pi()/(divisor*2)*1))
                f(1) = f(1)+1;
            elseif ((ang(i) > pi()*(1-1/(divisor*2))) && (ang(i) <= pi()))
                f(1) = f(1)+1;
            end
        else
            if ((ang(i) >= pi()/(divisor*2)*(2*idiv-3)) && (ang(i) < pi()/(divisor*2)*(2*idiv-1)))
                f(idiv) = f(idiv)+1;
            end
        end
    end
    
%     if ((ang(i) >= pi()/divisor*1) && (ang(i) < pi()/divisor*3))
%         f(2) = f(2)+1;
%     elseif ang(i) < pi()/divisor*5
%         f(3) = f(3)+1;
%     elseif ang(i) < pi()/divisor*7
%         f(4) = f(4)+1;
%     elseif ang(i) < pi()/divisor*9
%         f(5) = f(5)+1;
%     elseif ang(i) < pi()/divisor*11
%         f(6) = f(6)+1;
%     elseif ang(i) < pi()/divisor*13
%         f(7) = f(7)+1;
%     elseif ang(i) < pi()/divisor*15
%         f(8) = f(8)+1;
%     elseif ang(i) < pi()/24*17
%         f(9) = f(9)+1;
%     elseif ang(i) < pi()/24*19
%         f(10) = f(10)+1;
%     elseif ang(i) < pi()/24*21
%         f(11) = f(11)+1;
%     elseif ang(i) < pi()/24*23
%         f(12) = f(12)+1;
%     else
%         f(1) = f(1)+1;
%     end
    
end

hold off



cont=1;
dang = [];
% Percorre todos os traços do conjunto traces
for j=1:qtrace
    
    idntrace = [];
    
    % separa traço "j" do conjunto
    ind = find(traces(:,1)==ntrace(j));
    trace = traces(ind,3:5);
    
    % numero de pontos do traço "j"
    n = length(trace);
    
    % faz busca radial pelo traço em busca de visinhos
    for i=1:n
        
        [indices ~] = findNeighborsInRadius(pctrace,trace(i,:),r); % Vizinhos segundo busca radial
        
        
        % verifica se indice dos vizinhos é diferente do ID do traço "j" em analise
        for ii=1:length(indices)
            
            if (traces(indices(ii),1)~=ntrace(j))
                
                idntrace = [idntrace traces(indices(ii),1)];
            end
        end
        
    end
    
    uniqueIdntrace = unique(idntrace);
    if ~isempty(uniqueIdntrace)
        for ii=1:length(uniqueIdntrace)
            auxind = find(ntrace==uniqueIdntrace(ii)); % busca indice do ID refenteao traço em analise
            
            dang2{j}(ii) =  ang(j) - ang(auxind);
            
            if isempty(find(ntrace(1:j)==uniqueIdntrace(ii)))
                dang = [dang abs(ang(j) - ang(auxind))];
            end
        end
    else
        dang2{j}(1) = 0;
        
    end
    
    % conta qnt de vizinhos encontrados e salva no vetor ncross
    %     disp(['traço: ',num2str(ntrace(j)),', Angulo: ',num2str(ang(j)),'(',num2str((ang(j)*360)/(2*pi())),'), Vizihnos: ',num2str(unique(idntrace))])
    ncross(j) = length(unique(idntrace));
    %ncross(j,2) = ntrace(j);
    
    
end

% se não houver cuzamentos entao o angulo de saida é zero
if isempty(dang)
    dang = 0;
end

% Atribui saida
nang = mean(dang);
% disp(num2str(dang))
% disp(num2str((dang*360)/(2*pi())))
