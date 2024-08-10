clc;
clear;

% importing images
img1=imread("C:\data_old\dip\HW3\barbara256.png");
img2=imread("C:\data_old\dip\HW3\kodak24.png");


noise_deviation = 5;
nimg1 = imnoise(img1,"gaussian",0,(noise_deviation/255)^2);
shiftimg1_1 = mmeanShiftSmoothing(double(nimg1), 2, 2);
shiftimg1_2 = mmeanShiftSmoothing(double(nimg1), 0.1, 0.1);
shiftimg1_3 = mmeanShiftSmoothing(double(nimg1), 3, 15);

nimg2 = imnoise(img2,"gaussian",0,(noise_deviation/255)^2);
shiftimg2_1 = mmeanShiftSmoothing(double(nimg2), 2, 2);
shiftimg2_2 = mmeanShiftSmoothing(double(nimg2), 0.1, 0.1);
shiftimg2_3 = mmeanShiftSmoothing(double(nimg2), 3, 15);

figure(1)
subplot(2,2,1)
imshow(img1);
title("Original Image 1");
subplot(2,2,2)
imshow(img2);
title("Original Image 2");
subplot(2,2,3)
imshow(nimg1);
title("Noisy Image 1");
subplot(2,2,4)
imshow(nimg2);
title("Noisy Image 2");

figure(2);
subplot(2,3,1);
imshow(shiftimg1_1);
title("Means shifted Image 1 by 2,2");
subplot(2,3,2);
imshow(shiftimg1_1);
title("Means shifted Image 1 by 0.1,0.1");
subplot(2,3,3);
imshow(shiftimg1_1);
title("Means shifted Image 1 by 3,15");
subplot(2,3,4);
imshow(shiftimg1_1);
title("Means shifted Image 2 by 2,2");
subplot(2,3,5);
imshow(shiftimg1_1);
title("Means shifted Image 2 by 0.1,0.1");
subplot(2,3,6);
imshow(shiftimg1_1);
title("Means shifted Image 2 by 3,15");

function outputImage = mmeanShiftSmoothing(inputImage, spatialBandwidth, intensityBandwidth)
    % Convert input image to double precision for calculations
    inputImage = double(inputImage);

    % Get the size of the input image
    [rows, cols, ~] = size(inputImage);

    % Create an output image of the same size as the input
    outputImage = zeros(size(inputImage));

    % Define the spatial window size as a function of the spatial bandwidth
    spatialWindowRadius = ceil(3 * spatialBandwidth);

    % Iterate over each pixel in the input image
    for i = 1:rows
        for j = 1:cols
            % Get the current pixel's intensity value
            currentIntensity = inputImage(i, j, :);

            % Define the search window boundaries based on spatial bandwidth
            minRow = max(1, i - spatialWindowRadius);
            maxRow = min(rows, i + spatialWindowRadius);
            minCol = max(1, j - spatialWindowRadius);
            maxCol = min(cols, j + spatialWindowRadius);

            % Initialize weighted sum and weight accumulator
            weightedSum = zeros(size(currentIntensity));
            weightAccumulator = 0;

            % Iterate over pixels within the search window
            for x = minRow:maxRow
                for y = minCol:maxCol
                    % Get the intensity value of the current pixel in the window
                    windowIntensity = inputImage(x, y, :);

                    % Calculate the spatial and intensity distances
                    spatialDistance = norm([i - x, j - y]);
                    intensityDistance = norm(currentIntensity - windowIntensity);

                    % Calculate the spatial and intensity kernels
                    spatialKernel = exp(-0.5 * (spatialDistance / spatialBandwidth)^2);
                    intensityKernel = exp(-0.5 * (intensityDistance / intensityBandwidth)^2);

                    % Calculate the weight for the current pixel
                    weight = spatialKernel * intensityKernel;

                    % Update the weighted sum and weight accumulator
                    weightedSum = weightedSum + (windowIntensity * weight);
                    weightAccumulator = weightAccumulator + weight;
                end
            end

            % Normalize the weighted sum
            smoothedPixel = weightedSum / weightAccumulator;

            % Assign the smoothed pixel value to the output image
            outputImage(i, j, :) = smoothedPixel;
        end
    end

    % Convert the output image back to uint8 format
    outputImage = uint8(outputImage);
end


