clear all;
clc;

Pt = 2;
R_b = 10;
T0 = 1;
sqrt_N = sqrt(25);
k = 1; 
meu = 0.8;
delta0 = 10^(-10);
deltas = 10^(-9);
delta = 4 * (delta0 + deltas);
num = 20;
g = linspace(1*10^-5, 1*10^-4, num);
h = 4*10^-5;
g_h = sqrt_N  * (meu^2) * g * h / delta;
Pb = 1/2 * erfc(Pt * g_h);
for i=1:num
    C(1,i) = 1 + Pb(1,i) * log(Pb(1,i))+(1 - Pb(1,i)) * log(1 - Pb(1,i));
end
R = C * R_b * T0; 
figure();
plot(g,R,'red');
hold on;
T_Good = 7*10^-5;
T_Bad = 5*10^-5;