function plotShifted(F,Fdiff,fig)

	figure(fig);
	subplot(1,2,1), imshow(uint8(F)), title('Original');
	subplot(1,2,2), imshow(uint8(Fdiff)), title('Color Shifted');
	%subplot(1,3,3), imshow(uint8(F)), title('Tracking Mark');
	drawnow;

end