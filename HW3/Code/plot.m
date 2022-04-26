

x = load('output.txt');

set(gca,'fontsize',18)
loglog(x(:,1),x(:,2:5),'.-',x(:,1),x(:,1).^-3,x(1:50,1),10.0.^(-0.3*x(1:50,1)),x(1:20,1),2.5.^(-1.7*x(1:20,1)),'--','linewidth',2)
xlabel('Number of Divisions(n)')
ylabel('Relative Error')
legend('Trapezoidal, k = \pi','Trapezoidal, k = \pi^2','Gauss-Quad, k = \pi','Gauss-Quad, k = \pi^2','Order n^3 convergence','e(n) = 10^{-0.3n}','e(n) = 2.5^{-1.7n}')
title('Integral Comparisons')
  grid on;
axis = [0 1500 10^-18 10];

print -depsc2 error_v3
print -dpng error_v3
