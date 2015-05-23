function multi_objective()
	load '../VOCdevkit/VOC2007/ImageSets/Main/bicycle_test.txt';

 %    model = load('../voc-release4.01/VOC2007/bicycle_final');
 %    model=model.model;
 %    cls = model.class;
    dttimes = [];

	for i = 1:size(bicycle_test,1)
		if bicycle_test(i,2) == 1
			s = num2string(bicycle_test(i,1));
			imageName = sprintf('../VOCdevkit/VOC2007/JPEGImages/%s.jpg',s);
			annotation = sprintf('../VOCdevkit/VOC2007/Annotations/%s.xml',s);

			[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');

			if n>1
				im = imread(imageName);
				detecttimes = InteractiveSimDector(im,bboxes);
				dttimes = [dttimes; detecttimes];
			end
		end
	end
	save dttimesNoChange dttimes;

	load '../VOCdevkit/VOC2011/ImageSets/Main/bicycle_trainval1.txt';

	for i = 1:size(bicycle_trainval1,1)
		if bicycle_trainval1(i,3) == 1
			s = num2string(bicycle_trainval1(i,2));
			imageName = sprintf('../VOCdevkit/VOC2011/JPEGImages/%d_%s.jpg',bicycle_trainval1(i,1),s);
			annotation = sprintf('../VOCdevkit/VOC2011/Annotations/%d_%s.xml',bicycle_trainval1(i,1),s);
			% im = imread(imageName);
			[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');

			if n>1
				im = imread(imageName);
				detecttimes = InteractiveSimDector(im,bboxes);
				dttimes = [dttimes; detecttimes];
			end
		end
	end

	save dttimesChange1 dttimes;
	x = dttimes;
	load dttimesNoChange1;
	sum(dttimes)
	sum(x)
	ssss = 0;
	tttt = 0;
	for i = 1:size(x,1)
		if x(i,1) < dttimes(i,1)
			ssss = ssss+1;
		elseif x(i,1) > dttimes(i,1)
			tttt = tttt+1;
		end
	end
	ssss
	tttt
			
end

function news = num2string(n)
	b=num2str(n);
	c='000000';
	news = [c(1:6-length(b)) b];
end


