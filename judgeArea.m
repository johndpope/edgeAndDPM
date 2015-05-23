function [flag,alpha] =  judgeArea(boxa,boxb)

	%			 boxa and boxb
	%	 alpha = ______________  > 0.5 flag = 1 else 0
	%		 	 boxa  or boxb
	x1min = boxa(1,1);
	y1min = boxa(1,2);
	x1max = boxa(1,3);
	y1max = boxa(1,4);
	area1 = (x1max - x1min +1 ) * (y1max - y1min + 1);

	x2min = boxb(1,1);
	y2min = boxb(1,2);
	x2max = boxb(1,3);
	y2max = boxb(1,4);
	area2 = (x2max - x2min + 1) * (y2max - y2min + 1);

	maxss = max([x1max x2max y1max y2max]);


	ll = zeros(maxss+1);

	ll(x1min:x1max,y1min:y1max) = 1;

	andArea = length(find(ll(x2min:x2max,y2min:y2max) == 1));

	alpha = 1.0*andArea/(area1 + area2 - andArea);

	if alpha > 0.5
		flag = 1;
	else
		flag = 0;
	end
end


function direction =  relativePos(x1,y1,x2,y2)

% 		|
% 	1	|   2
% 		|
% -----------------
% 		|
% 	4	|   3
% 		|
%x1 y1 in the center

	if(x1 < x2)
		if(y1<y2)
			direction = 3;
		else
			direction = 2;
		end
	else
		if(y1<y2)
			direction = 4;
		else
			direction = 1;
		end
	end
end
