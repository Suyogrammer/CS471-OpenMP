function final = RK(f,ti,ui,h)
  K1 = f(ti,ui);
  K2 = f(ti+(h*(1/2)),ui+(h*(1/2))*K1);
  K3 = f(ti+(h*0.5),ui+(h.*0.5)*K2);
  K4 = f(ti+h,ui+h*K3);
  final = ui + (1/6)* h *(K1 + 2*K2 + 2*K3 + K4);
end
