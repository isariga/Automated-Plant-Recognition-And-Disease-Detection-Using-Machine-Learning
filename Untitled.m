
Image=imread('1.jpg');
if size(Image,3)==3
    Image=rgb2gray(Image);
end
[m n r]=size(Image);
rgb=zeros(m,n,3); 
rgb(:,:,1)=Image;
rgb(:,:,2)=rgb(:,:,1);
rgb(:,:,3)=rgb(:,:,1);
Image=rgb/255; 
figure,imshow();

rgbImage = Image;
[rows columns numberOfColorChannels] = size(rgbImage);
if numberOfColorChannels == 1
  % It's monochrome, so convert to color.
  rgbImage = cat(3, rgbImage, rgbImage, rgbImage);
end
imshow(rgbImage);
