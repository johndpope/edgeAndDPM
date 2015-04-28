function easy_use_dpm(im)

    model = load('../voc-release4.01/VOC2007/bicycle_final');
    model=model.model;
    cls = model.class;

    [dets, boxes,flag ]= rundpm(im,model,cls,1);

end
