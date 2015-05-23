function nothingflag = InteractiveSimDector(I,bboxes)

%use DPM and edgebox
%pascal voc


    th = tic;

    [candidates,score] = run_edge_boxes50(I,1000);
    tx = toc(th);
    fprintf('run_edge_boxes50 time is %f\n',tx);

    




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