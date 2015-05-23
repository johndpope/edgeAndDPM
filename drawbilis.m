function drawbilis(bilis,n)
	dr = [];
	for i = 1:n
		counter = 0;
		if (n == 5 || n == 10)
			for j = 1:length(bilis)
				if( bilis(j,1) > 1.0*(i-1)/n &&  bilis(j,1) < 1.0*i/n )
					counter = counter + 1;
				end
			end
		else
			for j = 1:length(bilis)
				if( bilis(j,1) > 180/n*(i-1)-90 &&  bilis(j,1) < 180/n*i - 90 )
					counter = counter + 1;
				end
			end
		end
		dr = [dr ; counter];
	end

	%圆环 补全
	if n == 6
		dr = [dr;dr(1:3,:)];
	end

	
	b=bar(dr);
	grid on;
	ch = get(b,'children');
	if(n == 10)
		set(gca,'XTickLabel',{'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9'});
	elseif n == 5
		set(gca,'XTickLabel',{'0-0.2','0.2-0.4','0.4-0.6','0.6-0.8','0.8-1.0'});
	elseif n == 6
		set(gca,'XTickLabel',{'-90~-60','-60~-30','-30~0','0~30','30~60','60~90','-90~-60','-60~-30','-30~0'});
	else
		set(gca,'XTickLabel',{'-90~-75','-75~-60','-60~-45','-45-30','-30~-15','-15~0','0~15','15~30','30~45','45~60','60~75','75~90',});
	end
				

	xlabel('±ÈÀý·¶Î§ ');
	ylabel('ÊýÁ¿');
end