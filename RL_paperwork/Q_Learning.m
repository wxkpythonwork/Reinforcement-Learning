clear all;
clc;
format short; %小数点后保留4位

S = 18;
Nchannel = xlsread('Train_channel_50.xlsx'); %时隙为 Nc = 50000;
QTab = zeros(S,2);
eta = 0.2;
gamma = 0.95;%折扣因子
epsilon = 0.10;%探索概率
[~, ~, reward, R] = channel_and_reward();

%初始化能量E=0
e = 0;
%初始化第一个slot的信道条件
current_chan = Nchannel(1,:);
state_inital = [e current_chan];

E0 = zeros(3,1);E1 = ones(3,1);E2 = 2*ones(3,1);E3 = 3*ones(3,1);E4 = 4*ones(3,1);E5 = 5*ones(3,1);
E = [E0;E1;E2;E3;E4;E5];
channel_h = [3; 2; 1];
C = repmat(channel_h,6,1);%信道空间3*3
channelstate = [E C];%马尔科夫状态空间
action = [0 1];%选取的动作
%reward = [v1 v2 v3 v4 v5 v6 v7 v8 v9];

QL_r = [];
QL_rwd = 0;
step = 10000;
periods = 45;
for episode=2:periods
    for slot=(episode-1) * step:(episode * step)
        s = [e current_chan];
        %找到状态当前所在的位置        
        for i = 1:size(channelstate,1)
            if channelstate(i,:) == s
                stateloc = i;
            end
        end        
        %获取下个信道条件值
        next_chan = Nchannel(slot + 1, :);
        
        if e < 2%能量小于2 只吸收能量转移到下一个状态
            a = 0;
            e_after = e + current_chan(1,1) - 1;%吸收能量后的E状态
            next_s = [e_after next_chan];
            for j = 1:size(channelstate, 1)
                if channelstate(j,:) == next_s
                    next_stateloc = j;
                end
            end
             QTab(stateloc,1) = QTab(stateloc,1) + eta * (R(stateloc,1) + gamma*max(QTab(next_stateloc,:)) - QTab(stateloc,1));
    
        else%>=2时，可以反射或吸收
            if unifrnd(0,1) < ((1 - episode / periods)*epsilon)%epsilon的概率随机
            %if unifrnd(0,1) < epsilon%epsilon的概率随机
                y = randperm(size(action,2));
                a = action(1);
                if a == 0
                    ee = e + current_chan(1,1) - 1;
                    e_after = min(ee,5);
                    next_s = [e_after next_chan];
                    for j=1:S
                        if channelstate(j,:)==next_s
                            next_stateloc = j;%吸收能量到达的下一个状态
                        end
                    end
                    QTab(stateloc,1) = QTab(stateloc,1) + eta * (R(stateloc,1) + gamma * max(QTab(next_stateloc,:)) - QTab(stateloc,1));
                else%a=1              
                    e_after = e - 2;
                    next_s = [e_after next_chan];
                    for j=1:size(channelstate,1)
                        if channelstate(j,:)==next_s
                            next_stateloc = j;%反射数据到达的下一个状态                    
                        end
                    end
                    QTab(stateloc,2) = QTab(stateloc,2) + eta *(R(stateloc,2) + gamma*max(QTab(next_stateloc,:)) - QTab(stateloc,2));                    
                    QL_rd = reward(current_chan,1);
                    QL_rwd = QL_rwd + QL_rd;
                end                
                
           else%其他正常取最大的作为下一个动作
                if QTab(stateloc,1) > QTab(stateloc,2) %harvest energy  
                    a = 0;
                    ee = e + current_chan(1,1) - 1;
                    e_after = min(ee,5);                
                    next_s = [e_after next_chan];           
                    for j=1:size(channelstate,1)
                        if channelstate(j,:)==next_s;               
                            next_stateloc = j;%吸收能量到达的下一个状态                                              
                        end
                    end 
                    QTab(stateloc,1) = QTab(stateloc,1) + eta *(R(stateloc,1) + gamma*max(QTab(next_stateloc,:)) - QTab(stateloc,1));
                else%a=1
                    a = 1;
                    e_after = e - 2;
                    next_s = [e_after next_chan];
                    for j=1:size(channelstate,1)
                        if channelstate(j,:)==next_s
                            next_stateloc = j;%反射数据到达的下一个状态                     
                        end
                    end
                    QTab(stateloc,2) = QTab(stateloc,2) + eta *(R(stateloc,2) + gamma*max(QTab(next_stateloc,:)) - QTab(stateloc,2));
                    QL_rd = reward(current_chan,1);
                    QL_rwd = QL_rwd + QL_rd;
                end                             
            end                                     
        end
        e = e_after;
        current_chan = next_chan;
 end
    QL_r(episode) = QL_rwd / (episode*step);
   
end
QL_action = zeros(S,1);
for i=1:S
    if QTab(i,1) >= QTab(i,2)
        QL_action(i,1) = 0;
    else
        QL_action(i,1) = 1;
    end
end
plot([0:periods-1],QL_r, 'r');
grid on;
xlswrite('Q_Tab.xls',QTab);
xlswrite('QL_action.xls',QL_action);








