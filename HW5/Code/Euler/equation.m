function slope = equation(~, b, gamma, leader, kappa, center, rho, delta, neighbors)
  leaderterm = gamma * (leader - b);
  flockterm = kappa * (center - b);
  repulsionterm = 0;
  for bm = neighbors'
    s = (b - bm) / ((b - bm)^2 + delta);
    repulsionterm = repulsionterm + s;
  end
  repulsionterm = repulsionterm * rho;
  slope = leaderterm + flockterm + repulsionterm;
end
