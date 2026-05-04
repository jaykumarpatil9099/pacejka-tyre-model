%% parameters.m
% Default Pacejka Magic Formula coefficients used by the plot scripts.
% Lifted from the Vehicle Dynamics Modelling and Simulation coursework
% (Hochschule Trier, M.Sc.) — same coefficients live in the
% vehicle-dynamics-models-matlab-simulink repo's 14-DoF model.

%% Pacejka Magic Formula:
%   F = D * sin( C * atan( B*s - E*(B*s - atan(B*s)) ) )
%   D = (a1 * Fz + a2) * Fz                       % load-sensitive peak

%% Lateral — default (single-axle baseline, used in plots that don't differentiate axle)
B_y    = 0.1453;     % stiffness factor
C_y    = 1.5511;     % shape factor
E_y    = -2.6166;    % curvature factor
a1_y   = -1e-5;      % load sensitivity, linear term
a2_y   = 1.25;       % load sensitivity, constant term

%% Longitudinal (driven axle)
B_x    = 5.7507;
C_x    = 1.2421;
E_x    = -6.8251;
a1_x   = -1e-5;
a2_x   = 1.25;

%% Per-axle lateral coefficients (from the 14-DoF model — front vs rear differentiated)
% Front axle
Bf = 0.0813;   Cf = 1.2947;   Ef = -8.3966;   a1f = -1e-5;   a2f = 0.95;
% Rear axle
Br = 0.0925;   Cr = 1.2617;   Er = -8.7012;   a1r = -1e-5;   a2r = 0.95;

%% Operating ranges for the plot scripts
alpha_max_deg = 15;                       % max slip angle [deg]
kappa_max     = 0.20;                     % max longitudinal slip ratio [-]
Fz_set        = [1500 3000 4500 6000];    % vertical loads to plot families at [N]
Fz_ref        = 4000;                     % representative load for single-load plots [N]
