
image1=imread("C:\Users\tanis\Downloads\goi1.jpg");
image2=imread("C:\Users\tanis\Downloads\goi2_downsampled.jpg");
goi1=double(image1);
goi2=double(image2);
n=12;
figure(1);
imshow(goi2/255);
[x2,y2]=ginput(n);
im1=[x2,y2,ones(n,1)];

figure(2);
imshow(goi1/255);
[x1,y1]=ginput(n);
im2=[x1,y1,ones(n,1)];
disp(im2);
im1trans=im1';
im2trans=im2';
black=zeros(360,640);
Affine=im1trans*im2*inv(im2trans*im2);



A=inv(Affine);
disp(A);
rows=size(goi1,1);
col=size(goi1,2);

for i=1:rows
    for j=1:col
      x3 =(A(1,1)*(i)+A(1,2)*(j)+A(1,3));
      x4=(A(2,1)*(i)+A(2,2)*(j)+A(2,3));
      if(x3 > 1 && x3<=360 && x4 > 1 && x4<=640)
          xceil=ceil(x3);
          xfloor=floor(x3);
          yceil=ceil(x4);
          yfloor=floor(x4);
          d1=(xceil-x3)^2+(yceil-x4)^2;
          d2=(xceil-x3)^2+(yfloor-x4)^2;
          d3=(xfloor-x3)^2+(yceil-x4)^2;
          d4=(xfloor-x3)^2+(yfloor-x4)^2;
          d1=1/d1;
          d2=1/d2;
          d3=1/d3;
          d4=1/d4;
          d=d1+d2+d3+d4;
          black(i,j)=(d1*goi2(xceil,yceil)+d2*goi2(xceil,yfloor)+d3*goi2(xfloor,yceil)+d4*goi2(xfloor,yfloor))/d;

      end
      
    end
end
subplot(1,3,1);
imshow(goi1/255);
title("Original Image");
subplot(1,3,2);

imshow(goi2/255);
title("Destination Image");
subplot(1,3,3);

imshow(black/255);
title("Transformed Image");
