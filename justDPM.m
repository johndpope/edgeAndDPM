function nothingflag = justDPM(I,model,cls,triansize)

%use DPM and edgebox
%pascal voc

    th = tic;

    [candidates,score] = run_edge_boxes50(I,1000);
    tx = toc(th);
    fprintf('run_edge_boxes50 time is %f\n',tx);

    allselectWin = [];
    allselectWinScores = [];
    allselectWinArea = [];

    counter = 1;
    nothingflag = 1;
    for i = 1:1000
        fprintf('NO.%d ',i);
        x1 = int32(candidates(i,1));
        x2 = int32(candidates(i,3));
        y1 = int32(candidates(i,2));
        y2 = int32(candidates(i,4));


        counter = counter + 1;
        im = I(y1:y2,x1:x2,:);
        [im,sc] = resize2small(im);
        [dets,flag] = rundpm(im,model,cls,0);

        if flag == 1
            allselectWin = [allselectWin;x1 y1 x1+size(im,2)/sc y1+size(im,1)/sc  1.0*dets(1,5)];
            allselectWinScores = [allselectWinScores;dets(1,5)];
            nothingflag = 0;
        end;
    end;

    axis equal;
    axis on;
    clf;
    [maxbox,maxid] = max(allselectWinScores);
    myshowboxes(allselectWin(maxid,:),[0 1 0],I);
    tx = toc(th);
    fprintf('total time is %f\n',tx);
end