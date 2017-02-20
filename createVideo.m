function createVideo(filename, images)
%images should be a MxNx3xF objects where F is the number of frame, M and N
%height and width of the images respectively

[M,N,~,F] = size(images);

vw = VideoWriter([filename '.mp4']); 
vw.FrameRate = 30; % number of frames per second
open(vw); 

for i = 1:F
	writeVideo(vw, images(:,:,:,i));
end

close(vw); %une fois toutes les images ajoutés au video