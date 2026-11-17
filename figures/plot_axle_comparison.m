%% plot_axle_comparison.m
% Front-vs-rear axle lateral curves at one representative load. Uses the
% per-axle Pacejka coefficients from the 14-DoF model — front and rear
% deliberately differentiated to reflect real race-car tyre asymmetry
% (different compound, different cornering stiffness, different peak).
%
% Writes: ./fig_axle_comparison.png
%
% Run:
%   cd figures
%   plot_axle_comparison

clear; close all;
addpath('../src');
addpath('..');
parameters;

%% Slip-angle sweep
alpha_deg = -alpha_max_deg : 0.1 : alpha_max_deg;
alpha     = alpha_deg;   % coefficients fitted with slip angle in DEGREES

%% Per-axle peak values at the reference load
Df = pacejka_peak_value(Fz_ref, a1f, a2f);
Dr = pacejka_peak_value(Fz_ref, a1r, a2r);

Fy_f = pacejka_magic_formula(alpha, Bf, Cf, Df, Ef);
Fy_r = pacejka_magic_formula(alpha, Br, Cr, Dr, Er);

%% Plot
fig = figure('Position', [100 100 880 520], 'Color', 'w');
plot(alpha_deg, Fy_f / 1000, 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Front axle  (B=%.4f, C=%.4f, E=%.4f)', Bf, Cf, Ef));
hold on;
plot(alpha_deg, Fy_r / 1000, 'LineWidth', 1.8, ...
    'DisplayName', sprintf('Rear axle  (B=%.4f, C=%.4f, E=%.4f)', Br, Cr, Er));
grid on; box on;
xlabel('Slip angle \alpha [deg]', 'FontSize', 11);
ylabel('Lateral force F_y [kN]', 'FontSize', 11);
title(sprintf('Pacejka lateral — front vs rear axle  (F_z = %d N)', Fz_ref), 'FontSize', 12);
legend('Location', 'best');
set(gca, 'FontSize', 10);
drawnow;
exportgraphics(fig, 'fig_axle_comparison.png', 'Resolution', 150);
fprintf('Wrote fig_axle_comparison.png\n');
