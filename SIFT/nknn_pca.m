% kd forest
warning('off','all')
clear 
    
ratiorange = 3:1:8;
locrange = 0.4:0.1:1;


ori_imgsize = [112,92]; 
numofpeople = 40;
numofperspective = 10;
sam_image = imagedata2(1,1);
sam_image = reshape(sam_image, ori_imgsize);

resol_res = [];
for imgratio = 1 : length(locrange)
locrange(imgratio)

test_peo = cell(0);
forest = cell(0);
performence = [];
imgsize = size(imresize(sam_image,locrange(imgratio)));
[~, sift_pca_avg, sift_pca_vector, ~] = sift_pca_base(20, imgsize);
for iter = ratiorange
    parfor peoi = 1 : numofpeople
        trs = randperm(numofperspective);

        train_people = imagedata2(peoi, trs(1 : iter)); % training sample for class peoi
        test_people = imagedata2(peoi, iter+1 : numofperspective);
        test_peo{peoi} = test_people;
        % shuffle
        perm1 = randperm(size(train_people,2));
        train_people = train_people(:, perm1);

        % exploit SIFT descriptor 
        d_all = [];
        for item = 1:size(train_people,2)
            peo = train_people(:, item);
            peo = calibrate_img(peo, ori_imgsize);
            peo = imresize(peo, imgsize);

            cloc = vl_sift(peo);
            raw_patch = sift_patches(peo, cloc);
            d = sift_pca_projection(raw_patch, sift_pca_vector, sift_pca_avg);
            
            d_all = [d_all, d];
        end

        %construct current kdtree
        peoi_tree = KDTreeSearcher(d_all');
        forest{peoi} = peoi_tree;
    end
    
    re = cell(0);
    
    % testing on the samples
    parfor peoi = 1 : numofpeople
        cur_test = test_peo{peoi};
        
        ans = []; % should be a length of 5 vector
        % test each people
        for item = 1 : size(cur_test,2)
            peo = cur_test(:, item);
            peo = calibrate_img(peo, ori_imgsize);
            peo = imresize(peo, imgsize);

            [cloc, ~] = vl_sift(peo);
            raw_patch = sift_patches(peo, cloc);
            d = sift_pca_projection(raw_patch, sift_pca_vector, sift_pca_avg);
            
            d_list = [];
            for tree = 1:length(forest)
                dis_all = 0;

                for ditem = 1 : size(d, 2)
                    [~, dis] = knnsearch(forest{tree}, d(:, ditem)');
                    dis_all = dis_all + dis;
                end
                
                d_list = [d_list, dis_all];
            end
            [~, Idx] = min(d_list);
            
            ans = [ans, Idx];
        end
        re{peoi} = ans;     
    end
     % report results
    retest = cell2mat(re');
    result = [];
    for i = 1 : numofpeople
        result(i,:) = retest(i,:) - i;
    end
    [sx, sy] = size(result);
    performence = [performence, 1 - length(find(result ~= 0))/(sx*sy)];
end
resol_res = [resol_res;performence];
    

end

