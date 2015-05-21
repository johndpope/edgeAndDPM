function multi_objectDt()
	load '../VOCdevkit/VOC2007/ImageSets/Main/bicycle_test.txt';

 %    model = load('../voc-release4.01/VOC2007/bicycle_final');
 %    model=model.model;
 %    cls = model.class;
	for i = 1:size(bicycle_test,1)
		if bicycle_test(i,2) == 1
			s = num2string(bicycle_test(i,1));
			imageName = sprintf('../VOCdevkit/VOC2007/JPEGImages/%s.jpg',s);
			annotation = sprintf('../VOCdevkit/VOC2007/Annotations/%s.xml',s);
			im = imread(imageName);
			[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');
			%nothing = InteractiveDector(im,model,cls,200);
			if n>1
				% myshowboxes(bboxes,[1,0,1],im);
				% text(0,-10,s);
				% saveas(gcf,sprintf('multiObj/%s_X.jpg',s));

				%查看数据分布
				area1 = (bboxes(1,3)-bboxes(1,1)) * (bboxes(1,4) - bboxes(1,2));
				area2 = (bboxes(2,3)-bboxes(2,1)) * (bboxes(2,4) - bboxes(2,2));
				bili = area2/area1;
				if(bili > 1)
					bili = 1/bili;
				end;
				bilis = [bilis;bili];
			end
		end
	end
	save mydata1 bilis;

	% load '../VOCdevkit/VOC2011/ImageSets/Main/bicycle_trainval1.txt';

 %    %fout = fopen('test/out.','wt');



	% for i = 1:size(bicycle_trainval1,1)
	% 	if bicycle_trainval1(i,3) == 1
	% 		s = num2string(bicycle_trainval1(i,2));
	% 		imageName = sprintf('../VOCdevkit/VOC2011/JPEGImages/%d_%s.jpg',bicycle_trainval1(i,1),s);
	% 		annotation = sprintf('../VOCdevkit/VOC2011/Annotations/%d_%s.xml',bicycle_trainval1(i,1),s);
	% 		% im = imread(imageName);
	% 		[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');
	% 		fprintf('NO. %d \n', i);
	% 		%nothing = InteractiveDector(im,model,cls,200);
	% 		if n>1
	% 			% myshowboxes(bboxes,[1,0,1],im);
	% 			% text(0,-10,s);
	% 			% saveas(gcf,sprintf('multiObj2011/%d_%s_x.jpg',bicycle_trainval1(i,1),s));

	% 			%查看数据分布
	% 			area1 = (bboxes(1,3)-bboxes(1,1)) * (bboxes(1,4) - bboxes(1,2));
	% 			area2 = (bboxes(2,3)-bboxes(2,1)) * (bboxes(2,4) - bboxes(2,2));
	% 			bili = area2/area1;
	% 			if(bili > 1)
	% 				bili = 1/bili;
	% 			end;
	% 			bilis = [bilis;bili];
	% 		end
	% 	end
	% end
	% save mydata2 bilis;
	% drawbilis(bilis);
end



