N = 500000;
prob0 = [1/3 1/3 1/3];
channel = [1 2 3];
prob1 = [0.2 0.6 0.2];
prob2 = [0.15 0.6 0.25];
prob3 = [0.2 0.5 0.3];
% prob1 = [0.50 0.24 0.26];
% prob2 = [0.34 0.45 0.21];
% prob3 = [0.25 0.30 0.45];

h1_N = zeros(N,1);
%¿ªÊ¼
h0 = randsrc(1,1,[channel; prob0]);
h1_N(1,1)=h0;
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
%xlswrite('N_channel_10.xlsx',N_channel,'sheet1','A1:B100000');
xlswrite('Train_channel_50.xlsx',N_channel);


