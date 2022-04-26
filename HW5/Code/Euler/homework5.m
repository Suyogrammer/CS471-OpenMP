video(-1, 1, -1, 1, 10, @(x) sin(x), @(x) cos(x), 2, 1.5, 3.5, 2, 3, 1, 1/15, 'VideoRSC');
function video(xmin, xmax, ymin, ymax, n, cx, cy, gamma1, gamma2, kappa, rho, lamda, delta, h, filename)

  % Running the simulation
  pos = bposition (xmin, xmax, ymin, ymax, n, cx, cy, gamma1, gamma2, kappa, rho, lamda, delta, h);
    function pos = bposition(xmin, xmax, ymin, ymax, n, cx, cy, gamma1, gamma2, kappa, rho, lamda, delta, h)
  num = round(10 / h);    
  pos = zeros(n, 2, num);
  % Generating a random position for each bird in the given bounds.
  for i = 1:n
    pos(i,:,1) = [((xmax - xmin) * rand) + xmin, ((ymax - ymin) * rand) + ymin];
  end  
  
  t = 0;
  % Finding the x, y value at each time t for each bird
  for i = 1:num
    bird = pos(:,:,i);
    next = zeros(n, 2);
    
    % Center of the current flock
    centerx = sum(bird(:,1)) / n;
    centery = sum(bird(:,2)) / n;
    
    % Approximating the leader's next position at time t + h using
    % Euler
    %next(1, 1) = Euler(@(t, y) leader(t, y, cx, gamma1), t, bird(1, 1), h);
    %next(1, 2) = Euler(@(t, y) leader(t, y, cy, gamma1), t, bird(1, 2), h);
    
    % Runge Kutta.
    next(1, 1) = RK(@(t, y) leader(t, y, cx, gamma1), t, bird(1, 1), h);
    next(1, 2) = RK(@(t, y) leader(t, y, cy, gamma1), t, bird(1, 2), h);
     
    % Finding the x and y coordinates at time t + h for the rest of the flock
    
    for k = 2:n
      % Finding the lamda of current birds closest neighbors
      nlist = bird(1:n,:);
      nlist(k,:) = [];
      nindices = neighbor(bird(k,:), nlist, lamda);
    
      % Approximating the birds next position using Euler with the above parameters
      %next(k, 1) = Euler(@(t, y) equation(t, y, gamma2, bird(1, 1), kappa, centerx, rho, delta, nlist(nindices, 1)), t, bird(k, 1), h);
      %next(k, 2) = Euler(@(t, y) equation(t, y, gamma2, bird(1, 2), kappa, centery, rho, delta, nlist(nindices, 2)), t, bird(k, 2), h);
      
      % Approximating the birds next position using Runge Kutta with the above parameters
      next(k, 1) = RK(@(t, y) equation(t, y, gamma2, bird(1, 1), kappa, centerx, rho, delta, nlist(nindices, 1)), t, bird(k, 1), h);
      next(k, 2) = RK(@(t, y) equation(t, y, gamma2, bird(1, 2), kappa, centery, rho, delta, nlist(nindices, 2)), t, bird(k, 2), h);
     
    end
    
% Storing the information of next in the positions array and incrementing time.
    pos(:,:,i + 1) = next;
    t = t + h;
  end
end
  numframes = length(pos(1,1,:));
  mov(numframes) = struct('cdata',[],'colormap',[]);
  
  t = 0;
  for i=1:numframes
    curpositions = pos(:,:,i);
    mov(i) = birdframe(xmin, xmax, ymin, ymax, curpositions(:, 1)', curpositions(:, 2)', cx(t), cy(t));
    t = t + h;
  end
  
  name = strcat(filename, '.avi');
  video = VideoWriter(name, 'Uncompressed AVI');
  video.FrameRate = 12;
  open(video);
  writeVideo(video, mov);
  close(video);
end
