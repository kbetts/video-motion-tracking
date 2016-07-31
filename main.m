%% Project:			Principal Component Analysis
%% Author:			Kellen Betts  |  kellen.betts@gmail.com
%% Date:			120228
%% Description: 	Paint can experiments; PCA to extract dynamics.
%%					See accompanying "description" document (PDF, LaTeX, & LyX).


%% MATLAB CODE %%

clear all; close all; tic

%%===========================================================     initialization

test = 4
rankExpt = 2;
numCameras = 3;

cropBndrys = [220 300; 120 250; 240 280];
cropCheck = 'noCrop';

color = targetColor(test);

numFrames = zeros(numCameras,1);
X = zeros(numCameras*2,500);

%%==============================================================     coordinates


fig = 0;
for camera=1:numCameras
	
	[mov numFrames(camera)] = loadMovie(test,camera,cropCheck,cropBndrys);
	%playMovie(mov,numFrames(camera));
	
	for j=1:numFrames(camera)

		% get frame
		F = double(frame2im(mov(j)));
		%figure(1), imshow(uint8(X)), title('Original'), drawnow;

		[y x d] = size(F);

		% shift color spec, floors yellow on can
		Frd = F(:,:,1) - color(camera,1);
		Fgd = F(:,:,2) - color(camera,2);
		Fbd = F(:,:,3) - color(camera,3);
		Fdiff = sqrt( Frd.^2 + Fgd.^2 + Fbd.^2 );
		%plotShifted(F,Fdiff,2);

		% find x,y coords on min value
		[minVal Iind] = min(reshape(Fdiff,1,x*y));
		[Iy Ix] = ind2sub(size(Fdiff),Iind);
		if camera == 3
			% correct for camera 3 orientation
			X(2*camera-1,j) = -1*Iy;
			X(2*camera,j) = Ix;
		else
			X(2*camera-1,j) = Ix;
			X(2*camera,j) = Iy;
		end

	end
	
end

% trim camera 2 data to match 1,3
lag = numFrames(2) - numFrames(3);
X(3,1:end-(lag-1)) = X(3,lag:end);
X(4,1:end-(lag-1)) = X(4,lag:end);

% trim all data to shortest video
n = min(numFrames);
X = X(:,1:n);

%%======================================================================     PCA

[m,n] = size(X);

% subtract off mean (PCA)
mn = mean(X,2);
X = X-repmat(mn,1,n);

% SVD
[U,S,V] = svd(X/sqrt(n-1));
Y = U' * X;
lambda = diag(S).^2;

% energies
energy = zeros(m,1);
for j=1:m
	energy(j) = sum(lambda(1:j))/sum(lambda);
end
energy

%%=================================================================     plotting

plotTracking(X,3);

% plot variances
figure(4);
subplot(1,2,1), plot(lambda,'bo'), title('Diag Variances');
subplot(1,2,2), semilogy(lambda,'bo'), title('Diag Variances (log)');

plotProjections(Y,U,S,V,'princComp',3,5);

plotProjections(Y,U,S,V,'array',6,6);

%plotProjections(Y,U,S,V,'best',rankExpt,7);

%%======================================================================     end
toc
disp(' ')