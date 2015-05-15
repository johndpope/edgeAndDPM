function easy_use_dpm(im)
	if ~isdeployed
        old_path = path;

        addpath(genpath('../voc-release4.01'));
        disp('dpm voc addpath size');
    end

    model = load('../voc-release4.01/VOC2007/bicycle_final');
    model=model.model;
    cls = model.class;

    [dets,flag ]= rundpm(im,model,cls,1);
    if ~isdeployed
        path(old_path);
    end

end
