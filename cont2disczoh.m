function [Ad Bd Cd Dd]=cont2disczoh(A,B,C,D,ts)
%Zero Order Hold discretization
Ad=expm(A*ts);
fun=@(x) expm(A.*x);
Bd=integral(fun,0,ts,'ArrayValued',true)*B;
Cd=C;
Dd=D;

