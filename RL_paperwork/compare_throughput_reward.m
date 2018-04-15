clc;
clear all;

start_slot = 1;
Num_slot = 5000;%100
S = 18;
%假设初始能量E
e = 0;              
k = 0.4;
Rate = 10;  
eta = 0.1;

ec = 1;%sensing
bc = 2;%backscattering

PT = [0.5 1 1.5 2];
action_QL = xlsread('QL_action.xls');
action_DP = xlsread('DP_action.xls');
action_TB = xlsread('TB_action.xls');
Test_channel1 = xlsread('Test_channel_10000.xlsx');
Test_channel = Test_channel1(start_slot:Num_slot,:);
current_chan = Test_channel(start_slot,:);%获取当前第一个slot的信道条件
E0 = zeros(3,1);E1 = ones(3,1);E2 = 2*ones(3,1);E3 = 3*ones(3,1);E4 = 4*ones(3,1);E5 = 5*ones(3,1);
%E6 = 6*ones(9,1);E7 = 7*ones(9,1);E8 = 8*ones(9,1);E9 = 9*ones(9,1);
E = [E0;E1;E2;E3;E4;E5];%E6;E7;E8;E9];
channel_h = [3; 2; 1];
C = repmat(channel_h,6,1);%信道空间3*3
channelstate = [E C];%马尔科夫状态空间

r_QL = zeros(1,4);
r_DP = zeros(1,4);
r_TB = zeros(1,4);
policy_DP = zeros(1,Num_slot);
policy_QL = zeros(1,Num_slot);
policy_TB = zeros(1,Num_slot);
R_b = 10;
T0 = 1;
sqrt_N = sqrt(20);
k = 0.4; 
meu = 0.8;
delta0 = 10^(-10);
deltas = 10^(-9);
delta = 4 * (delta0 + deltas);
B_mid = 3*10^(-5);
A_mid = 6*10^(-5);
G_mid = 9*10^(-5);
g = [B_mid A_mid G_mid];
h = 2*10^-5;
g_h = sqrt_N  * (meu^2) * g * h / delta;


for num=1:4
% N = N_1(num);
Pt = PT(num);
rwd_QL = 0;
rwd_DP = 0;
rwd_TB = 0;

Pb = 1/2 * erfc(Pt* g_h);
for i=1:3
    Cam(1,i) = 1 + Pb(1,i) * log(Pb(1,i))+(1 - Pb(1,i)) * log(1 - Pb(1,i));%从小到大
end
%3种条件下的误码率 ----以及对应的反射收益
R = k * Cam * R_b * T0; 
d1=1;
d2=1;
d3=1;

v3 = R(1,1);
v2 = R(1,2);
v1 = R(1,3);%max reward
reward =[0 v3;%g
         0 v2;
         0 v1;];
%*********************************%
%             DP                  %
%*********************************%
e1 = e;
current_chan1 =current_chan;
current_DPstate = [e1 current_chan1];
for slot=0:Num_slot-1
    for i = 1:S
        if channelstate(i,:)==current_DPstate
            action_t_DP = action_DP(i);
            if action_t_DP == 0
                e1 = e1 + current_chan1(1,1) - ec;
                e1 = min(e1,5);
                policy_DP(slot+1) = 0;
            else%action==1
                e1 = e1 - bc;
                policy_DP(slot+1) = 1;
                DPr = reward(current_chan1,2);
                rwd_DP = rwd_DP + DPr;
            end 
        end
    end
    next_chan = Test_channel(slot+1,:);
    current_chan1 = next_chan;
    next_DPstate = [e1 current_chan1];
    current_DPstate = next_DPstate;
end
r_DP(num) = rwd_DP / Num_slot;

%*********************************%
%             QL                  %
%*********************************%
e2 = e;
current_chan2 =current_chan;
current_QLstate = [e2 current_chan2];
for slot=0:Num_slot-1
    for i = 1:S
        if channelstate(i,:)==current_QLstate
            action_t_QL = action_QL(i);
            if action_t_QL==0                
                e2 = e2 + current_chan2(1,1) - ec;
                e2 = min(e2,5);
                policy_QL(slot+1) = 0;
            else%action==1
                e2 = e2 - bc;
                policy_QL(slot+1) = 1;
                QLr = reward(current_chan2,2);
                rwd_QL = rwd_QL + QLr;
            end 
        end
    end
    next_chan = Test_channel(slot+1,:);
    current_chan2 = next_chan;
    next_QLstate = [e2 current_chan2];
    current_QLstate = next_QLstate;
end
% QL_start = QL_rwd / N;
% QL_r = QL_start + QL_r;
r_QL(num) = rwd_QL / Num_slot;

%*********************************%
%             TB                  %
%*********************************%
e3 = e;
current_chan3 =current_chan;
current_TBstate = [e3 current_chan3];
for slot=0:Num_slot-1
    for i = 1:S
        if channelstate(i,:)==current_TBstate;
            action_t_TB = action_TB(i);
            if action_t_TB==0
                e3 = e3 + current_chan3(1,1) - ec; 
                e3 = min(e3,5);
                policy_TB(slot+1) = 0;
            else%action==1
                e3 = e3 - bc;
                policy_TB(slot+1) = 1;
                TBr = reward(current_chan3,2);
                rwd_TB = rwd_TB + TBr;
            end 
        end
    end
    next_chan = Test_channel(slot+1,:);
    current_chan3 = next_chan;
    next_TBstate = [e3 current_chan3];
    current_TBstate = next_TBstate;
end
r_TB(num) = rwd_TB / Num_slot;
% alldp(num) = rwd_DP;
% allql(num) = rwd_QL;
% alltb(num) = rwd_TB;
end
figure();
plot(PT,r_DP,'b',PT,r_QL,'r',PT,r_TB,'g');
grid on;
% figure()
% plot([1:4],alldp,'b',[1:4],allql,'r',[1:4],alltb,'g');

disp(['DP_Transrewrad' num2str(r_DP)]);
disp(['QL_Transrewrad' num2str(r_QL)]);
disp(['TB_Transrewrad' num2str(r_TB)]);
            
            
            
            
