function frm = birdframe(xmin, xmax, ymin, ymax, birdxs, birdys, feedx, feedy)
  colors = zeros(length(birdxs) + 1, 3);
  colors(1,:) = [0, 255, 0];
  colors(2,:) = [255, 0, 0];
  for i = 3:length(colors)
    colors(i,:) = [0, 0, 255];
  end
  figure('visible', 'off');
  scatter([feedx birdxs], [feedy birdys], 50, colors,"filled","diamond");
  axis([xmin, xmax, ymin, ymax]);
  frm = getframe;
