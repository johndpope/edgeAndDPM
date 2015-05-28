function direction =  polarDirection(x1,y1,x2,y2)
	
	% if (x2 - x1) == 0
	% 	direction = 90;
	% 	return;
	% end
	jiaodutan = 1.0*(y2 - y1) / (x2 - x1);
	if isnan(jiaodutan)
		jiaodutan = 0;
	end

	direction = atan(jiaodutan)*180/pi;

end