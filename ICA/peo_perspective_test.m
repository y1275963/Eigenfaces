
% Decomposion using ICA
clear;
imgsize = [112,92];

data = imagedata(40,3);
sbase = fastica(data', 'numOfIC', 80, 'displayMode', 'off', 'verbose', 'off'); 
    for ii = 1 : 80
        reversev = sbase(ii, :);
        maxpick = max(reversev);
        minpick = min(reversev);
        avgpick = mean(reversev);

        if(abs(avgpick - maxpick) > abs(avgpick - minpick))
            sbase(ii, :) = -reversev;
        end
    end
    
inv_sbase = pinv(sbase);

%% different people

% show original
testdata = imagedata(10, 1);
peekbase(testdata, imgsize, 5, 2);

% reconstruct
w = testdata' * inv_sbase;

% show weights
figure()
hold on 
legend()
for i = 1: 10
    plot(w(i, :));
end

% show reconstruct
reconstr = w * sbase;
peekbase(reconstr', imgsize, 5, 2);

%% Different perspective

% show original
testdata = imagedata(1, 10);
peekbase(testdata, imgsize, 5, 2);

% reconstruct
w = testdata' * inv_sbase;

% show weights
figure()
hold on 
legend()
for i = 1: 10
    plot(w(i, :));
end

% show reconstruct
reconstr = w * sbase;
peekbase(reconstr', imgsize, 5, 2);




