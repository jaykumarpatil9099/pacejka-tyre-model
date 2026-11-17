classdef PacejkaTest < matlab.unittest.TestCase
    %PACEJKATEST  Unit tests for the Magic Formula functions.
    %   Run with:  buildtool test     (or  runtests("tests")  )
    %   The same reference values are asserted in python/tests/test_model.py,
    %   so the MATLAB and Python implementations are cross-checked.

    properties
        P   % default coefficients from parameters.m
    end

    methods (TestClassSetup)
        function loadParameters(tc)
            root = fileparts(fileparts(mfilename("fullpath")));
            tc.applyFixture(matlab.unittest.fixtures.PathFixture(fullfile(root, "src")));
            run(fullfile(root, "parameters.m"));
            tc.P = struct("B_y", B_y, "C_y", C_y, "E_y", E_y, "a1_y", a1_y, "a2_y", a2_y, ...
                          "B_x", B_x, "C_x", C_x, "E_x", E_x, "a1_x", a1_x, "a2_x", a2_x);
        end
    end

    methods (Test)
        function zeroSlipGivesZeroForce(tc)
            tc.verifyEqual(pacejka_magic_formula(0, 0.1453, 1.5511, 4000, -2.6166), 0, "AbsTol", 1e-12);
        end

        function forceIsOddInSlip(tc)
            s = linspace(0.1, 15, 50);
            F = @(x) pacejka_magic_formula(x, tc.P.B_y, tc.P.C_y, 4000, tc.P.E_y);
            tc.verifyEqual(F(-s), -F(s), "AbsTol", 1e-9);
        end

        function referenceValue(tc)
            % Cross-checked against the Python port
            F = pacejka_magic_formula(5, 0.1453, 1.5511, 1000, -2.6166);
            tc.verifyEqual(F, 933.949425, "RelTol", 1e-8);
        end

        function peakValueFormula(tc)
            tc.verifyEqual(pacejka_peak_value(4000, -1e-5, 1.25), (-1e-5*4000 + 1.25)*4000, "RelTol", 1e-12);
        end

        function forceNeverExceedsPeak(tc)
            D = pacejka_peak_value(4000, tc.P.a1_y, tc.P.a2_y);
            F = pacejka_magic_formula(linspace(-30, 30, 2001), tc.P.B_y, tc.P.C_y, D, tc.P.E_y);
            tc.verifyLessThanOrEqual(max(abs(F)), D*(1 + 1e-12));
        end

        function degressiveFriction(tc)
            % Peak friction coefficient must fall as vertical load rises
            Fz = [1500 3000 4500 6000];
            a  = linspace(0, 30, 3001);
            mu = arrayfun(@(fz) max(pacejka_magic_formula(a, tc.P.B_y, tc.P.C_y, ...
                 pacejka_peak_value(fz, tc.P.a1_y, tc.P.a2_y), tc.P.E_y)) / fz, Fz);
            tc.verifyTrue(all(diff(mu) < 0));
        end

        function lateralPeakInRealisticBand(tc)
            % Slip in degrees -> peak at 4-12 deg. (Feeding radians made the curve linear.)
            a = linspace(0, 30, 3001);
            [~, i] = max(pacejka_magic_formula(a, tc.P.B_y, tc.P.C_y, 4000, tc.P.E_y));
            tc.verifyGreaterThan(a(i), 4);
            tc.verifyLessThan(a(i), 12);
        end

        function longitudinalPeakSlip(tc)
            k = linspace(0, 0.5, 5001);
            [~, i] = max(pacejka_magic_formula(k, tc.P.B_x, tc.P.C_x, 4000, tc.P.E_x));
            tc.verifyGreaterThan(k(i), 0.05);
            tc.verifyLessThan(k(i), 0.35);
        end
    end
end
