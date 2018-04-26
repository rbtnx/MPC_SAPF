function y = discrete_diff(u,ts)
y = zeros(1, length(u));
for i=2:length(u)
    y(i) = (u(i) - u(i-1))/ts;
end
end