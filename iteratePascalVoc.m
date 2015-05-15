function iteratePascalVoc()
	load '../VOCdevkit/VOC2007/ImageSets/Main/bicycle_test.txt';

	for i = 1:size(bicycle_test,1)
		if bicycle_test(i,2) == 1
			s = num2string(bicycle_test(i,1));
			imageName = sprintf('../VOCdevkit/VOC2007/JPEGImages/%s.jpg',s);
			annotation = sprintf('../VOCdevkit/VOC2007/Annotations/%s.xml',s);
			im = imread(imageName);
			[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');
			bboxes
			myshowboxes(bboxes,'b',im);
			text(0,-10,s);
			pause;
		end
	end
end

function news = num2string(n)
	b=num2str(n);
	c='000000';
	news = [c(1:6-length(b)) b];
end
