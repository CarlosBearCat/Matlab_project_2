%%Carlos Luevanos 
%%9 - 26 - 16
%% Project 2: Finance; Stock Performance comparison

clear all;
close all;
clc;

%%1. Load in data

A = load('returns_a.dat'); %Stocks A 
B = load('returns_b.dat'); %Stocks B 

%%extract size of dimension of data sets
[ndays,~] = size(A);

x = 1: ndays; % x for plotting purposes

%%Acquire daily rates of reurn for data sets

percent_daily_ROR_A = A(:,2); %A
percent_daily_ROR_B = B(:,2); %B

%%Convert to decimal

daily_ROR_A = percent_daily_ROR_A/100;
daily_ROR_B = percent_daily_ROR_B/100;

%%2.Difference between A and B

daily_ROR_X = daily_ROR_A - daily_ROR_B; %converting from percent to decimal is done here


%%3. Calculate and plot a line chart for cumulative daily ROR for A and B
%% in a left-right split subplot. Compare their cumulative rates of returns  
%% at the end of the time period

%%compute cumulative ROR for A 
cum_ROR_A = zeros(ndays,1); % cumulative daily ROR for A
cum_ROR_A(1)= daily_ROR_A(1);

for i = 2: ndays
      cum_ROR_A(i) = (cum_ROR_A(i - 1) + 1) * (1 + daily_ROR_A(i)) - 1;
end


%%compute cumulative ROR for B
cum_ROR_B = zeros(ndays,1); %cumulative daily ROR for B
cum_ROR_B(1) = daily_ROR_B(1);

for i = 2: ndays
    cum_ROR_B(i) = (cum_ROR_B(i-1)+1) * (1 + daily_ROR_B(i)) - 1;
end

%%percentages
percent_cum_ROR_A = cum_ROR_A * 100;
percent_cum_ROR_B = cum_ROR_B * 100;

set(gcf,'Renderer','zbuffer')
%%plot graphs 

figure(1)
subplot(1,2,1); %subplot 1
plot(x, percent_cum_ROR_A, 'r', 'LineWidth',2);
title('Cumulative rate of return for A');
xlabel('Days');
ylabel('Percentage');
grid on;

subplot(1,2,2); %subplot 2
plot(x, percent_cum_ROR_B, 'b', 'LineWidth',2);
title('Cumulative rate of return for B');
xlabel('Days');
ylabel('Percentage');
grid on;




%%4. Plot a bar chart for the cumulative rate of return for X: black bars
%%for positive and magenta bars for negative

cum_ROR_X = zeros(ndays, 1); %% compute cumulative ROR for X
cum_ROR_X(1) = daily_ROR_X(1);

for i = 2:ndays
    cum_ROR_X(i) = (cum_ROR_X(i - 1) + 1 ) * (1 + daily_ROR_X(i)) - 1;
end
percent_cum_ROR_X = cum_ROR_X * 100;

pos = max(0, percent_cum_ROR_X); %%positive values
neg = min(0, percent_cum_ROR_X); %%negative values

figure(2)
bar(x, pos, 'k'); hold on
bar(x, neg, 'm');
title('Cumulative rate of return for X','FontSize',16, 'FontWeight','bold');
xlabel('Days');
ylabel('Percentage');
set(gca, 'FontSize',16, 'FontWeight','bold');
grid on;

%%5. Calculate the annualized daily return and annualized daily volatility for X
 
ave_daily_ROR_X = (cumprod(1 + daily_ROR_X)).^(1/ndays)-1; %first calculate average

anu_daily_ROR_X = (1 + ave_daily_ROR_X).^(252) - 1;% anualized daily ROR for x

vol_ave_daily_X = std(daily_ROR_X); % calculate average daily volatility
vol_anu_daily_X = vol_ave_daily_X * sqrt(252); %annualized daily volatility



% %6.  Calculate the ratio of the annualized daily return for X to the annualized daily volatility of X.
% % This term is called the “Information Ratio”. In finance term, it measures excess return of A
% % over B per unit of extra risk.

IR = anu_daily_ROR_X(end)/vol_anu_daily_X;

%%7. display ratio in command window
fprintf('The IR for the stock is: %.4f',IR);

%%Based on the graphs and calucations done for this project, stock A is not
%%a good investment. After plotting line charts for both stocks, it was
%%easy to see that stock B was a far better investment. Sure, stock A might
%%have have had a better return investment within the first 100 days, but
%%over the whole period stock B exceeded stock A. By the 200 day period,
%%stock B had a percenage increase of almost 30% whereas stock A was only
%%20 percent. At the end of the period, Stock B dropped down to 15 percent,
%%but that is much better compared to Stock A's 6 percent. In short, stock
%%B is a far better choice than stock A.




%%3.2 Stock drawup and drawdown 

%%Drawdown for A and B

draw_down_A = zeros(ndays, 1);
draw_down_B = zeros(ndays, 1);

%% for loop of Drawdown for A
for t = 1: ndays
    zero_A = cum_ROR_A(1:t);
    max_A = max(zero_A); 
    indexA = find(zero_A == max_A);
    max_t = cum_ROR_A(indexA: t);
    
    cum_draw_A = 0; 
    for i = indexA + 1: t
        cum_draw_A = (1 + cum_draw_A) * (1 + daily_ROR_A(i)) - 1;
    end  
   draw_down_A(t) = cum_draw_A; 
end 

%%For loop of Drawdown for B
for t = 1: ndays
    zero_B = cum_ROR_B(1:t);
    max_B = max(zero_B); 
    indexB = find(zero_B == max_B);
    max_t = cum_ROR_B(indexB: t);
    
    cum_draw_B = 0; 
    for i = indexB + 1: t
        cum_draw_B = (1 + cum_draw_B) * (1 + daily_ROR_B(i)) - 1;
    end  
   draw_down_B(t) = cum_draw_B; 
end 

%%Drawups for A and B
draw_up_A = zeros(ndays, 1);
draw_up_B = zeros(ndays, 1);

%% for loop of Drawup for A
for t = 1: ndays
    zero_A = cum_ROR_A(1:t);
    min_A = min(zero_A); 
    indexA = find(zero_A == min_A);
    min_t = cum_ROR_A(indexA: t);
    
    cum_draw_A = 0; 
    for i = indexA + 1: t
        cum_draw_A = (1 + cum_draw_A) * (1 + daily_ROR_A(i)) - 1;
    end  
   draw_up_A(t) = cum_draw_A; 
end 


%%For loop of Drawup for B
for t = 1: ndays
    zero_B = cum_ROR_B(1:t);
    min_B = min(zero_B); 
    indexB = find(zero_B == min_B);
    min_t = cum_ROR_B(indexB: t);
    
    cum_draw_B = 0; 
    for i = indexB + 1: t
        cum_draw_B = (1 + cum_draw_B) * (1 + daily_ROR_B(i)) - 1;
    end  
   draw_up_B(t) = cum_draw_B; 
end 

figure(3)
subplot(2,2,1)
plot(x,draw_down_A *100)
title('Drawdown for stock A');
xlabel('Days','FontWeight','bold','FontSize',16);
ylabel('Percentage','FontWeight','bold','FontSize',16);
grid on
subplot(2,2,2) 
plot(x,draw_down_B*100)
title('Drawdown for stock B');
xlabel('Days','FontWeight','bold','FontSize',16);
ylabel ('Percentage','FontWeight','bold','FontSize',16);
grid on
subplot(2,2,3)
plot(x,draw_up_A*100)
title('Drawup for stock A');
xlabel('Days','FontWeight','bold','FontSize',16);
ylabel('Percentage','FontWeight','bold','FontSize',16);
grid on
subplot(2,2,4)
plot(x,draw_up_B*100)
title('Drawup for stock B'); 
xlabel('Days','FontWeight','bold','FontSize',16);
ylabel('Percentage','FontWeight','bold','FontSize',16);
grid on
