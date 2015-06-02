function multi_objective()
	load '../VOCdevkit/VOC2007/ImageSets/Main/bicycle_test.txt';
	load polars1;
	%角度的概率分布 Probability distribution
	pofenbu = zeros(18,1);
	for i = 1:size(polars,1)
		po = polars(i,1);
		po = floor((po+90)/10);
		if po == 18 
			po = 17;
		end
		pofenbu(po+1,1) = pofenbu(po+1,1)+1;
	end

	for i = 1:size(pofenbu,1)
		pofenbu(i,1) = pofenbu(i,1)*1.0/size(polars,1);
	end


 %    model = load('../voc-release4.01/VOC2007/bicycle_final');
 %    model=model.model;
 %    cls = model.class;
 	bigtimes = zeros(126,10);
 	cishu = [0.4 0.5 0.6];
 	%cishu = 0.1;
 	dttimes = [];
 	for j = 1:3
	    dttimes = [];

		for i = 1:size(bicycle_test,1)
			if bicycle_test(i,2) == 1
				s = num2string(bicycle_test(i,1));
				imageName = sprintf('../VOCdevkit/VOC2007/JPEGImages/%s.jpg',s);
				annotation = sprintf('../VOCdevkit/VOC2007/Annotations/%s.xml',s);

				[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');

				if n>1
					fprintf('07NO. %d \n', i);
					im = imread(imageName);
					%detecttimes = InteractiveSimDector(im,bboxes);
					detecttimes = InterSimDtP(im,bboxes,pofenbu,cishu(1,j));
					dttimes = [dttimes; detecttimes];
				end
			end
		end

		load '../VOCdevkit/VOC2011/ImageSets/Main/bicycle_trainval1.txt';

		for i = 1:size(bicycle_trainval1,1)
			if bicycle_trainval1(i,3) == 1
				s = num2string(bicycle_trainval1(i,2));
				imageName = sprintf('../VOCdevkit/VOC2011/JPEGImages/%d_%s.jpg',bicycle_trainval1(i,1),s);
				annotation = sprintf('../VOCdevkit/VOC2011/Annotations/%d_%s.xml',bicycle_trainval1(i,1),s);
				[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');
				if n>1
					fprintf('11NO. %d \n', i);
					im = imread(imageName);
					%detecttimes = InteractiveSimDector(im,bboxes);
					detecttimes = InterSimDtP(im,bboxes,pofenbu,cishu(1,j));
					dttimes = [dttimes; detecttimes];
				end
			end
		end

		bigtimes(:,j) = dttimes(:,1);
	end
	save bigtimes3mulit bigtimes;
	%[0.05 0.1 0.5  1 1.5 2 4 6]; 0
	%[0.01 0.03 0.08 0.1 0.2] 1 2
	%[0.5 0.8 1.2  3 6] 3
	%bigtimes3duomubiao  [0.4 0.5 0.6];



%	save temp dttimes;
	%x = dttimes;
	% load dttimesNoChange1;
	% sum(dttimes)
	% sum(x)
	% ssss = 0;
	% tttt = 0;
	% for i = 1:size(x,1)
	% 	if x(i,1) < dttimes(i,1)
	% 		ssss = ssss+1;
	% 	elseif x(i,1) > dttimes(i,1)
	% 		tttt = tttt+1;
	% 	end
	% end
	% ssss
	% tttt
			
end

function news = num2string(n)
	b=num2str(n);
	c='000000';
	news = [c(1:6-length(b)) b];
end


