clear all;
close all;

%% Load pictures and points

img1 = im2single(imread('faces/6. Carl.JPG'));
%img2 = im2single(imread('faces/7. Jean-Michel.JPG'));
%img2 = im2single(imread('faces/5. Henrique.JPG'));
%img2 = im2single(imread('faces/2. Leo.JPG'));
img2 = im2single(imread('faces/8. David.JPG'));

img1_pts = load('points/6. Carl.txt');
%img2_pts = load('points/7. Jean-Michel.txt');
%img2_pts = load('points/5. Henrique.txt');
%img2_pts = load('points/2. Leo.txt');
img2_pts = load('points/8. David.txt');

%img1 = rgb2gray(img1);
%img2 = rgb2gray(img2); % convert to grayscale

%imshow(im1);
%imshow(im2);
%% Triangulation sur les points intermédiaires

if size(img1) == size(img2)%definir la dimension image
    dim_img = size(img1);
else
    dim_img = 'differentes dimensions D:';
end
% ajout de pts sur les bords
%img1_pts(max(size(img1_pts))+1,:)=[1 1];
%img1_pts(max(size(img1_pts))+1,:)=[1 dim_img(1)-1];
%img1_pts(max(size(img1_pts))+1,:)=[dim_img(2)-1 1];
%img1_pts(max(size(img1_pts))+1,:)=[dim_img(2)-1 dim_img(1)-1];

%img2_pts(max(size(img2_pts))+1,:)=[1 1];
%img2_pts(max(size(img2_pts))+1,:)=[1 dim_img(1)-1];
%img2_pts(max(size(img2_pts))+1,:)=[dim_img(2)-1 1];
%img2_pts(max(size(img2_pts))+1,:)=[dim_img(2)-1 dim_img(1)-1];

pti = (img1_pts+img2_pts)./2; % trouver les points intermédiaires
tri = delaunay(pti(:,1),pti(:,2));
%triplot(tri, pti(:,1), pti(:,2));

%% Morphage 
% warp_frac = distortion [0..1]
% dissolve_frac = fondu [0..1]

%warp_frac = 1;
%dissolve_frac = warp_frac;
%morphed_img = morph(img1, img2, img1_pts, img2_pts, tri, warp_frac, dissolve_frac);
%imshow(morphed_img)
%takes 12,6 secondes avec mon G4620 pour 1 morph
%%
nb=5;%nb de frames -1

img=zeros(dim_img(1),dim_img(2),dim_img(3),nb+1);

for i = 0:nb
    warp_frac = i/nb;
    dissolve_frac = warp_frac;
    morphed_img = morph(img1, img2, img1_pts, img2_pts, tri, warp_frac, dissolve_frac);
    img(:,:,:,i+1) = morphed_img; 
end

%% Video
%createVideo('6a7.mp4', img);
createAnimation('6a8.gif', img);



%% Bonus Vononoi polygon matlab