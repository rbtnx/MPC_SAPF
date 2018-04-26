%Distorted_current_input Parameters
clearvars;

%% Simulation setup
num=1000;
hp=num;
hu=hp;
f=50;
ts = 1/f/num;
periods = 10;
l = num*periods;
simend = hp*periods*ts;
t=0:ts:simend-ts; 
Am = 230*sqrt(2);
w = 2*pi*f;
mtd=3;

%% Circuit Parameters
Rline=1;           % Supply transmission resistance [Ohm]
Lline=1e-5;        % Supply transmission inductance [H]

%% State Space Model
A1=[0 -Rline Rline; 0 0 0; 0 0 0];
BT1=[-Lline Lline; 1 0; 0 1];
B1=BT1(:,1);
Bd1=BT1(:,2);
C1=eye(size(A1,1));
D1=zeros(size(C1,1),size(BT1,2));

%% Discretization
[A,BT,C,D]=cont2disczoh(A1,BT1,C1,D1,ts);
B=BT(:,1:size(B1,2));
Bd=BT(:,size(B1,2)+1:size(BT1,2));

%% Q&R matrix construction
alpha=1/ts^2*[2+(w*ts)^2 -5 4 -1];   % State coefficients (y''= -(w^2)y)
str=1*10^3;                          % State strenght on the Q matrix [IL IS]
%%%% Tuning for 1000 samples -> thd 2.6%
%%%%R=7*10^(+4-0)*eye(hu*size(B,2));     % R cost of changes matrix

R=1*10^(+5-0)*eye(hu*size(B,2));     % R cost of changes matrix

%% P_v matrix
s = 1;
T = length(alpha);
N = 3;

V = zeros(s,N*T);
V(1,1:N:N*T)= alpha*sqrt(str(1));

Pv = zeros(s*(hp-T+1),N*hp);
for k=0:(hp-T)
   Pv(k*s+1:(k+1)*s,(k*N+1):(k*N+N*T))=V;
end
QPv = Pv'*Pv;
% norm(Pv'*Pv-Q)
Q=QPv;
SQ=Pv;
SR=chol(R);

%% SDMPC
[psi,ups,theta,gamma] = mpc_matrixSetup(A,B,Bd,hp,hu);
ref=zeros(1,(hp+1)*size(A,1));  % Reference of zeros
ref=[reshape(ref,length(ref)/size(A,1),size(A,1))]';
ref=ref(:);

%% Signals
VS = Am*sin(w*t);
vs(:,1) = t';
vs(:,2) = VS';

i_c = 0*ones(1,l);
ic0(:,1) = t';
ic0(:,2) = i_c';

i_l = 0*ones(1,l);
il(:,1) = t';
il(:,2) = i_l';

%% Calculated Input
% load('ic_1000s_200p');
% ic(:,1) = t';
% ic(:,2) = ic_1000s_200p;