function slope = equation(~, b, gamma, lead, kappa, center, rho, delta, neighbors, smellyRho, smell)
  leader = gamma * (lead - b);
  flock = kappa * (center - b);
  smelly = smellyRho * ((b - smell) / ((b - smell)^2 + delta));
  repel = 0;
  for bm = neighbors'
    s = (b - bm) / ((b - bm)^2 + delta);
    repel = repel + s;
  end
  repel = repel * rho;
  slope = leader + flock + repel + smelly;
end
