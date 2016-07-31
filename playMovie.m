function playMovie(mov,numFrames)

	for j=1:numFrames
		F = frame2im(mov(j));
		imshow(F), drawnow;
	end
	
end