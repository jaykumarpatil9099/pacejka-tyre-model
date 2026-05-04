function D = pacejka_peak_value(Fz, a1, a2)
%PACEJKA_PEAK_VALUE  Load-sensitive peak force coefficient D.
%
%   D = PACEJKA_PEAK_VALUE(Fz, a1, a2) returns the peak-force scaling
%   parameter D for the Pacejka Magic Formula, accounting for the
%   well-known load-sensitivity effect:
%
%       D = (a1 * Fz + a2) * Fz
%
%   Equivalently, the peak friction coefficient mu_peak = D / Fz is
%       mu_peak = a1 * Fz + a2
%   which decreases linearly with vertical load — the classical
%   degressive friction behaviour of pneumatic tyres.
%
%   Inputs:
%     Fz - vertical tyre load [N]
%     a1 - load-sensitivity slope [1/N]
%     a2 - load-sensitivity intercept [-]
%
%   Output:
%     D  - Magic Formula peak coefficient [N]

    D = (a1 .* Fz + a2) .* Fz;
end
