function [P0, P1, Reward_all, Reward] = channel_and_reward()
Pt = 2;
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
Pb = 1/2 * erfc(Pt* g_h);
for i=1:3
    C(1,i) = 1 + Pb(1,i) * log(Pb(1,i))+(1 - Pb(1,i)) * log(1 - Pb(1,i));%从小到大
end
%3种条件下的误码率 ----以及对应的反射收益
R = k * C * R_b * T0; 
gr = R(1,3);
ar = R(1,2);
br = R(1,1);
m=0;
Reward_all = [ar;
              br;
              gr;];
Reward = [m, -1;
          m, -1;
          m, -1;
          m, -1;
          m, -1;
          m, -1;
          m, gr;
          m, ar;
          m, br;
          m, gr;
          m, ar;
          m, br;
          m, gr;
          m, ar;
          m, br;
          m, gr;
          m, ar;
          m, br;];
Rd_matrix = [-1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1;
             -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1;
             -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1;
             -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1;%E=1;
             -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1;
             -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1;
             gr, gr, gr, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1;%E=2;
             ar, ar, ar, -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1, -1, -1, -1;
             br, br, br, -1, -1, -1, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1;
             -1, -1, -1, gr, gr, gr, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0;%E=3;
             -1, -1, -1, ar, ar, ar, -1, -1, -1, -1, -1, -1, 0, 0, 0, -1, -1, -1;
             -1, -1, -1, br, br, br, -1, -1, -1, 0, 0, 0, -1, -1, -1, -1, -1, -1;
             -1, -1, -1, -1, -1, -1, gr, gr, gr, -1, -1, -1, -1, -1, -1, 0, 0, 0;%E=4;
             -1, -1, -1, -1, -1, -1, ar, ar, ar, -1, -1, -1, -1, -1, -1, 0, 0, 0;
             -1, -1, -1, -1, -1, -1, br, br, br, -1, -1, -1, 0, 0, 0, -1, -1, -1;
             -1, -1, -1, -1, -1, -1, -1, -1, -1, gr, gr, gr, -1, -1, -1, 0, 0, 0;%E=5;
             -1, -1, -1, -1, -1, -1, -1, -1, -1, ar, ar, ar, -1, -1, -1, 0, 0, 0;
             -1, -1, -1, -1, -1, -1, -1, -1, -1, br, br, br, -1, -1, -1, 0, 0, 0];
         
g_g=0.20;g_a=0.30;g_b=0.50;
a_g=0.20;a_a=0.30;a_b=0.50;
b_g=0.35;b_a=0.20;b_b=0.45;
c0 = zeros(1,3);
c1 = [g_g g_a g_b];
c2 = [a_g a_a a_b];
c3 = [b_g b_a b_b];
% backscatter from e =2, energy -2, ----Harvest G=3-1, A = 2-1; B = 1-1;
P0 = [c0 c0 c1 c0 c0 c0;%e = 0
      c0 c2 c0 c0 c0 c0;
      c3 c0 c0 c0 c0 c0;
      c0 c0 c0 c1 c0 c0;%e = 1
      c0 c0 c2 c0 c0 c0;
      c0 c3 c0 c0 c0 c0;
      c0 c0 c0 c0 0.5*c1 c0;%e = 2
      c0 c0 c0 0.5*c2 c0 c0;
      c0 c0 0.5*c3 c0 c0 c0;
      c0 c0 c0 c0 c0 0.5*c1;%e = 3
      c0 c0 c0 c0 0.5*c2 c0;
      c0 c0 c0 0.5*c3 c0 c0;
      c0 c0 c0 c0 c0 0.5*c1;%e = 4
      c0 c0 c0 c0 c0 0.5*c2;
      c0 c0 c0 c0 0.5*c3 c0;
      c0 c0 c0 c0 c0 0.5*c1;%e = 5
      c0 c0 c0 c0 c0 0.5*c2;
      c0 c0 c0 c0 c0 0.5*c3];
  
P1 = [c0 c0 c0 c0 c0 c0;% e = 0
      c0 c0 c0 c0 c0 c0;
      c0 c0 c0 c0 c0 c0;
      c0 c0 c0 c0 c0 c0;% e = 1
      c0 c0 c0 c0 c0 c0;
      c0 c0 c0 c0 c0 c0;
      0.5*c1 c0 c0 c0 c0 c0;% e = 2
      0.5*c2 c0 c0 c0 c0 c0;
      0.5*c3 c0 c0 c0 c0 c0;
      c0 0.5*c1 c0 c0 c0 c0;% e = 3
      c0 0.5*c2 c0 c0 c0 c0;
      c0 0.5*c3 c0 c0 c0 c0;
      c0 c0 0.5*c1 c0 c0 c0;% e = 4
      c0 c0 0.5*c2 c0 c0 c0;
      c0 c0 0.5*c3 c0 c0 c0;
      c0 c0 c0 0.5*c1 c0 c0;% e = 5
      c0 c0 c0 0.5*c2 c0 c0;
      c0 c0 c0 0.5*c3 c0 c0];
  end








% 
% %Backscatter -3 from E =3 start;
% P0 = [c0 c0 c1 c0 c0 c0 c0 c0 c0 c0;c0 c2 c0 c0 c0 c0 c0 c0 c0 c0;c3 c0 c0 c0 c0 c0 c0 c0 c0 c0;%e = 0
%       c0 c0 c0 c1 c0 c0 c0 c0 c0 c0;c0 c0 c2 c0 c0 c0 c0 c0 c0 c0;c0 c3 c0 c0 c0 c0 c0 c0 c0 c0;
%       c0 c0 c0 c0 c1 c0 c0 c0 c0 c0;c0 c0 c0 c2 c0 c0 c0 c0 c0 c0;c0 c0 c3 c0 c0 c0 c0 c0 c0 c0;% e = 2
%       c0 c0 c0 c0 c0 0.5*c1 c0 c0 c0 c0;c0 c0 c0 c0 0.5*c2 c0 c0 c0 c0 c0;c0 c0 c0 0.5*c3 c0 c0 c0 c0 c0 c0;%e = 3
%       c0 c0 c0 c0 c0 c0 0.5*c1 c0 c0 c0;c0 c0 c0 c0 c0 0.5*c2 c0 c0 c0 c0;c0 c0 c0 c0 0.5*c3 c0 c0 c0 c0 c0;
%       c0 c0 c0 c0 c0 c0 c0 0.5*c1 c0 c0;c0 c0 c0 c0 c0 c0 0.5*c2 c0 c0 c0;c0 c0 c0 c0 c0 0.5*c3 c0 c0 c0 c0;%e = 5
%       c0 c0 c0 c0 c0 c0 c0 c0 0.5*c1 c0;c0 c0 c0 c0 c0 c0 c0 0.5*c2 c0 c0;c0 c0 c0 c0 c0 c0 0.5*c3 c0 c0 c0;
%       c0 c0 c0 c0 c0 c0 c0 c0 c0 0.5*c1;c0 c0 c0 c0 c0 c0 c0 c0 0.5*c2 c0;c0 c0 c0 c0 c0 c0 c0 0.5*c3 c0 c0;%e = 7
%       c0 c0 c0 c0 c0 c0 c0 c0 c0 0.5*c1;c0 c0 c0 c0 c0 c0 c0 c0 c0 0.5*c2;c0 c0 c0 c0 c0 c0 c0 c0 0.5*c3 c0;
%       c0 c0 c0 c0 c0 c0 c0 c0 c0 0.5*c1;c0 c0 c0 c0 c0 c0 c0 c0 c0 0.5*c2;c0 c0 c0 c0 c0 c0 c0 c0 c0 0.5*c3];%e = 9
% P1 = [c0 c0 c0 c0 c0 c0 c0 c0 c0 c0;c0 c0 c0 c0 c0 c0 c0 c0 c0 c0;c0 c0 c0 c0 c0 c0 c0 c0 c0 c0;% 0
%       c0 c0 c0 c0 c0 c0 c0 c0 c0 c0;c0 c0 c0 c0 c0 c0 c0 c0 c0 c0;c0 c0 c0 c0 c0 c0 c0 c0 c0 c0;% 1
%       c0 c0 c0 c0 c0 c0 c0 c0 c0 c0;c0 c0 c0 c0 c0 c0 c0 c0 c0 c0;c0 c0 c0 c0 c0 c0 c0 c0 c0 c0;% 2
%       0.5* c1 c0 c0 c0 c0 c0 c0 c0 c0 c0;0.5*c2 c0 c0 c0 c0 c0 c0 c0 c0 c0;0.5*c3 c0 c0 c0 c0 c0 c0 c0 c0 c0;% 3
%       c0 0.5*c1 c0 c0 c0 c0 c0 c0 c0 c0;c0 0.5*c2 c0 c0 c0 c0 c0 c0 c0 c0;c0 0.5*c3 c0 c0 c0 c0 c0 c0 c0 c0;
%       c0 c0 0.5*c1 c0 c0 c0 c0 c0 c0 c0;c0 c0 0.5*c2 c0 c0 c0 c0 c0 c0 c0;c0 c0 0.5*c3 c0 c0 c0 c0 c0 c0 c0;
%       c0 c0 c0 0.5*c1 c0 c0 c0 c0 c0 c0;c0 c0 c0 0.5*c2 c0 c0 c0 c0 c0 c0;c0 c0 c0 0.5*c3 c0 c0 c0 c0 c0 c0;
%       c0 c0 c0 c0 0.5*c1 c0 c0 c0 c0 c0;c0 c0 c0 c0 0.5*c2 c0 c0 c0 c0 c0;c0 c0 c0 c0 0.5*c3 c0 c0 c0 c0 c0;
%       c0 c0 c0 c0 c0 0.5*c1 c0 c0 c0 c0;c0 c0 c0 c0 c0 0.5*c2 c0 c0 c0 c0;c0 c0 c0 c0 c0 0.5*c3 c0 c0 c0 c0;
%       c0 c0 c0 c0 c0 c0 0.5*c1 c0 c0 c0;c0 c0 c0 c0 c0 c0 0.5*c2 c0 c0 c0;c0 c0 c0 c0 c0 c0 0.5*c3 c0 c0 c0];
%       %c0 c0 c0 c0 c0 c0 c0 0.5*c1 c0 c0;c0 c0 c0 c0 c0 c0 c0 0.5*c2 c0 c0;c0 c0 c0 c0 c0 c0 c0 0.5*c3 c0 c0];
% end



