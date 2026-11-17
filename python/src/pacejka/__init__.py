"""Simplified four-parameter Pacejka Magic Formula tyre model.

Python port of the MATLAB functions in ``../src``. Same equations, same
coefficient sets, same units:

* lateral slip angle in **degrees** (the coefficient sets were fitted that way)
* longitudinal slip ratio as a dimensionless fraction
"""

from .model import (
    AXLE_FRONT,
    AXLE_REAR,
    LATERAL,
    LONGITUDINAL,
    Coefficients,
    friction_ellipse,
    magic_formula,
    peak_force,
    peak_value,
    tyre_force,
)

__all__ = [
    "AXLE_FRONT",
    "AXLE_REAR",
    "LATERAL",
    "LONGITUDINAL",
    "Coefficients",
    "friction_ellipse",
    "magic_formula",
    "peak_force",
    "peak_value",
    "tyre_force",
]
__version__ = "1.0.0"
