function createAnimation(filename, images)
%images should be a MxNx3xF objects where F is the number of frame, M and N
%height and width of the images respectively

[M,N,~,F] = size(images);

animFrames = uint8(zeros(M,N,1,F));
[tmp,cmap] = rgb2ind(reshape(images(:,:,:,1),M,N,3),256);
animFrames(:,:,1,1) = tmp;
for i=2:F
    tmp = rgb2ind(reshape(images(:,:,:,i),M,N,3),cmap);
    animFrames(:,:,1,i) = tmp;
end

imwrite(animFrames,cmap,[filename(1:find(filename=='.',1,'last')) 'gif'],'DelayTime',0.5);