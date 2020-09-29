function tamanho = lengthTrace(trace)

tamanho=0;
for i=1:length(trace)-1

    t = trace(i,:)-trace(i+1,:);
    
    tamanho = tamanho + sqrt(sum(t.^2));
end
