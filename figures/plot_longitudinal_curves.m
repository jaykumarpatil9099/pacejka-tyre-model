%% plot_longitudinal_curves.m
% Longitudinal tyre force vs slip ratio, plotted as a family of vertical
% loads. Same degressive load behaviour as the lateral curves.
%
% Writes: ./fig_longitudinal_curves.png
%
% Run:
%   cd figures
%   plot_longitudinal_curves

clear; close all;
addpath('../src');
addpath('..');
parameters;

%% Slip-ratio sweep
kappa = -kappa_max : 0.001 : kappa_max;

%% Compute curves at each load
fig = figure('Position', [100 100 880 520], 'Color', 'w');
hold on;
for Fz = Fz_set
    D  = pacejka_peak_value(Fz, a1_x, a2_x);
    Fx = pacejka_magic_formula(kappa, B_x, C_x, D, E_x);
    plot(kappa, Fx / 1000, 'LineWidth', 1.6, ...
        'DisplayName', sprintf('F_z = %d N', Fz));
end
grid on; box on;
xlabel('Longitudinal slip ratio \kappa [-]', 'FontSize', 11);
ylabel('Longitudinal force F_x [kN]', 'FontSize', 11);
title('Pacejka longitudinal curves — load family', 'FontSize', 12);
legend('Location', 'best');
set(gca, 'FontSize', 10);
drawnow;
exportgraphics(fig, 'fig_longitudinal_curves.png', 'Resolution', 150);
fprintf('Wrote fig_longitudinal_curves.png\n');
