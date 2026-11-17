import numpy as np
import pytest

from pacejka import (
    AXLE_FRONT,
    AXLE_REAR,
    LATERAL,
    LONGITUDINAL,
    friction_ellipse,
    magic_formula,
    peak_force,
    peak_value,
    tyre_force,
)


def test_zero_slip_gives_zero_force():
    assert tyre_force(0.0, 4000.0, LATERAL) == pytest.approx(0.0)
    assert tyre_force(0.0, 4000.0, LONGITUDINAL) == pytest.approx(0.0)


def test_force_is_odd_in_slip():
    s = np.linspace(0.1, 15, 50)
    np.testing.assert_allclose(tyre_force(-s, 4000, LATERAL), -tyre_force(s, 4000, LATERAL))


def test_peak_value_matches_formula():
    assert peak_value(4000, -1e-5, 1.25) == pytest.approx((-1e-5 * 4000 + 1.25) * 4000)


def test_peak_never_exceeds_D():
    fz = 4000
    D = peak_value(fz, LATERAL.a1, LATERAL.a2)
    f = tyre_force(np.linspace(-30, 30, 2001), fz, LATERAL)
    assert np.max(np.abs(f)) <= D * (1 + 1e-12)


def test_degressive_friction():
    """Peak friction coefficient must fall as vertical load rises."""
    mu = [peak_force(fz, LATERAL, slip_max=30)[0] / fz for fz in (1500, 3000, 4500, 6000)]
    assert all(a > b for a, b in zip(mu, mu[1:], strict=False))


def test_lateral_peak_in_realistic_slip_band():
    """Slip in degrees puts the lateral peak at 5-12 deg (feeding radians made it linear)."""
    _, alpha_peak = peak_force(4000, LATERAL, slip_max=30)
    assert 4.0 < alpha_peak < 12.0


@pytest.mark.parametrize("axle", [AXLE_FRONT, AXLE_REAR])
def test_axle_sets_produce_a_peak(axle):
    _, alpha_peak = peak_force(4000, axle, slip_max=40)
    assert alpha_peak < 40.0


def test_longitudinal_peak_slip():
    _, k_peak = peak_force(4000, LONGITUDINAL, slip_max=0.5)
    assert 0.05 < k_peak < 0.35


def test_friction_ellipse_on_boundary():
    fx, fy = friction_ellipse(5000, 4000)
    np.testing.assert_allclose((fx / 5000) ** 2 + (fy / 4000) ** 2, 1.0)


def test_magic_formula_reference_value():
    # Hand-checked reference point (also asserted in the MATLAB test suite)
    f = magic_formula(5.0, 0.1453, 1.5511, 1000.0, -2.6166)
    assert f == pytest.approx(933.949425, rel=1e-8)
