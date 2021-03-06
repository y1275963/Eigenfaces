function [re, idx] = rankaccto(input, base, rule)

% input should rearranged in row per obversation manner


% construct disance
dis_array = zeros(size(input,1),1);
for item = 1:size(input,1)
    comp = [input(item,:);base];
    dis = pdist(comp,rule);
    
    dis_array(item) = dis;   
end

%append
input = [dis_array, input];

%rank 
[re, idx] = sortrows(input);

%recovery
re(:,1) = [];

