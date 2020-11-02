function s = featuresTrace(trace,divisor)

%% Carregamento Traços CloudCompare
%
% Colunas: 1. Trace_id
%          2. Point_id
%          3. Start_x
%          4. Start_y
%          5. Start_z
%          6. End_x
%          7. End_y
%          8. End_z
%          9. Cost
%          10.Cost_Mode

% Gera point cloud dos traços
pctrace = pointCloud(trace(:,3:5));

% extrai ID dos traços
ntrace = unique(trace(:,1));

%% quantidade de traços
qtrace = length(ntrace);

%% laço de repetição por traço
indices=0;
for ii=1:qtrace
    indices = find(trace(:,1)==ntrace(ii));
    
    trace1 = trace(indices,3:5);
    
    t(ii) = lengthTrace(trace1);
end
% media tamanho traço
mediat = mean(t);

% soma dos tamanhos traço
somat  = sum(t);

%% vetor com quantidade de cruzamento entre os traços e angulo entre os cruzamentos
[ncross  ang f] = crossTrace(trace,pctrace,divisor);

% media de cruzamento entre os tracos
mediac = mean(ncross);

% soma de cruzamento entre os tracos dividido por 2 para retirar as duplicatas
somac = sum(ncross)/2;




s(1) = qtrace;  % qnt de traços
s(2) = mediat;  % media do tamanho    
s(3) = somat;   % soma do tamanho
s(4) = mediac;  % media cruzamento entre traços
s(5) = somac;   % soma cruzamento entre traços 
s(6) = ang;     % orientação media

% faixas
for idiv=1:divisor
    s(6+idiv) = f(idiv);
end

% s(7) = f(1);     % Faixa 1 = de 0 a 15 e de 165 a 180
% s(8) = f(2);     % Faixa 2 = de 15 a 45
% s(9) = f(3);     % Faixa 3 = de 45 a 75
% s(10) = f(4);     % Faixa 4 = de 75 a 105
% s(11) = f(5);     % Faixa 5 = de 105 a 135
% s(12) = f(6);     % Faixa 6 = de 135 a 165
% s(13) = f(7);     % Faixa 6 = de 135 a 165
% s(14) = f(8);     % Faixa 6 = de 135 a 165
% s(15) = f(9);     % Faixa 6 = de 135 a 165
% s(16) = f(10);     % Faixa 6 = de 135 a 165
% s(17) = f(11);     % Faixa 6 = de 135 a 165
% s(18) = f(12);     % Faixa 6 = de 135 a 165

end





