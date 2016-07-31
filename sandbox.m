clear all; close all;

%%===============================================================     initialize

test = 4;
camera = 3;

crop = [220 300; 120 250; 240 280];
cropCheck = 'noCrop';

color1 = [255 249 202; 253 255 134; 230 227 182];
color2 = [253 255 208; 254 255 148; 247 246 177];
color3 = [252 257 207; 250 255 132; 241 243 178];
color4 = [255 249 213; 241 254 142; 207 213 157];
color = color4;

numFrames = zeros(3,1);
X = zeros(6,300);

[mov numFrames(camera)] = loadMovie(test,camera,cropCheck,crop);
%playMovie(mov,numFrames(camera));

%%===============================================================     get frames

for j=1:1

	% get frame
	F = double(frame2im(mov(j)));
	figure(1), imshow(uint8(X)), title('Original'), drawnow;

	[y x d] = size(F);

	% shift color spec, floors yellow on can
	Frd = F(:,:,1) - color(camera,1);
	Fgd = F(:,:,2) - color(camera,2);
	Fbd = F(:,:,3) - color(camera,3);
	Fdiff = sqrt( Frd.^2 + Fgd.^2 + Fbd.^2 );
	if j == 1
		plotShifted(F,Fdiff,2);
	end

	% find x,y coords on min value
	[minVal Iind] = min(reshape(Fdiff,1,x*y));
	[Iy Ix] = ind2sub(size(Fdiff),Iind);
	X(2*camera-1,j) = Ix;
	X(2*camera,j) = Iy;
	
end

%%======================================================================     end
