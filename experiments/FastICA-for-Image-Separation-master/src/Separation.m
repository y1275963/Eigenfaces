
clear 
  
imgsize = [112,92]; 

im1 = imread('cameraman.tif');
im1 = imresize(im1, imgsize);
im2 = imread('moon.tif');
im2 = imresize(im2, imgsize);
im3 = imread('AT3_1m4_06.tif');
im3 = imresize(im3, imgsize);

imgs = [im2double(im1(:)), im2double(im2(:)), im2double(im3(:))];
        


    S = imgs';                           
    Sweight=rand(size(S,1));              
    MixedS=Sweight*S;       
    
    ms1=reshape(MixedS(1,:),imgsize); 
    ms2=reshape(MixedS(2,:),imgsize); 
    ms3=reshape(MixedS(3,:),imgsize); 
    
    subplot(3,3,4),imshow(ms1, []),title('Mixed1'), 
    subplot(3,3,5),imshow(ms2, []),title('Mixed2'), 
    subplot(3,3,6),imshow(ms3, []),title('Mixed3'), 
    MixedS_bak=MixedS;                         
    MixedS_mean=zeros(3,1); 
    for i=1:3 
        MixedS_mean(i)=mean(MixedS(i,:)); 
    end                                        

    for i=1:3 
        for j=1:size(MixedS,2) 
            MixedS(i,j)=MixedS(i,j)-MixedS_mean(i); 
        end 
    end 
    
    MixedS_cov=cov(MixedS');                 
    [E,D]=eig(MixedS_cov);                   
    Q=inv(sqrt(D))*(E)'; 
    
    MixedS_white=Q*MixedS;                    
    IsI=cov(MixedS_white'); 
    
    X=MixedS_white;                            
    [VariableNum,SampleNum]=size(X); 
    numofIC=VariableNum;                       
    B=zeros(numofIC,VariableNum);               
    for r=1:numofIC                           
        i=1;maxIterationsNum=150;             
        b=2*(rand(numofIC,1)-.5);                   
        b=b/norm(b);                         
        while i<=maxIterationsNum+1 
           if i == maxIterationsNum           
                fprintf('No convergenceĦ£', r,maxIterationsNum); 
                break; 
            end 
            bOld=b;                           
            u=1; 
            t=X'*b; 
            g=t.^3; 
            dg=3*t.^2; 
            b=((1-u)*t'*g*b+u*X*g)/SampleNum-mean(dg)*b;     

            b=b-B*B'*b;                       
            b=b/norm(b);  
            if abs(abs(b'*bOld)-1)<1e-10      
                 B(:,r)=b;                  
                 break; 
             end 
            i=i+1;         
        end 
    end 
    ICAedS=B'*Q*MixedS_bak;                    
    ICAedS_bak=ICAedS; 
    ICAedS=abs(ICAedS); 
    
    is1=reshape(ICAedS(1,:),imgsize); 
    is2=reshape(ICAedS(2,:),imgsize); 
    is3=reshape(ICAedS(3,:),imgsize); 
 
subplot(3,3,7),imshow(is1, []),title('Restored1'); 
subplot(3,3,8),imshow(is2, []),title('Restored2');
subplot(3,3,9),imshow(is3, []),title('Restored3');

