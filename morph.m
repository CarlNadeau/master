%% Morphage par Carl Nadeau
% warp_frac = distortion [0..1]
% dissolve_frac = fondu [0..1]
function morphed_img = morph(img1, img2, img1_pts, img2_pts, tri, warp_frac, dissolve_frac)

if size(img1) == size(img2)%definir la dimension
    dim_img = size(img1);
else
    dim_img = 'differentes dimensions D:';
end

%morphed_img = zeros(dim_img);

%% definition des triangles pour construires les (3) masques et
% les deux tranformations inverses à partir du triangle intermédiaire
dim_tri = size(tri);
imgi_pts =(1-warp_frac).*img1_pts + warp_frac.*img2_pts;

coord1 = zeros(dim_tri);
coord2 = coord1;
coordi = coord1;

coordH1 = ones(3,3,max(dim_tri));%coordonnée homogènes
coordH2 = coordH1;
coordHi = coordH1;

transInv1 = zeros(3,3,max(dim_tri));%transformation inverse
transInv2 = transInv1;

mask1 = zeros(dim_img(1),dim_img(2),max(dim_tri));
mask2 = mask1;
maski = mask1;
%mask2t =zeros(dim_img(1),dim_img(2));
for i=1:max(dim_tri)
    for j=1:3
        for k=1:2
        coord1(i,j,k)=img1_pts(tri(i,j),k);
        coord2(i,j,k)=img2_pts(tri(i,j),k);
        coordi(i,j,k)=imgi_pts(tri(i,j),k);
        
        coordH1(k,:,i) = coord1(i,:,k); %coordonnée homogènes
        coordH2(k,:,i) = coord2(i,:,k);
        coordHi(k,:,i) = coordi(i,:,k);
        end   
    end
    transInv1(:,:,i)=coordH1(:,:,i)/coordHi(:,:,i);
    transInv2(:,:,i)=coordH2(:,:,i)/coordHi(:,:,i);
    %transInv1(:,:,i)=(coordHi(:,:,i)'*coordHi(:,:,i))\coordHi(:,:,i)'*coordH1(:,:,i);
    %transInv2(:,:,i)=(coordHi(:,:,i)'*coordHi(:,:,i))\coordHi(:,:,i)'*coordH2(:,:,i);
    
    mask1(:,:,i)=poly2mask(coord1(i,:,1),coord1(i,:,2),dim_img(1),dim_img(2));
    mask2(:,:,i)=poly2mask(coord2(i,:,1),coord2(i,:,2),dim_img(1),dim_img(2));
    maski(:,:,i)=poly2mask(coordi(i,:,1),coordi(i,:,2),dim_img(1),dim_img(2));
    
    %mask2t=mask2t+mask2(:,:,i);
end
%imshow(mask2t)

%% Transformation affine des triangles et Fondu des couleurs

tri1 = zeros(dim_img(1),dim_img(2),dim_img(3),max(dim_tri));
tri2 = tri1;
trii = tri1;

image_construction=zeros(dim_img);

%nCoord1 = [0 0];
%nCoord2 = [0 0];

for i=1:max(dim_tri)
    for y=1:dim_img(2)
        for x=1:dim_img(1)
            if maski(y,x,i)==1
                %tic;
                %pour le triangle de la premiere image
                nCoord1=transInv1(:,:,i)*[x; y; 1];

                alpha1=nCoord1(1:2)-floor(nCoord1(1:2)); %a(1) et a(2)
                      %yx        %y                    x
                pixel1_11=img1(floor(nCoord1(2)),floor(nCoord1(1)),:); %pixel1_yx
                pixel1_21=img1(ceil(nCoord1(2)),floor(nCoord1(1)),:);
                pixel1_12=img1(floor(nCoord1(2)),ceil(nCoord1(1)),:);
                pixel1_22=img1(ceil(nCoord1(2)),ceil(nCoord1(1)),:);
                     %yx
                beta1_11=(((1-alpha1(1))+(1-alpha1(2)))/2)*pixel1_11;%beta1_yx
                beta1_21=(((1-alpha1(1))+alpha1(2))/2)*pixel1_21;
                beta1_12=((alpha1(1)+(1-alpha1(2)))/2)*pixel1_12;
                beta1_22=((alpha1(1)+alpha1(2))/2)*pixel1_22;

                tri1(y,x,:,i)=(beta1_11+beta1_21+beta1_12+beta1_22)./2;

                %pour le triangle de la deuxieme image
                nCoord2=transInv2(:,:,i)*[x; y; 1];
                
                alpha2=nCoord2(1:2)-floor(nCoord2(1:2));
                
                pixel2_11=img2(floor(nCoord2(2)),floor(nCoord2(1)),:); %pixel1_yx
                pixel2_21=img2(ceil(nCoord2(2)),floor(nCoord2(1)),:);
                pixel2_12=img2(floor(nCoord2(2)),ceil(nCoord2(1)),:);
                pixel2_22=img2(ceil(nCoord2(2)),ceil(nCoord2(1)),:);
                     %yx
                beta2_11=(((1-alpha2(1))+(1-alpha2(2)))/2)*pixel2_11;%beta1_yx
                beta2_21=(((1-alpha2(1))+alpha2(2))/2)*pixel2_21;
                beta2_12=((alpha2(1)+(1-alpha2(2)))/2)*pixel2_12;
                beta2_22=((alpha2(1)+alpha2(2))/2)*pixel2_22;

                tri2(y,x,:,i)=(beta2_11+beta2_21+beta2_12+beta2_22)./2;
                %beta2=(1-alpha2).*img2(floor(nCoord2(1:2)))+alpha2.*img2(ceil(nCoord2(1:2)));
                %tri1(y,x,i)=interp2(img1,nCoord1(1),nCoord1(2),'linear');
                %too long
                %tri2(y,x,i)=interp2(img2,nCoord2(1),nCoord2(2),'linear');
                %toc;
            end
        end
    end
    trii(:,:,:,i)=(1-dissolve_frac).*tri1(:,:,:,i)+dissolve_frac.*tri2(:,:,:,i);
    image_construction = image_construction + trii(:,:,:,i);
end
morphed_img(1,:,:) = img1(1,:,:);
morphed_img(dim_img(2),:,:)= img1(dim_img(2),:,:);
morphed_img(:,1,:) = img1(:,1,:);
morphed_img(:,dim_img(1),:) = img1(:,dim_img(1),:);
morphed_img = image_construction + morphed_img;
end