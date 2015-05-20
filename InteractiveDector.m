function nothingflag = InteractiveDector(I,model,cls,triansize)

%use DPM and edgebox
%pascal voc


    th = tic;

    [candidates,score] = run_edge_boxes50(I,1000);
    tx = toc(th);
    fprintf('run_edge_boxes50 time is %f\n',tx);

    allselectWin = [];
    allselectWinScores = [];
    allselectWinArea = [];

    % 200 proposals to train
    meas = zeros(triansize,4);
    species = zeros(triansize,1);
    windowsCenters = [];

    startT = 1;
    endT = 0;
    nothingflag = 0;
    while(size(windowsCenters,1) < 3)
        endT = triansize + endT;
        if(endT > 2*triansize)
            nothingflag = 1;
            break;
        end
        for i = startT:endT %1

            fprintf('%d',i);
            x1 = int32(candidates(i,1));
            x2 = int32(candidates(i,3));
            y1 = int32(candidates(i,2));
            y2 = int32(candidates(i,4));

            im = I(y1:y2,x1:x2,:);
            [im,sc] = resize2small(im);  %大小缩放
            [dets,flag]= rundpm(im,model,cls,1);

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
        startT = endT+1;
    end;

    if nothingflag == 1
        fprintf('nothing\n');
        return;
    end

    [radius,CirCen] = minCircle(double(windowsCenters),I);
    meanArea = mean(allselectWinArea);
    maxArea = max(allselectWinArea);
    minArea = min(allselectWinArea);

    fprintf('min %f %f  max %f %f\n',minArea,meanArea*0.8,maxArea,meanArea*1.5);

    counter = 1;
    for i = endT:length(candidates)

        x1 = int32(candidates(i,1));
        x2 = int32(candidates(i,3));
        y1 = int32(candidates(i,2));
        y2 = int32(candidates(i,4));

        center2circle = (((x2-x1)/2+x1) - CirCen(1))*((x2-x1)/2+x1 - CirCen(1)) + ((y2-y1)/2+y1- CirCen(2))*((y2-y1)/2+y1- CirCen(2));
        thisArea = (y2-y1)*(x2-x1);
        if center2circle < radius*radius
            if(thisArea > meanArea*0.7 && thisArea < meanArea*1.5 )
                fprintf('NO.%d  counter =  %d \n',i,counter);
                counter = counter + 1;
                im = I(y1:y2,x1:x2,:);
                [im,sc] = resize2small(im);
                [dets,flag] = rundpm(im,model,cls,0);

                if flag == 1
                    dets
                    allselectWin = [allselectWin;x1 y1 x1+size(im,2)/sc y1+size(im,1)/sc  1.0*dets(1,5)];
                    allselectWinScores = [allselectWinScores;dets(1,5)];
                end
            end
        end;
    end;

    axis equal;
    axis on;
    clf;
    myshowboxes(allselectWin(1,:),[1 0 0],I);

    allselectWin = double(allselectWin);
    % for i = 1:size(allselectWinScores,1)
    %     myshowboxes(allselectWin(i,:),[1/i 1/i 100/255]);
    %     ss = sprintf('%.2f',allselectWinScores(i,1));
    %     text(allselectWin(i,1),allselectWin(i,2),ss,'color',[1/i 1/i 100/255]);
    % end
    [maxbox,maxid] = max(allselectWinScores);
    myshowboxes(allselectWin(maxid,:),[0 1 0]);
    tx = toc(th);
    fprintf('total time is %f\n',tx);
end