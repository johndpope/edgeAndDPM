function [dets, boxes, isfound]= rundpm(im,model,cls,show)
	dpm = tic();

	if nargin < 2
		model = load('../voc-release4.01/VOC2007/bicycle_final');
		model=model.model;
		cls = model.class;
	end


	thresh = -1.0;
	pca = 5;
	orig_model = model;
	csc_model = cascade_model(model,'2007', pca, thresh);
	orig_model.thresh = csc_model.thresh;
	% load and display image
	%clf;
    imx = double(im);

	pyra = featpyramid(imx, csc_model);



	[dets, boxes] = cascade_detect(pyra, csc_model, csc_model.thresh);


	% load and display model
	%visualizemodel(model, 1:2:length(model.rules{model.start}));
	%disp([cls ' model visualization']);
	%disp('press any key to continue'); pause;
	%disp('continuing...');

	top = nms(dets, 0.5);
	dpm = toc(dpm);
    fprintf('detect time %f\n',dpm);
	if ~isempty(top)

		if show == 1
			axis equal; 
			axis on;
			clf;
		end
		%showboxes(im, reduceboxes(model, boxes(top,:)));
		disp('detections');

		% get bounding boxes
		bbox = bboxpred_get(model.bboxpred, dets, reduceboxes(model, boxes));
		bbox = clipboxes(im, bbox);
		top = nms(bbox, 0.5);


		%clf;
		if show == 1
			showboxes(im, bbox(top,:));
		end

		dets = bbox(top,:);

		disp('bounding boxes');
		isfound = 1;
	else
		isfound = 0;
	

end