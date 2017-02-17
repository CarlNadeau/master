clear all;
close all;

%% Load pictures and points

img1 = im2single(imread('faces/6. Carl.JPG'));
img2 = im2single(imread('faces/7. Jean-Michel.JPG'));

img1_pts = load('points/6. Carl.txt');
img2_pts = load('points/7. Jean-Michel.txt');

img1 = rgb2gray(img1);
img2 = rgb2gray(img2); % convert to grayscale

%imshow(im1);
%imshow(im2);
%% Triangulation sur les points intermédiaires

pti = (img1_pts+img2_pts)./2; % trouver les points intermédiaires
tri = delaunay(pti(:,1),pti(:,2));
%triplot(tri, pti(:,1), pti(:,2));

%% Morphage 
% warp_frac = distortion [0..1]
% dissolve_frac = fondu [0..1]
%morphed_img = morph(img1, img2, img1_pts, img2_pts, tri, warp_frac, dissolve_frac);
warp_frac = 0.5;
dissolve_frac = 0;
if size(img1) == size(img2)%definir la dimension
    dim_img = size(img1);
else
    dim_img = 'differentes dimensions D:';
end

%% definition des triangles pour construires les (3) masques
dim_tri = size(tri);
imgi_pts =(1-warp_frac).*img1_pts + warp_frac.*img2_pts;

coord1 = zeros(dim_tri);
coord2 = coord1;
coordi = coord1;

mask1 = zeros(dim_img(1),dim_img(2),max(dim_tri));
mask2 = mask1;
maski = mask1;

for i=1:dim_tri
    for j=1:3
        for k=1:2
        coord1(i,j,k)=img1_pts(tri(i,j),k);
        coord2(i,j,k)=img2_pts(tri(i,j),k);
        coordi(i,j,k)=imgi_pts(tri(i,j),k);
        end
    end
    mask1(:,:,i)=poly2mask(coord1(i,:,1),coord1(i,:,2),dim_img(1),dim_img(2));
    mask2(:,:,i)=poly2mask(coord2(i,:,1),coord2(i,:,2),dim_img(1),dim_img(2));
    maski(:,:,i)=poly2mask(coordi(i,:,1),coordi(i,:,2),dim_img(1),dim_img(2));
end

%% Transformation affine des triangles
% transformation inverse d'un triangle


% Fondu des couleurs

%% Bonus Vononoi polygon matlab