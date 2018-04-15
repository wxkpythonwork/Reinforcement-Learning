clc;

N = 1000000;
prob0 = [1/3 1/3 1/3];
channel = [1 2 3];
prob1 = [0.3 0.5 0.2];
prob2 = [0.30 0.55 0.15];
prob3 = [0.15 0.6 0.25];
% g_g=0.30;g_a=0.50;g_b=0.20;
% a_g=0.30;a_a=0.55;a_b=0.15;
% b_g=0.15;b_a=0.6;b_b=0.25;

h1_N = zeros(N,1);
%¿ªÊ¼
h0 = randsrc(1,1,[channel; prob0]);
h1_N(1,1) = h0;
for i=1:N-1
    if  h0 == 1
        h = randsrc(1,1,[channel; prob1]);
    elseif h0 == 2
        h = randsrc(1,1,[channel; prob2]);
    elseif h0 == 3
        h = randsrc(1,1,[channel; prob3]);
    end
    
    h1_N(i+1,1) = h;
    h0 = h;
end

N_channel = h1_N;
xlswrite('Train_channel_100.xlsx',N_channel)%,'sheet1','A1:B100000');
% xlswrite('Test_channel_10000.xlsx',N_channel);


