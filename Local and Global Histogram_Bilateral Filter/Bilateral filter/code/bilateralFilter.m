clc;
clear;

% importing images
img1=imread("C:\Users\YASH\Desktop\Mtech stuff\image processsing CS-663\assignments\HW2-20230905T090756Z-001\HW2\barbara256.png");
img2=imread("C:\Users\YASH\Desktop\Mtech stuff\image processsing CS-663\assignments\HW2-20230905T090756Z-001\HW2\kodak24.png");

im1=double(img1);
im2=double(img2);

% making images noisy with deviation = 5
noise_deviation = 5;
noisyimage_1_1 = imnoise(img1,"gaussian",0,(noise_deviation/255)^2);
noisyimage_1_2 = imnoise(img2,"gaussian",0,(noise_deviation/255)^2);

% making images noisy with deviation = 19
noise_deviation = 10;
noisyimage_2_1 = imnoise(img1,"gaussian",0,(noise_deviation/255)^2);
noisyimage_2_2 = imnoise(img2,"gaussian",0,(noise_deviation/255)^2);

%applying filter
bp_1_1 = myBilateralFilter(noisyimage_1_1, 2, 2);
bp_1_2 = myBilateralFilter(noisyimage_1_2, 2, 2);
bp_1_3 = myBilateralFilter(noisyimage_2_1, 2, 2);
bp_1_4 = myBilateralFilter(noisyimage_2_2, 2, 2);

bp_2_1 = myBilateralFilter(noisyimage_1_1, 0.1, 0.1);
bp_2_2 = myBilateralFilter(noisyimage_1_2, 0.1, 0.1);
bp_2_3 = myBilateralFilter(noisyimage_2_1, 0.1, 0.1);
bp_2_4 = myBilateralFilter(noisyimage_2_2, 0.1, 0.1);

bp_3_1 = myBilateralFilter(noisyimage_1_1, 3, 15);
bp_3_2 = myBilateralFilter(noisyimage_1_2, 3, 15);
bp_3_3 = myBilateralFilter(noisyimage_2_1, 3, 15);
bp_3_4 = myBilateralFilter(noisyimage_2_2, 3, 15);

figure(1);
% Original Image 1
subplot(3, 3, 1);
imshow(img1);
title('Original Image');

% Noisey Image 1
subplot(3, 3, 2);
imshow(noisyimage_1_1);
title('Noisey Image 1 σ noise:5');

subplot(3, 3, 3);
imshow(noisyimage_2_1);
title('Noisey Image 1 σ noise:10');

% Bilater Filter Applied to image 1
subplot(3, 3, 4);
imshow(bp_1_1/255);
title('Filtered Image σs:2, σr:2, σ noise:5');
subplot(3, 3, 5);
imshow(bp_2_1/255);
title('Filtered Image σs:0.1, σr:0.1, σ noise:5');
subplot(3, 3, 6);
imshow(bp_3_1/255);
title('Filtered Image σs:3, σr:15, σ noise:5');

% Bilater Filter Applied to image 1
subplot(3, 3, 7);
imshow(bp_1_3/255);
title('Filtered Image σs:2, σr:2, σ noise:10');
subplot(3, 3, 8);
imshow(bp_2_3/255);
title('Filtered Image σs:0.1, σr:0.1, σ noise:10');
subplot(3, 3, 9);
imshow(bp_3_3/255);
title('Filtered Image σs:3, σr:15, σ noise:10');

figure(2);
% Original Image 2
subplot(3, 3, 1);
imshow(img2);
title('Original Image');

% Noisey Image 2
subplot(3, 3, 2);
imshow(noisyimage_1_2);
title('Noisey Image 2 σ noise:5');

% Noisey Image 2
subplot(3, 3, 3);
imshow(noisyimage_2_2);
title('Noisey Image 2 σ noise:10');

% Bilater Filter Applied to image 2
subplot(3, 3, 4);
imshow(bp_1_2/255);
title('Filtered Image σs:2, σr:2, σ noise:5');
subplot(3, 3, 5);
imshow(bp_2_2/255);
title('Filtered Image σs:0.1, σr:0.1, σ noise:5');
subplot(3, 3, 6);
imshow(bp_3_2/255);
title('Filtered Image σs:3, σr:15, σ noise:5');

subplot(3, 3, 7);
imshow(bp_1_4/255);
title('Filtered Image σs:2, σr:2, σ noise:10');
subplot(3, 3, 8);
imshow(bp_2_4/255);
title('Filtered Image σs:0.1, σr:0.1, σ noise:10');
subplot(3, 3, 9);
imshow(bp_3_4/255);
title('Filtered Image σs:3, σr:15, σ noise:10');


function filter_applied_image = myBilateralFilter(image, sigma_s, sigma_r)
    rows=size(image,1);
    cols=size(image,2);

    % blank Images
    black=zeros(rows,cols);

    % parameter for filter
    distances = [2 1 2 1 0 1 2 1 2];
    
    % applying filter
    % keeping window size of 3 as window size is not given in question
    for i = 1:rows-2
        for j = 1:cols-2
            submatrix = image(i:i+2, j:j+2);
            pixels = double(submatrix(:))';
            Ip = image(i,j);
    
            w = exp(-(distances)./(2*(sigma_s^2))-((pixels - double(Ip)).^2)/(2*(sigma_r^2)));
            w = w./(4 * pi * pi * sigma_r^2 * sigma_s^2);
            
            wp = sum(sum(w));
            bf = sum(sum(w.*pixels));
            black(i,j)=bf/wp;
        end
    end
    
    filter_applied_image = black;
end
