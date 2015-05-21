function drawbilis(bilis,n)
	dr = [];
	for i = 1:n
		counter = 0;
		for j = 1:length(bilis)
			if( bilis(j,1) > 1.0*(i-1)/n &&  bilis(j,1) < 1.0*i/n )
				counter = counter + 1;
			end
		end
		dr = [dr ; counter];
	end
	
	b=bar(dr);
	grid on;
	ch = get(b,'children');
	if(n == 10)
		set(gca,'XTickLabel',{'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9'});
	else
		set(gca,'XTickLabel',{'0-0.2','0.2-0.4','0.4-0.6','0.6-0.8','0.8-1.0'});
	end

	xlabel('±ÈÀı·¶Î§ ');
	ylabel('ÊıÁ¿');
end