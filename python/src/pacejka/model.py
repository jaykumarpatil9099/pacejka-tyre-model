"""Core Magic Formula equations.

F = D * sin( C * atan( B*s - E*(B*s - atan(B*s)) ) )
D = (a1 * Fz + a2) * Fz          (load-sensitive peak)
"""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np
from numpy.typing import ArrayLike, NDArray

FloatArray = NDArray[np.float64]


@dataclass(frozen=True, slots=True)
class Coefficients:
    """One Magic Formula coefficient set.

    Attributes:
        B: stiffness factor (per slip unit: 1/deg lateral, 1/- longitudinal)
        C: shape factor
        E: curvature factor
        a1: load-sensitivity slope [1/N]
        a2: load-sensitivity intercept [-]
    """

    B: float
    C: float
    E: float
    a1: float
    a2: float


# Same values as ../parameters.m
LATERAL = Coefficients(B=0.1453, C=1.5511, E=-2.6166, a1=-1e-5, a2=1.25)
LONGITUDINAL = Coefficients(B=5.7507, C=1.2421, E=-6.8251, a1=-1e-5, a2=1.25)
AXLE_FRONT = Coefficients(B=0.0813, C=1.2947, E=-8.3966, a1=-1e-5, a2=0.95)
AXLE_REAR = Coefficients(B=0.0925, C=1.2617, E=-8.7012, a1=-1e-5, a2=0.95)


def magic_formula(slip: ArrayLike, B: float, C: float, D: ArrayLike, E: float) -> FloatArray:
    """Pacejka Magic Formula force for a given slip (vectorised)."""
    s = np.asarray(slip, dtype=float)
    bs = B * s
    return np.asarray(D, dtype=float) * np.sin(C * np.arctan(bs - E * (bs - np.arctan(bs))))


def peak_value(Fz: ArrayLike, a1: float, a2: float) -> FloatArray:
    """Load-sensitive peak force D = (a1*Fz + a2)*Fz."""
    fz = np.asarray(Fz, dtype=float)
    return (a1 * fz + a2) * fz


def tyre_force(slip: ArrayLike, Fz: ArrayLike, c: Coefficients) -> FloatArray:
    """Tyre force for slip and vertical load using a coefficient set."""
    return magic_formula(slip, c.B, c.C, peak_value(Fz, c.a1, c.a2), c.E)


def peak_force(Fz: float, c: Coefficients, slip_max: float, n: int = 5001) -> tuple[float, float]:
    """Numerically find the peak force and the slip at which it occurs.

    Returns:
        (peak_force, slip_at_peak)
    """
    s = np.linspace(0.0, slip_max, n)
    f = tyre_force(s, Fz, c)
    i = int(np.argmax(f))
    return float(f[i]), float(s[i])


def friction_ellipse(Fx_peak: float, Fy_peak: float, n: int = 360) -> tuple[FloatArray, FloatArray]:
    """Kamm-ellipse envelope (Fx/Fx_peak)^2 + (Fy/Fy_peak)^2 = 1."""
    theta = np.linspace(0.0, 2.0 * np.pi, n)
    return Fx_peak * np.cos(theta), Fy_peak * np.sin(theta)
