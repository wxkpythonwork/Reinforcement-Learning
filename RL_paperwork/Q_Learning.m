clear all;
clc;
format short; %С�������4λ

S = 18;
Nchannel = xlsread('Train_channel_50.xlsx'); %ʱ϶Ϊ Nc = 50000;
QTab = zeros(S,2);
eta = 0.2;
gamma = 0.95;%�ۿ�����
epsilon = 0.10;%̽������
[~, ~, reward, R] = channel_and_reward();

%��ʼ������E=0
e = 0;
%��ʼ����һ��slot���ŵ�����
current_chan = Nchannel(1,:);
state_inital = [e current_chan];

E0 = zeros(3,1);E1 = ones(3,1);E2 = 2*ones(3,1);E3 = 3*ones(3,1);E4 = 4*ones(3,1);E5 = 5*ones(3,1);
E = [E0;E1;E2;E3;E4;E5];
channel_h = [3; 2; 1];
C = repmat(channel_h,6,1);%�ŵ��ռ�3*3
channelstate = [E C];%����Ʒ�״̬�ռ�
action = [0 1];%ѡȡ�Ķ���
%reward = [v1 v2 v3 v4 v5 v6 v7 v8 v9];

QL_r = [];
QL_rwd = 0;
step = 10000;
periods = 45;
for episode=2:periods
    for slot=(episode-1) * step:(episode * step)
        s = [e current_chan];
        %�ҵ�״̬��ǰ���ڵ�λ��        
        for i = 1:size(channelstate,1)
            if channelstate(i,:) == s
                stateloc = i;
            end
        end        
        %��ȡ�¸��ŵ�����ֵ
        next_chan = Nchannel(slot + 1, :);
        
        if e < 2%����С��2 ֻ��������ת�Ƶ���һ��״̬
            a = 0;
            e_after = e + current_chan(1,1) - 1;%�����������E״̬
            next_s = [e_after next_chan];
            for j = 1:size(channelstate, 1)
                if channelstate(j,:) == next_s
                    next_stateloc = j;
                end
            end
             QTab(stateloc,1) = QTab(stateloc,1) + eta * (R(stateloc,1) + gamma*max(QTab(next_stateloc,:)) - QTab(stateloc,1));
    
        else%>=2ʱ�����Է��������
            if unifrnd(0,1) < ((1 - episode / periods)*epsilon)%epsilon�ĸ������
            %if unifrnd(0,1) < epsilon%epsilon�ĸ������
                y = randperm(size(action,2));
                a = action(1);
                if a == 0
                    ee = e + current_chan(1,1) - 1;
                    e_after = min(ee,5);
                    next_s = [e_after next_chan];
                    for j=1:S
                        if channelstate(j,:)==next_s
                            next_stateloc = j;%���������������һ��״̬
                        end
                    end
                    QTab(stateloc,1) = QTab(stateloc,1) + eta * (R(stateloc,1) + gamma * max(QTab(next_stateloc,:)) - QTab(stateloc,1));
                else%a=1              
                    e_after = e - 2;
                    next_s = [e_after next_chan];
                    for j=1:size(channelstate,1)
                        if channelstate(j,:)==next_s
                            next_stateloc = j;%�������ݵ������һ��״̬                    
                        end
                    end
                    QTab(stateloc,2) = QTab(stateloc,2) + eta *(R(stateloc,2) + gamma*max(QTab(next_stateloc,:)) - QTab(stateloc,2));                    
                    QL_rd = reward(current_chan,1);
                    QL_rwd = QL_rwd + QL_rd;
                end                
                
           else%��������ȡ������Ϊ��һ������
                if QTab(stateloc,1) > QTab(stateloc,2) %harvest energy  
                    a = 0;
                    ee = e + current_chan(1,1) - 1;
                    e_after = min(ee,5);                
                    next_s = [e_after next_chan];           
                    for j=1:size(channelstate,1)
                        if channelstate(j,:)==next_s;               
                            next_stateloc = j;%���������������һ��״̬                                              
                        end
                    end 
                    QTab(stateloc,1) = QTab(stateloc,1) + eta *(R(stateloc,1) + gamma*max(QTab(next_stateloc,:)) - QTab(stateloc,1));
                else%a=1
                    a = 1;
                    e_after = e - 2;
                    next_s = [e_after next_chan];
                    for j=1:size(channelstate,1)
                        if channelstate(j,:)==next_s
                            next_stateloc = j;%�������ݵ������һ��״̬                     
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








