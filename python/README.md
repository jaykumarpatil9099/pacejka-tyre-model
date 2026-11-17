# pacejka (Python)

Python port of the MATLAB Magic Formula functions in this repository. Same equations, same coefficients, same units, and checked against the same reference values as the MATLAB test suite.

```bash
uv sync                       # create venv + install
uv run pytest                 # run the tests
uv run python examples/plot_curves.py   # regenerate ../figures/*.png
```

```python
from pacejka import LATERAL, tyre_force, peak_force

tyre_force(5.0, 4000, LATERAL)  # Fy [N] at 5 deg slip, 4 kN load
peak_force(4000, LATERAL, slip_max=30)  # (Fy_peak, alpha_at_peak)
```

Units: lateral slip angle in **degrees**, longitudinal slip ratio dimensionless.
