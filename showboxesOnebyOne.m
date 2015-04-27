function showboxesOnebyOne(im, boxes, nums,out)

% showboxes(im, boxes, nums)
% Draw bounding boxes on top of image.

if nargin < 3
  nums = 1;
end

if nargin < 4
  out = 0;
end

cwidth = 2;
  

image(im); 

axis image;
axis off;
set(gcf, 'Color', 'white');

if ~isempty(boxes)
  numfilters = floor(size(boxes, 2)/4);
  % draw the boxes with the detection window on top (reverse order)
  maxtop = size(boxes,1);
  for i = 1:nums:maxtop
    topx = i+(nums-1);
    if topx > maxtop
      topx = maxtop;
    end
    x1 = boxes(i:topx,1);
    y1 = boxes(i:topx,2);
    x2 = boxes(i:topx,3);
    y2 = boxes(i:topx,4);
    % remove unused filters
    del = find(((x1 == 0) .* (x2 == 0) .* (y1 == 0) .* (y2 == 0)) == 1);
    x1(del) = [];
    x2(del) = [];
    y1(del) = [];
    y2(del) = [];
    if i == 1
      c = [160/255 0 0];
      s = '-';
    else
      c = 'b';
      s = '-';
    end
    image(im); 
    line([x1 x1 x2 x2 x1]', [y1 y2 y2 y1 y1]', 'color', c, 'linewidth', cwidth, 'linestyle', s);
    if out == 1
      print(1, '-dpng', sprintf('out%d',i));
    end
    pause(0.2+nums*0.2);
  end
end
