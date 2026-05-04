%% plot_friction_envelope.m
% Friction-ellipse envelope of combined longitudinal and lateral force at
% varying vertical load. Shows the limit boundary inside which the tyre
% can operate — going outside requires more grip than the tyre has at
% that load.
%
% Approach: the peak Fx and Fy are computed from the Magic Formula in
% pure-slip conditions, then a friction ellipse is drawn:
%       (Fx / Fx_peak)^2 + (Fy / Fy_peak)^2 = 1
% This is the textbook "Kamm circle" approximation — exact combined-slip
% Pacejka adds inter-axis interaction terms but the ellipse captures
% the dominant trade-off.
%
% Writes: ./fig_friction_envelope.png
%
% Run:
%   cd figures
%   plot_friction_envelope

clear; close all;
addpath('../src');
addpath('..');
parameters;

%% Find peak Fx and Fy at each load by sweeping slip
alpha_sweep = deg2rad(0 : 0.1 : 25);
kappa_sweep = 0 : 0.001 : 0.30;

theta = linspace(0, 2*pi, 360);

fig = figure('Position', [100 100 720 720], 'Color', 'w');
hold on; axis equal;
for Fz = Fz_set
    D_y = pacejka_peak_value(Fz, a1_y, a2_y);
    D_x = pacejka_peak_value(Fz, a1_x, a2_x);
    Fy_peak = max(pacejka_magic_formula(alpha_sweep, B_y, C_y, D_y, E_y));
    Fx_peak = max(pacejka_magic_formula(kappa_sweep, B_x, C_x, D_x, E_x));

    Fx_env = Fx_peak * cos(theta);
    Fy_env = Fy_peak * sin(theta);
    plot(Fx_env / 1000, Fy_env / 1000, 'LineWidth', 1.6, ...
        'DisplayName', sprintf('F_z = %d N  (F_{x,peak} %.2f kN, F_{y,peak} %.2f kN)', ...
        Fz, Fx_peak/1000, Fy_peak/1000));
end
grid on; box on;
xlabel('Longitudinal force F_x [kN]', 'FontSize', 11);
ylabel('Lateral force F_y [kN]', 'FontSize', 11);
title('Friction envelope (Kamm ellipse) — load family', 'FontSize', 12);
legend('Location', 'eastoutside', 'FontSize', 9);
set(gca, 'FontSize', 10);
drawnow;
exportgraphics(fig, 'fig_friction_envelope.png', 'Resolution', 150);
fprintf('Wrote fig_friction_envelope.png\n');
