function [perc,avg,pvector,D] = opca(k, data)
% Calculate the most important vectors accroding to PCA princial
% perc: the percentage of selected eigenvalues
% avg: the average face
% pvector: the selected eigenvectors
% data: the image data, 1 per column
imgsize = [112,92]; 
% data = imagedata();

avg = mean(data,2);
A = data - avg*ones(1, 400); % Centered at zero
L = A'*A;
[V,D] = eig(L);
% V: the decomposed eigenvectors, one per column associated with
% eigenvalues in D, need apply: A*vector


eigenvalues = eig(L);
perc = sum(eigenvalues(end-k+1:end))/sum(eigenvalues);
vector = V(:,end-k+1:end);
pvector = A*vector;

% Start normalization
for i = 1:k
    pvector(:,i) = pvector(:,i)./norm(pvector(:,i));
end
return 