function [newim,sc] = resizebbox(im,sc)

	if nargin < 2
		w = size(im,2);
		h = size(im,1);
		if  100/w < 60/h
			sc = 100/w;
		else
			sc = 60/h;
		end
	end
	if sc < 1 
		newim = imresize(im,sc);
	else
		newim = im;
		sc = 1;
    end
    
end