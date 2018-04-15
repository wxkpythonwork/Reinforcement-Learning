clear all;
clc;
format short; %小数点后保留4位

S = 18;
k = 0.4; 
eta = 0.2;
gamma = 0.9;%折扣因子
epsilon = 0.10;%探索概率
[~,~,~,R] = Rewardmat();
q = zeros(S, S);
q1 = ones(size(R)) * inf;
n = 0;
count = 0;

while(1)
    n = n + 1;
    disp(['迭代次数 n = ' num2str(n)]);    
    state  = randperm(size(R,1));
    s = state(1);
    tmp = q;
    idx = find(R(s, :) >= 0);
    if s <= 6        
        y = RandomPermutation(idx);
        a = y(1);  
%         [value, choice] = find(R(s, :) >= 0);
%         [value, idx] = sort(value);%默认从小到大排列的
%         a = choice(idx(length(idx)));%取最大值对应的下标
%         s_next = a;
%         max_a = max(q(s_next, :));
%         q(s, a) = q(s, a) + eta * (R(s, a) + gamma * max_a - q(s, a));
    else       
        if unifrnd(0,1) < epsilon%epsilon的概率随机            
            y = RandomPermutation(idx);
            a = y(1);      
        else            
            value = max(q(s, idx));%取最大值对应的下标                  
            index = find(value == q(s, idx));
            a = idx(index(1));
        end  
    end
    qMax = max(q, [], 2);
    q(s, a) = q(s, a) + eta * (R(s, a) + gamma * qMax(a) - q(s, a));
    %q(s, a) = R(s, a) + gamma * qMax(a);   % get max of all actions
    s = a;   
    %gap = max(max(abs(tmp - q)))找最大的对应位置 [x y] = find(gap == max(max(abs(tmp - Q_sa))));
    if sum(sum(abs(q1 - q))) < 0.0001 && sum(sum(q > 0))
        if count > 10
            break;
        else
            count = count + 1;
        end
    else
        q1 = q;
        count = 0; %当q与前q的偏差较大时，重置计数器。
    end
end




