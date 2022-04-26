function slope = smelly(~, b, gamma, lead, kappa, center)
  leader = gamma * (lead - b);
  flock = kappa * (center - b);
  slope = leader + flock;
end
