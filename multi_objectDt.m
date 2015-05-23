function multi_objectDt(DtType)

	% 统计大小方位重叠
	% bicycle isOverlap 187 total 274  Proportion 0.68248
	load '../VOCdevkit/VOC2007/ImageSets/Main/bicycle_test.txt';
    if nargin < 1
        DtType = 2;
    end

 %    model = load('../voc-release4.01/VOC2007/bicycle_final');
 %    model=model.model;
 %    cls = model.class;
 	bilis = [];
 	polars = [];
 	isOverlap = 0;
 	boxesCounter = 0;
	for i = 1:size(bicycle_test,1)
		if bicycle_test(i,2) == 1
			fprintf('07NO. %d \n', i);
			s = num2string(bicycle_test(i,1));
			imageName = sprintf('../VOCdevkit/VOC2007/JPEGImages/%s.jpg',s);
			annotation = sprintf('../VOCdevkit/VOC2007/Annotations/%s.xml',s);
			im = imread(imageName);
			[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');
			% flag = InteractiveSimDector(im,200,bboxes);
			if n>1
				% myshowboxes(bboxes,[1,0,1],im);
				% text(0,-10,s);
				% saveas(gcf,sprintf('multiObj/%s_X.jpg',s));

				%查看数据分布
				for j = 1:n-1
					for k = j+1:n
						if DtType == 1

							area1 = (bboxes(j,3)-bboxes(j,1)) * (bboxes(j,4) - bboxes(j,2));
							area2 = (bboxes(k,3)-bboxes(k,1)) * (bboxes(k,4) - bboxes(k,2));
							bili = area2/area1;
							if(bili > 1)
								bili = 1/bili;
							end;
							bilis = [bilis;bili];
						elseif DtType == 2
							center1x = bboxes(j,1)+(bboxes(j,3) - bboxes(j,1))/2;
							center1y = bboxes(j,2)+(bboxes(j,4) - bboxes(j,2))/2;
							center2x = bboxes(k,1)+(bboxes(k,3) - bboxes(k,1))/2;
							center2y = bboxes(k,2)+(bboxes(k,4) - bboxes(k,2))/2;
							polar = polarDirection(center1x,center1y,center2x,center2y);
							polars = [polars;polar];
						else
							boxesCounter = boxesCounter + 1;
							[flag,alpha] =  judgeArea(bboxes(j,:),bboxes(k,:));
							if alpha < 0.01
								isOverlap = isOverlap + 1;
							end
						end
					end
				end
			end
		end
	end
	save mydata1 bilis;

	load '../VOCdevkit/VOC2011/ImageSets/Main/bicycle_trainval1.txt';

	for i = 1:size(bicycle_trainval1,1)
		if bicycle_trainval1(i,3) == 1
			s = num2string(bicycle_trainval1(i,2));
			imageName = sprintf('../VOCdevkit/VOC2011/JPEGImages/%d_%s.jpg',bicycle_trainval1(i,1),s);
			annotation = sprintf('../VOCdevkit/VOC2011/Annotations/%d_%s.xml',bicycle_trainval1(i,1),s);
			% im = imread(imageName);
			[bboxes , n] = readObjectBoxesFromXML(annotation,'bicycle');
			fprintf('11NO. %d \n', i);
			%nothing = InteractiveDector(im,model,cls,200);
			if n>1
				
				% myshowboxes(bboxes,[1,0,1],im);
				% text(0,-10,s);
				% saveas(gcf,sprintf('multiObj2011/%d_%s_x.jpg',bicycle_trainval1(i,1),s));

				%查看数据分布
				for j = 1:n-1
					for k = j+1:n
						if DtType == 1

							area1 = (bboxes(j,3)-bboxes(j,1)) * (bboxes(j,4) - bboxes(j,2));
							area2 = (bboxes(k,3)-bboxes(k,1)) * (bboxes(k,4) - bboxes(k,2));
							bili = area2/area1;
							if(bili > 1)
								bili = 1/bili;
							end;
							bilis = [bilis;bili];
						elseif DtType == 2
							center1x = bboxes(j,1)+(bboxes(j,3) - bboxes(j,1))/2;
							center1y = bboxes(j,2)+(bboxes(j,4) - bboxes(j,2))/2;
							center2x = bboxes(k,1)+(bboxes(k,3) - bboxes(k,1))/2;
							center2y = bboxes(k,2)+(bboxes(k,4) - bboxes(k,2))/2;
							polar = polarDirection(center1x,center1y,center2x,center2y);
							polars = [polars;polar];
						else
							boxesCounter = boxesCounter + 1;
							[flag,alpha] =  judgeArea(bboxes(j,:),bboxes(k,:));
							if alpha < 0.01
								isOverlap = isOverlap + 1;
							end
						end
					end
				end
			end
		end
	end

	if DtType == 1
		save mydata2 bilis;
		drawbilis(bilis,5);
	elseif DtType == 2
		save polars1 polars;
		drawbilis(bilis,6);
	else
		fprintf('isOverlap %d total %d  Proportion %f ',isOverlap,boxesCounter,1.0*isOverlap/boxesCounter);
	end

end



function news = num2string(n)
	b=num2str(n);
	c='000000';
	news = [c(1:6-length(b)) b];
end