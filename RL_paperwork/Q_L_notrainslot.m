clear all;
clc;
format short; %С�������4λ

S = 18;
k = 0.4; 
eta = 0.2;
gamma = 0.9;%�ۿ�����
epsilon = 0.10;%̽������
[~,~,~,R] = Rewardmat();
q = zeros(S, S);
q1 = ones(size(R)) * inf;
n = 0;
count = 0;

while(1)
    n = n + 1;
    disp(['�������� n = ' num2str(n)]);    
    state  = randperm(size(R,1));
    s = state(1);
    tmp = q;
    idx = find(R(s, :) >= 0);
    if s <= 6        
        y = RandomPermutation(idx);
        a = y(1);  
%         [value, choice] = find(R(s, :) >= 0);
%         [value, idx] = sort(value);%Ĭ�ϴ�С�������е�
%         a = choice(idx(length(idx)));%ȡ���ֵ��Ӧ���±�
%         s_next = a;
%         max_a = max(q(s_next, :));
%         q(s, a) = q(s, a) + eta * (R(s, a) + gamma * max_a - q(s, a));
    else       
        if unifrnd(0,1) < epsilon%epsilon�ĸ������            
            y = RandomPermutation(idx);
            a = y(1);      
        else            
            value = max(q(s, idx));%ȡ���ֵ��Ӧ���±�                  
            index = find(value == q(s, idx));
            a = idx(index(1));
        end  
    end
    qMax = max(q, [], 2);
    q(s, a) = q(s, a) + eta * (R(s, a) + gamma * qMax(a) - q(s, a));
    %q(s, a) = R(s, a) + gamma * qMax(a);   % get max of all actions
    s = a;   
    %gap = max(max(abs(tmp - q)))�����Ķ�Ӧλ�� [x y] = find(gap == max(max(abs(tmp - Q_sa))));
    if sum(sum(abs(q1 - q))) < 0.0001 && sum(sum(q > 0))
        if count > 10
            break;
        else
            count = count + 1;
        end
    else
        q1 = q;
        count = 0; %��q��ǰq��ƫ��ϴ�ʱ�����ü�������
    end
end




