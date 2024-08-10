
im1=imread("C:\Users\YASH\Desktop\Mtech stuff\image processsing CS-663\assignments\HW2-20230905T090756Z-001\HW2\LC1.png");
im2=imread("C:\Users\YASH\Desktop\Mtech stuff\image processsing CS-663\assignments\HW2-20230905T090756Z-001\HW2\LC2.jpg");
global_hostogram(im1);
global_hostogram(im2);

im1=double(im1);
im2=double(im2);

filter_size = [7, 31, 51, 71];

local_hostogram(im1, filter_size);
local_hostogram(im2, filter_size);

function local_hostogram(img, filter_size)
    L = 256;
    figure;
    for ite=1:4   % iteration for all filter sizes
        im1_padded = padarray(img, [floor((filter_size(ite) - 1)/2) floor((filter_size(ite) - 1)/2)], 0, 'both');
        c = size(img);
        rows = c(1);
        col = c(2);
        
        im1_local_hist = zeros(rows, col);
        
        for i=1:rows            % iterating over all coorindates of image
            for j = 1:col
                mask = im1_padded(i:(i+filter_size(ite)-1), j:(j+filter_size(ite)-1));
                histo_orig = zeros(L, 1);
                histo_orig_test = zeros(L, 1);
                for k = 1:filter_size(ite)  % creating histogram for the image
                    for l = 1:filter_size(ite)
                        histo_orig(mask(k, l)+1) = histo_orig(mask(k, l)+1) + 1;
                    end
                end
                histo_prob_orig = histo_orig/(filter_size(ite)*filter_size(ite));
                
                for m=2:L   % calculating CDF of orginal image
                    histo_orig_test(m) = histo_prob_orig(m) + histo_orig_test(m-1);
                end
                
                histo_orig_test = int32(histo_orig_test*(L-1));
                im1_local_hist(i, j) = histo_orig_test(mask((1+(filter_size(ite)-1)/2), (1+(filter_size(ite)-1)/2))+1);
            end
        end
    % ploting images
    subplot(2, 2, ite);
    imshow(im1_local_hist/255);
    txt = ['Local Histogram filter size - ', num2str(filter_size(ite))];
    title(txt );
    end
end


function global_hostogram(image)
% Calculate the histogram
histogram = imhist(image);

% Calculate the cumulative distribution function (CDF)
cdf = cumsum(histogram);
cdf_normalized = cdf / numel(image);

% Perform histogram equalization
equalized_image = uint8(cdf_normalized(image + 1) * 255);

% Display the original and equalized images
figure;
subplot(1, 2, 1);
imshow(image);
title('Original Image');

subplot(1, 2, 2);
imshow(equalized_image);
title('Equalized Image');
end