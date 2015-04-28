function main(I,pauseflag,triansize)

    if nargin < 1
        I = imread('000084.jpg');
    end

    if nargin < 2
        pauseflag = 1;
    end

    if nargin < 3
        triansize = 200;
    end

    if ~isdeployed
        old_path = path;

        addpath(genpath('../voc-release4.01'));
        disp('dpm voc addpath size');
    end


    th = tic;
    [candidates,score] = run_edge_boxes50(I,1000);
    tx = toc(th);
    fprintf('run_edge_boxes50 time is %f\n',tx);

    room = 0;
    maxroom = 0;
    maxindex = 0;
    % for i = 1:length(candidates)
    % 	room = (candidates(i,3)-candidates(i,1))*(candidates(i,4)-candidates(i,2));
    %     if maxroom < room
    %     	maxroom = room;
    %     	maxindex = i;
    %     end;
    % end;

    model = load('../voc-release4.01/VOC2007/bicycle_final');
    model=model.model;
    cls = model.class;

    meas = zeros(triansize,4);
    species = zeros(triansize,1);
    for i = 1:triansize
        fprintf('%d',i);
        x1 = int32(candidates(i,1));
        x2 = int32(candidates(i,3));
        y1 = int32(candidates(i,2));
        y2 = int32(candidates(i,4));

        meas(i,1) = (y2-y1)/(x2-x1);
        meas(i,2) = (y2-y1)*(x2-x1);
        meas(i,3) = (x2-x1)/2+x1;
        meas(i,4) = (y2-y1)/2+y1;

        im = I(y1:y2,x1:x2,:);
        [im,sc] = resize2small(im);  %大小缩放
        [dets, boxes,flag ]= rundpm(im,model,cls,0);
        species(i);
        % if flag == 1
        %     break;
        % end;


        if(flag == 1 && pauseflag == 1)
            pause;
        end;
    end
    ObjBayes = NaiveBayes.fit(meas, species);
    pre0 = ObjBayes.predict(meas);  
    [CLMat, order] = confusionmat(species, pre0);
    [[{'From/To'},order'];order, num2cell(CLMat)]

    pause;
    for i = triansize:length(candidates)
        fprintf('%d',i);
        x1 = int32(candidates(i,1));
        x2 = int32(candidates(i,3));
        y1 = int32(candidates(i,2));
        y2 = int32(candidates(i,4));
        im = I(y1:y2,x1:x2,:);
        [im,sc] = resize2small(im);
        [dets, boxes,flag] = rundpm(im,model,cls,0);
        % if flag == 1
        %     break;
        % end;

        if flag == 1
            pause;
        end;
    end
    tx = toc(th);
    fprintf('total time is %f\n',tx);


    if ~isdeployed
        path(old_path);
    end

end