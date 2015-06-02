I = imread('images/000084.jpg');
[candidates,score] = run_edge_boxes50(I,1000);
bboxes = candidates;
bilis = [];
j = 1;
areas = [];
for j = 1:1
	disp(j);
	area1 = (bboxes(j,3)-bboxes(j,1)) * (bboxes(j,4) - bboxes(j,2));
	for k = j+1:size(candidates,1)
		area2 = (bboxes(k,3)-bboxes(k,1)) * (bboxes(k,4) - bboxes(k,2));
		bili = area2/area1;
		if(bili > 1)
			bili = 1/bili;
		end;
		bilis = [bilis;bili];
		areas = [areas;area2];
	end
end