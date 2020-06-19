%%
base = 'dent';

load(['tec_', base, '.mat']);

figure;
hold on;

plot(time, tec);
errorbar(mtime, mtec, etec);

grid on;
title('��������� �������� TEC �� �����', 'FontSize', 14);
ylabel('TECU ', 'FontSize', 14);
xlabel('����� UTC', 'FontSize', 14);
xlim([0, 24]);
xticks(0 : 24);

legend('���������� �������� TEC ��� ������� dent', '������ MADRIGAL',...
    'FontSize', 12);

%%
figure;
hold on;
grid on;
title('��������� �������� TEC � ���� �������� ������ �� �����',...
    'FontSize', 14);

yyaxis left;
plot(time, tec);
ylabel('TECU', 'FontSize', 14);


yyaxis right;
plot(time, sunElevation);
ylabel('���� �������� � ��������', 'FontSize', 14);

xlabel('����� UTC', 'FontSize', 14);
xlim([0, 24]);
xticks(0 : 24);

%%
