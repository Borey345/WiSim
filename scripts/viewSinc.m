a = 1;
tau = 1;
omega = -10:0.1:10;
F = (2*a*sin(tau.*omega/2))./( sqrt(2*pi).*omega );
plot(F, 'b')
hold on

(a*tau)/(sqrt(2*pi))