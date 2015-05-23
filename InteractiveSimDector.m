function detecttimes = InteractiveSimDector(I,bboxes)

	% th = tic;
	detecttimes = 0;
    [candidates,score] = run_edge_boxes50(I,1000);

    bestDtWindows = zeros(size(bboxes,1),5);

    detflag = zeros(size(candidates,1),1);

 	%findfirst
    for i = 1:size(candidates,1)
    	detflag(i,1) = 1;
    	for j = 1:size(bboxes,1)
	    	[flag,alpha] = judgeArea(candidates(i,:),bboxes(j,:));
	    	if flag == 1
	    		if bestDtWindows(j,1) < alpha
	    			bestDtWindows(j,1) = alpha;
	    			bestDtWindows(j,2) = i;
	    		end
	    		findfirstbbox = j;
	    	end
	    end
	    if length(find(bestDtWindows(:,1) > 0)) ~= 0
	    	findfirstC = i;
	    	fprintf('first is %d   ', i);
	    	break;
	    end
	    findfirstC = i;
	end

	if findfirstC == size(candidates,1)
		detecttimes = -1;
		fprintf('gg smd -1\n');
		return;
	end

	if length(find(bestDtWindows(:,1) == 0)) == 0
		fprintf('succeed\n');
	    detecttimes = findfirstC;
	    return ;
	end


	%使用条件
	centerX = (candidates(findfirstC,1)+candidates(findfirstC,3))/2;
	centerY = (candidates(findfirstC,2)+candidates(findfirstC,4))/2;

	stArea = (candidates(findfirstC,1)-candidates(findfirstC,3)) * (candidates(findfirstC,2)-candidates(findfirstC,4));

	for i = findfirstC+1:size(candidates,1)
		thiscenterX = (candidates(i,1)+candidates(i,3))/2;
		thiscenterY = (candidates(i,2)+candidates(i,4))/2;

		thisArea = (candidates(i,1)-candidates(i,3)) * (candidates(i,2)-candidates(i,4));

		polar = polarDirection(centerX,centerY,thiscenterX,thiscenterY);

		if((polar > -15 && polar < 15) || (thisArea < 2*stArea && thisArea > stArea/2))
			detflag(i,1) = 1;
	    	for j = 1:size(bboxes,1)
		    	[flag,alpha] = judgeArea(candidates(i,:),bboxes(j,:));
		    	if flag == 1
		    		if bestDtWindows(j,1) < alpha
		    			bestDtWindows(j,1) = alpha;
		    			bestDtWindows(j,2) = i;
		    		end
		    	end
		    end

			if length(find(bestDtWindows(:,1) == 0)) == 0
		    	detecttimes = length(find(detflag == 1));

		    	fprintf('select succeed %d   \n', detecttimes);
		    	return;
		    end
		end
	end
	fprintf('continue \n');

	%继续原来的过程
	for i = findfirstC+1:size(candidates,1)
		% thiscenterX = (candidates(i,1)+candidates(i,3))/2;
		% thiscenterY = (candidates(i,2)+candidates(i,4))/2;
		% thisArea = (candidates(i,1)-candidates(i,3) * (candidates(i,2)-candidates(i,4));
		% polar = polarDirection(centerX,centerY,thiscenterX,thiscenterY);

		if(detflag(i,1) == 0)
			detflag(i,1) = 1;
	    	for j = 1:size(bboxes,1)
		    	[flag,alpha] = judgeArea(candidates(i,:),bboxes(j,:));
		    	if flag == 1
		    		if bestDtWindows(j,1) < alpha
		    			bestDtWindows(j,1) = alpha;
		    			bestDtWindows(j,2) = i;
		    		end
		    	end
		    end
		    if length(find(bestDtWindows(:,1) == 0)) == 0
		    	detecttimes = length(find(detflag == 1));
		    	return;
		    end
		end
	end
    if length(find(bestDtWindows(:,1) == 0)) > 0
    	detecttimes = -1;
    	return;
    end

	detecttimes = -1;
    % axis equal;
    % axis on;
    % clf;
    % myshowboxes(bboxes,[1 0 0],I);
    % for i = 1:size(bboxes,1)
    %     myshowboxes(candidates(bestDtWindows(i,2),:),[1 0 1]);
    %     ss = sprintf('%.2f',bestDtWindows(i,1));
    %     text(candidates(bestDtWindows(i,2),1),candidates(bestDtWindows(i,2),2),ss,'color',[1 0 1]);
    % end

    % tx = toc(th);
    % fprintf('total time is %f\n',tx);
end




 %    for i = 1:size(candidates,1)
 %    	detflag(i,1) = 1;
 %    	for j = 1:size(bboxes,1)
	%     	[flag,alpha] = judgeArea(candidates(i,:),bboxes(j,:));
	%     	if flag == 1
	%     		if bestDtWindows(j,1) < alpha
	%     			bestDtWindows(j,1) = alpha;
	%     			bestDtWindows(j,2) = i;
	%     		end
	%     	end
	%     end
	%     if length(find(bestDtWindows(:,1) > 0)) == 0
	%     	detecttimes = i;
	%     	break;
	%     end
	% end