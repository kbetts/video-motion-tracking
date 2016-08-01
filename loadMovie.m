function [mov numFrames] = loadMovie(test,camera,cropCheck,cropLim,dx,dy)
	
	pathName = './data/';
	varNameBase = 'vidFrames';

	fileName = strcat(pathName,'cam',num2str(camera),'_',num2str(test),'.mat');

	load(fileName);
	
	vidFrames = eval(strcat(varNameBase,num2str(camera),'_',num2str(test)));
	numFrames = size(vidFrames,4);
	
	switch cropCheck
		
	case 'crop'
		
		if camera == 3
			dy = 80;  dx = 160;
		else
			dy = 160;  dx = 80;
		end
		
		crop = [cropLim(camera,1) cropLim(camera,1)+dy cropLim(camera,2) cropLim(camera,2)+dx];
	
		for k=1:numFrames
			mov(k).cdata = vidFrames(crop(1):crop(2),crop(3):crop(4),:,k);
			mov(k).colormap = [];
		end
		
	case 'noCrop'
		
		for k=1:numFrames
			mov(k).cdata = vidFrames(:,:,:,k);
			mov(k).colormap = [];
		end
		
	end
end