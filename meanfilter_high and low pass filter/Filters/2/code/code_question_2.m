clc;
clear;

% importing image
o_image =imread("C:\Users\YASH\Desktop\Mtech stuff\image processsing CS-663\assignments\HW2-20230905T090756Z-001\HW2\barbara256.png");
o_image=double(o_image);
o_image_size = size(o_image);
padded_image = padarray(o_image, [size(o_image, 1), size(o_image, 2)], 0, 'post');

i_row = size(padded_image, 1);
i_col = size(padded_image, 2);
shifted_image = zeros(i_row,i_col);
for i=1:i_row
    for j=1:i_col
        k=i+j;
        shifted_image(i,j) = padded_image(i,j)*(-1)^k;
    end
end

shifte_image_size = size(shifted_image);
i_row = shifte_image_size(1);
i_col = shifte_image_size(2);
image_frquency_response = fft2(shifted_image);

% applying lowpass filter
lpf40 = lpff_generate(40, i_row, i_col);
lpf40_f_output = apply_ffilter(image_frquency_response, lpf40);
lpf40_i_output = abs(ifft2(lpf40_f_output));

lpf80 = lpff_generate(80, i_row, i_col);
lpf80_f_output = apply_ffilter(image_frquency_response, lpf80);
lpf80_i_output = abs(ifft2(lpf80_f_output));


% applying gaussain filter
gf40 = gaussf_generate(40, i_row, i_col);
gf40_f_output = apply_ffilter(image_frquency_response, gf40);
gf40_i_output = abs(ifft2(gf40_f_output));

gf80 = gaussf_generate(80, i_row, i_col);
gf80_f_output = apply_ffilter(image_frquency_response, gf80);
gf80_i_output = abs(ifft2(gf80_f_output));


figure(1);
% Original Image
subplot(1, 1, 1);
imshow(log(abs(image_frquency_response)+1), [-1,18]);
colormap('jet');colorbar;
title('Original Image Frequency response');

% Lowpass filter ouput

figure(2);
% image 1
subplot(1, 2, 1);
imshow(lpf40_i_output(1:o_image_size(1), 1:o_image_size(2))/255);
title('LPF image with cuttoff: 40');
% image 2
subplot(1, 2, 2);
imshow(lpf80_i_output(1:o_image_size(1), 1:o_image_size(2))/255);
title('Lowpass Filtered image with cuttoff: 80');

figure(3)
% fr of filter
subplot(2, 2, 1);
imshow(log(abs(lpf40)+1),[-1,18]);
title('LPF freq. resp.: 40');
colormap('jet');colorbar;
% fr of image
subplot(2, 2, 2);
imshow(log(abs(lpf40_f_output)+1),[-1,18]);
title('LPF Image freq. resp.: 40');
colormap('jet');colorbar;
% fr of filter
subplot(2, 2, 3);
imshow(log(abs(lpf80)+1),[-1,18]);
title('LPF freq. resp.: 80');
colormap('jet');colorbar;
% fr of image
subplot(2, 2, 4);
imshow(log(abs(lpf80_f_output)+1),[-1,18]);
title('LPF Image freq. resp.: 80');
colormap('jet');colorbar;

% Gaussain filter ouput
figure(4);
% image 1
subplot(1, 2, 1);
imshow(gf40_i_output(1:o_image_size(1), 1:o_image_size(2))/255);
title('Gauss Filtered image with cuttoff: 40');
% image 2
subplot(1, 2, 2);
imshow(gf80_i_output(1:o_image_size(1), 1:o_image_size(2))/255);
title('Gauss Filtered image with cuttoff: 80');

figure(5)
% fr of filter
subplot(2, 2, 1);
imshow(log(abs(gf40)+1),[-1,1]);
title('gf freq. resp.: 40');
colormap('jet');colorbar;
% fr of image
subplot(2, 2, 2);
imshow(log(abs(gf40_f_output)+1), [-1,18]);
title('gf Image freq. resp.: 40');
colormap('jet');colorbar;
% fr of filter
subplot(2, 2, 3);
imshow(log(abs(gf80)+1),[-1,1]);
title('gf freq. resp.: 80');
colormap('jet');colorbar;
% fr of image
subplot(2, 2, 4);
imshow(log(abs(gf80_f_output)+1), [-1,18]);
title('gf Image freq. resp.: 80');
colormap('jet');colorbar;

function lpf_freq_response = lpff_generate(cuttoff_f, i_row, i_col)
    filter_radius = cuttoff_f;
    filter_center_x = i_row/2;
    filter_center_y = i_col/2;
    lpf_freq_response = zeros(i_row, i_col);
    for i = 1:i_row
        for j = 1:i_col
            if((i-filter_center_x)^2 + (j-filter_center_y)^2 <= filter_radius^2)
                lpf_freq_response(i,j) = 1;
            end
        end
    end
end

function gsf_freq_response = gaussf_generate(cuttoff_f, i_row, i_col)
    filter_radius = cuttoff_f;
    filter_center_x = i_row/2;
    filter_center_y = i_col/2;
    gsf_freq_response = zeros(i_row, i_col);
    for i = 1:i_row
        for j = 1:i_col
            dd = (i-filter_center_x)^2 + (j-filter_center_y)^2;
            gsf_freq_response(i,j) = exp(-dd/(2*filter_radius^2));
        end
    end
end

function ffr_of_image = apply_ffilter(image_fr, filter_fr)
    image_frquency_response = image_fr;
    ffr_of_image = image_frquency_response .* filter_fr;
end



