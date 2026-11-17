%% plot_lateral_curves.m
% Lateral tyre force vs slip angle, plotted as a family of vertical
% loads. Demonstrates the load-sensitive degressive friction behaviour:
% peak grip *coefficient* (Fy/Fz) drops as Fz increases.
%
% Writes: ./fig_lateral_curves.png
%
% Run:
%   cd figures
%   plot_lateral_curves

clear; close all;
addpath('../src');
addpath('..');
parameters;

%% Slip-angle sweep
alpha_deg = -alpha_max_deg : 0.1 : alpha_max_deg;
alpha     = alpha_deg;   % coefficients fitted with slip angle in DEGREES

%% Compute curves at each load
fig = figure('Position', [100 100 880 520], 'Color', 'w');
hold on;
for Fz = Fz_set
    D  = pacejka_peak_value(Fz, a1_y, a2_y);
    Fy = pacejka_magic_formula(alpha, B_y, C_y, D, E_y);
    plot(alpha_deg, Fy / 1000, 'LineWidth', 1.6, ...
        'DisplayName', sprintf('F_z = %d N', Fz));
end
grid on; box on;
xlabel('Slip angle \alpha [deg]', 'FontSize', 11);
ylabel('Lateral force F_y [kN]', 'FontSize', 11);
title('Pacejka lateral curves — load family', 'FontSize', 12);
legend('Location', 'best');
set(gca, 'FontSize', 10);
drawnow;
exportgraphics(fig, 'fig_lateral_curves.png', 'Resolution', 150);
fprintf('Wrote fig_lateral_curves.png\n');
