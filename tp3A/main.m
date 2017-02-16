clear all;
close all;

%% Load pictures and points

im1 = im2single(imread('faces/6. Carl.JPG'));
im2 = im2single(imread('faces/7. Jean-Michel.JPG'));

im1 = rgb2gray(im1);
im2 = rgb2gray(im2); % convert to grayscale

pt1 = load('points/6. Carl.txt');
pt2 = load('points/7. Jean-Michel.txt');

%imshow(im1);
%imshow(im2);

%% Triangulation

tri = delaunay(pt1);

