function F = pacejka_magic_formula(slip, B, C, D, E)
%PACEJKA_MAGIC_FORMULA  Lateral or longitudinal tyre force from slip.
%
%   F = PACEJKA_MAGIC_FORMULA(slip, B, C, D, E)
%
%   Implements the simplified four-parameter Pacejka Magic Formula:
%
%       F = D * sin( C * atan( B*slip - E*(B*slip - atan(B*slip)) ) )
%
%   The same form is used for lateral force (slip = slip angle in deg)
%   and longitudinal force (slip = slip ratio, dimensionless), with
%   different coefficient sets for each axis.
%
%   Inputs:
%     slip - slip angle [deg] for lateral (the default coefficient sets
%            were fitted in degrees), slip ratio [-] for longitudinal
%     B    - stiffness factor (controls slope at zero slip)
%     C    - shape factor (controls peak vs descent shape)
%     D    - peak force [N]
%     E    - curvature factor (controls peak sharpness)
%
%   Output:
%     F    - tyre force [N]

    F = D .* sin( C .* atan( B .* slip - E .* (B .* slip - atan(B .* slip)) ) );
end
