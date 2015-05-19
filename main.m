%function main(I,pauseflag,triansize)
    nargin = 0;
    if nargin < 1
        I = imread('../VOCdevkit/VOC2007/JPEGImages/004395.jpg');
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


    model = load('../voc-release4.01/VOC2007/bicycle_final');
    model=model.model;
    cls = model.class;

    allselectWin = [];
    allselectWinScores = [];
    allselectWinArea = [];

    % 200 proposals to train
    meas = zeros(triansize,4);
    species = zeros(triansize,1);
    windowsCenters = [];
    for i = 1:triansize %1
        fprintf('%d',i);
        x1 = int32(candidates(i,1));
        x2 = int32(candidates(i,3));
        y1 = int32(candidates(i,2));
        y2 = int32(candidates(i,4));

        % meas(i,1) = (y2-y1)/(x2-x1);
        % meas(i,2) = (y2-y1)*(x2-x1);
        % meas(i,3) = (x2-x1)/2+x1;
        % meas(i,4) = (y2-y1)/2+y1;

        im = I(y1:y2,x1:x2,:);
        [im,sc] = resize2small(im);  %大小缩放
        [dets,flag]= rundpm(im,model,cls,1);
        
        %species(i);
        % if flag == 1
        %     break;
        % end;


        if flag == 1
            objectArea = (dets(1,3)-dets(1,1))*(dets(1,4)-dets(1,2));
            proposalArea =  size(im,2)*size(im,1);

            fprintf('oA = %.2f  oP = %.2f   pcent = %.2f  score = %f ',objectArea,proposalArea, objectArea/proposalArea,dets(1,5));
            
            windowsCenters = [ windowsCenters ; x1+size(im,2)/2/sc  ,y1+size(im,1)/2/sc]
            if objectArea/proposalArea > 0.5
                allselectWinArea = [allselectWinArea; (y2-y1)*(x2-x1)];
                dets
                allselectWin = [allselectWin;x1 y1 x1+size(im,2)/sc y1+size(im,1)/sc  dets(1,5)];
                allselectWinScores = [allselectWinScores;dets(1,5)];
            %pause;
            end;
        end;
    end;

    % windowsCenters = [       311         171;
    %                          306         206;
    %                          296         200;
    %                          305         179;
    %                          296         191;
    %                          303         191;
    %                          ];


    [radius,CirCen] = minCircle(double(windowsCenters),I);
    meanArea = mean(allselectWinArea);
    maxArea = max(allselectWinScores);
    minArea = min(allselectWinScores);

    fprintf('min %f %f  max %f %f',minArea,meanArea*0.8,maxArea,meanArea*1.5)


    % ObjBayes = NaiveBayes.fit(meas, species);
    % pre0 = ObjBayes.predict(meas);  
    % [CLMat, order] = confusionmat(species, pre0);
    % [[{'From/To'},order'];order, num2cell(CLMat)]

    pause;
    counter = 1;
    for i = triansize:length(candidates)

        x1 = int32(candidates(i,1));
        x2 = int32(candidates(i,3));
        y1 = int32(candidates(i,2));
        y2 = int32(candidates(i,4));

        center2circle = (((x2-x1)/2+x1) - CirCen(1))*((x2-x1)/2+x1 - CirCen(1)) + ((y2-y1)/2+y1- CirCen(2))*((y2-y1)/2+y1- CirCen(2));
        thisArea = (y2-y1)*(x2-x1);
        if center2circle < radius*radius
            if(thisArea > meanArea*0.7 && thisArea < meanArea*1.5 )
                fprintf('NO.%d  counter =  %d ',i,counter);
                counter = counter + 1;
                im = I(y1:y2,x1:x2,:);
                [im,sc] = resize2small(im);
                [dets,flag] = rundpm(im,model,cls,0);
                % if flag == 1
                %     break;
                % end;

                if flag == 1
                    dets
                    allselectWin = [allselectWin;x1 y1 x1+size(im,2)/sc y1+size(im,1)/sc  1.0*dets(1,5)];
                    allselectWinScores = [allselectWinScores;dets(1,5)];
                end
            end
        end;
    end


    axis equal;
    axis on;
    clf;
    myshowboxes(allselectWin(1,:),[1 0 0],I);

    allselectWin
    allselectWinScores
    allselectWin = double(allselectWin);
    for i = 1:size(allselectWinScores,1)
        myshowboxes(allselectWin(i,:),[1/i 1/i 100/255]);
        ss = sprintf('%.2f',allselectWinScores(i,1));
        text(allselectWin(i,1),allselectWin(i,2),ss,'color',[1/i 1/i 100/255]);
    end
    [maxbox,maxid] = max(allselectWinScores);
    myshowboxes(allselectWin(maxid,:),[0 0 1]);
    tx = toc(th);
    fprintf('total time is %f\n',tx);


    if ~isdeployed
        path(old_path);
    end

%end