clear all;
clc;

%%--改--%%
S = 18;
gamma = 0.88;
[P0, P1, R, ~] = Rewardmat();
%初始化
V = zeros(S,1);
n = 0;
delta = 10^-6;
while(1)
    n = n + 1;
    temp = V;
    disp(['迭代次数 n = ' num2str(n)]);
    for s=1:S
        Qs_0 = R(:,1) + gamma * P0 * V;%E
        Qs_1 = R(:,2) + gamma * P1 * V;%B
        Qs_a = [Qs_0 Qs_1];
        V(s) = max(Qs_a(s,:),[],2);
    end
    %循环退出判断;
    value = abs(temp - V);
    gap = max(value,[],2);
    if gap < delta
        break;
    end
end
action = zeros(S,1);
for i=1:S
    if Qs_a(i,1) > Qs_a(i,2)
        action(i,1) = 0;
    else
        action(i,1) = 1;
    end
end
disp(action');
% xlswrite('DP_value.xls',V);
xlswrite('DP_action.xls',action);


