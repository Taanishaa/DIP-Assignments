path = "C:\Users\tanis\Downloads\ORL\s"; 
no_of_image_per_person=6;
image_arr=zeros(112*92,32*6);
for j=1:32
    cd(strcat('C:\Users\tanis\Downloads\ORL\s',num2str(j)));
for i=1:6
   image = imread(strcat(num2str(i),'.pgm'));
   image=double(image);
   image=image/255;
   image_arr(:,(j-1)*6+i)=reshape(image,size(image,1)*size(image,2),1);
end
cd ..
end
meanofimages=sum(image_arr,2)/192;
meanimage=image_arr-meanofimages;
covariance=(meanimage'*meanimage);
[U,S,V]=svd(meanimage*meanimage');



k=[1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
mat = zeros(size(k));
for h=1:13
    V_new=U(:,1:k(h));
    V_new=V_new./max(V_new);
    train_img_coeffients = V_new'*meanimage;  
    correct_predict = 0;
    for i = 1:32
        for j = 7:10
            path_new = path + i + "/" + j + ".pgm";
            image = imread(path_new);
            image = double(image(:));
            image=image/255;
            image = image - meanofimages;
            
            a = V_new'*image;
            
            error = sum((train_img_coeffients - a).^2);
            
            [M, I] = min(error);
            prediction = ceil(I/no_of_image_per_person);
            if(prediction == i)
                correct_predict = correct_predict +1;
            end
    
        end
    end
mat(h) = (correct_predict*100)/128;
end
disp(mat);
figure(1);
plot(k, mat);

title("Accuracy graph for Test data for PCA using SVD");
xlabel("Values of K");
ylabel("Accuracy/recognization rate");


for l=1:25
    figure(2);
sgtitle("First 25 eigenfaces corresponding to maximum eigen values");
    subplot(5,5,l);
    img=reshape(U(:,l),112,92);
  
    
    imshow(img*255);

end

