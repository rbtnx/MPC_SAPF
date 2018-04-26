function [y x]=discss(A,B,C,D,u,x0)
% Discrete State Space Simulation
x(:,1)=x0;
for k=1:size(u,2)
x(:,k+1)=A*x(:,k)+B*u(:,k);
y(:,k)=C*x(:,k)+D*u(:,k);
end