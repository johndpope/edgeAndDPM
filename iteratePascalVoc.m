function iteratePascalVoc()
	load '../VOCdevkit/VOC2007/ImageSets/Main/bicycle_test.txt';

	model = load('../voc-release4.01/VOC2007/bicycle_final');
    model=model.model;
    cls = model.class;

    %fout = fopen('test/out.','wt');
	for i = 1:size(bicycle_test,1)
		if bicycle_test(i,2) == 1
			s = num2string(bicycle_test(i,1));
			imageName = sprintf('../VOCdevkit/VOC2007/JPEGImages/%s.jpg',s);
			annotation = sprintf('../VOCdevkit/VOC2007/Annotations/%s.xml',s);
			im = imread(imageName);
			[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');
			%nothing = InteractiveDector(im,model,cls,200);
			nothing = justDPM(im,model,cls,200);
			if nothing == 0
				myshowboxes(bboxes,[1,0,1]);
				text(0,-10,s);
				text(60,-10,'DPM succeed');
			else
				myshowboxes(bboxes,[1,0,1],im);
				text(0,-10,s);
				text(60,-10,'DPM error');
			end
			saveas(gcf,sprintf('test/%sX.jpg',s));
			%pause;
		end
	end
end

function news = num2string(n)
	b=num2str(n);
	c='000000';
	news = [c(1:6-length(b)) b];
end
