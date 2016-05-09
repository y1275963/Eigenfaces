function c = sift_dim(k) %detector location based on 100 people

imgs = imagedata2(1:40, 1:10);
imgsize = [112,92]; 

fcontainer = cell(0);
dcontainer = cell(0);

pl = [];

for ii = 1:100 % first 100 samples
    peo = imgs(:, ii);
    
    peo = im2single(peo./255);
    peo = reshape(peo, imgsize);
    
    [f, d] = vl_sift(peo);
    fcontainer{ii} = f;
    
    pl = [pl, size(f,2)];
end

% get center
fmat = cell2mat(fcontainer);
% scatter3(fmat(1,:), fmat(2,:), fmat(3,:));

opts = statset('Display','final');
[idx, c] = kmeans(fmat', k,'Replicates',5, 'Options', opts); % k is arbitary

c = c';

