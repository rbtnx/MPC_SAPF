function [psi,ups,theta,gamma] = mpc_matrixSetup(A,B,Bd,Hp,Hu)

n = size(A,1);             % System order
m = size(B,2);             % Number of inputs
d = size(Bd,2);            % Number of distrubances
psi = zeros(Hp*n,n);       % Matrix psi init
ups = zeros(Hp*n,m);       % Matrix ups init
theta = zeros(Hp*n,Hu*m);  % Matrix theta init
gamma = zeros(Hp*n,Hp*d);  % Matrix gamma init
psi(1:n,:) = A;            % Matrix psi first element 
ups(1:n,:) = B;            % Matrix ups first element
theta(1:n,1:m) = B;        % Matrix theta first element
gamma(1:n,1:d) = Bd;       % Matrix gamma first element
%   Matrix second elements
psi(n+1:2*n,:) = psi(1:n,:)*A; 
ups(n+1:2*n,:) = psi(1:n,:)*B+B;
theta(n+1:2*n,1:m) = psi(1:n,:)*B+B;
theta(n+1:2*n,m+1:2*m) = B;
gamma(n+1:2*n,1:d) = psi(1:n,:)*Bd;
gamma(n+1:2*n,d+1:2*d) = Bd;
for k=3:Hp                 % Iteratively build the matrices 
    psi((k-1)*n+1:k*n,:) = psi((k-2)*n+1:(k-1)*n,:)*A; 
    ups((k-1)*n+1:k*n,:) = ups((k-2)*n+1:(k-1)*n,:)+psi((k-2)*n+1:(k-1)*n,:)*B;
    theta((k-1)*n+1:k*n,1:m) = ups((k-1)*n+1:k*n,:);        % First Block
    gamma((k-1)*n+1:k*n,1:d) = psi((k-2)*n+1:(k-1)*n,:)*Bd; % First Block
    for l=2:min(k,Hu)
        theta((k-1)*n+1:k*n,(l-1)*m+1:l*m) = theta((k-l)*n+1:(k-l+1)*n,1:m);    % Consecutive blocks      
    end
    for l=2:k
        gamma((k-1)*n+1:k*n,(l-1)*d+1:l*d) = gamma((k-l)*n+1:(k-l+1)*n,1:d);    % Consecutive blocks   
    end
end