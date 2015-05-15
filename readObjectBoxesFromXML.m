function [bboxes , n] = readObjectBoxesFromXML(filename,objectname)
	imageAnnotation = xml_read(filename);

	objects = imageAnnotation.object;
	bboxes = [];
	n = 0;
	for i = 1:length(objects)
		if strcmp(objects(i,1).name,objectname) == 1
			box = objects(i, 1).bndbox;
			bboxes = [ box.xmin box.ymin box.xmax box.ymax ;bboxes];
			n = n+1;
		end
	end
end