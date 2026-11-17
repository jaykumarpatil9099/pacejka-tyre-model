"""Regenerate the four README figures in ../figures/ from the Python port."""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np

from pacejka import (
    AXLE_FRONT,
    AXLE_REAR,
    LATERAL,
    LONGITUDINAL,
    friction_ellipse,
    peak_force,
    tyre_force,
)

OUT = Path(__file__).resolve().parents[2] / "figures"
FZ_SET = (1500, 3000, 4500, 6000)
FZ_REF = 4000

plt.rcParams.update({"figure.dpi": 150, "axes.grid": True, "grid.alpha": 0.3, "font.size": 10})


def save(fig, name):
    fig.tight_layout()
    fig.savefig(OUT / name, dpi=150, facecolor="white")
    plt.close(fig)
    print(f"wrote {name}")


def lateral():
    a = np.linspace(-15, 15, 601)
    fig, ax = plt.subplots(figsize=(8.8, 5.2))
    for fz in FZ_SET:
        ax.plot(a, tyre_force(a, fz, LATERAL) / 1e3, lw=1.8, label=f"$F_z$ = {fz} N")
    ax.set(
        xlabel=r"Slip angle $\alpha$ [deg]",
        ylabel="Lateral force $F_y$ [kN]",
        title="Pacejka lateral curves — load family",
    )
    ax.legend()
    save(fig, "fig_lateral_curves.png")


def longitudinal():
    k = np.linspace(-0.2, 0.2, 801)
    fig, ax = plt.subplots(figsize=(8.8, 5.2))
    for fz in FZ_SET:
        ax.plot(k, tyre_force(k, fz, LONGITUDINAL) / 1e3, lw=1.8, label=f"$F_z$ = {fz} N")
    ax.set(
        xlabel=r"Slip ratio $\kappa$ [-]",
        ylabel="Longitudinal force $F_x$ [kN]",
        title="Pacejka longitudinal curves — load family",
    )
    ax.legend()
    save(fig, "fig_longitudinal_curves.png")


def axles():
    a = np.linspace(-20, 20, 801)
    fig, ax = plt.subplots(figsize=(8.8, 5.2))
    for c, name in ((AXLE_FRONT, "Front"), (AXLE_REAR, "Rear")):
        lbl = f"{name} axle (B={c.B}, C={c.C}, E={c.E})"
        ax.plot(a, tyre_force(a, FZ_REF, c) / 1e3, lw=1.8, label=lbl)
    ax.set(
        xlabel=r"Slip angle $\alpha$ [deg]",
        ylabel="Lateral force $F_y$ [kN]",
        title=f"Front vs rear axle coefficients at $F_z$ = {FZ_REF} N",
    )
    ax.legend()
    save(fig, "fig_axle_comparison.png")


def envelope():
    fig, ax = plt.subplots(figsize=(7.6, 7.2))
    for fz in FZ_SET:
        fy, _ = peak_force(fz, LATERAL, slip_max=25)
        fx, _ = peak_force(fz, LONGITUDINAL, slip_max=0.3)
        ex, ey = friction_ellipse(fx, fy)
        ax.plot(
            ex / 1e3,
            ey / 1e3,
            lw=1.8,
            label=f"$F_z$ = {fz} N  ($F_x$ {fx / 1e3:.2f}, $F_y$ {fy / 1e3:.2f} kN)",
        )
    ax.set_aspect("equal")
    ax.set(
        xlabel="Longitudinal force $F_x$ [kN]",
        ylabel="Lateral force $F_y$ [kN]",
        title="Friction envelope (Kamm ellipse) — load family",
    )
    ax.legend(fontsize=8, loc="lower center", bbox_to_anchor=(0.5, -0.32), ncol=1)
    save(fig, "fig_friction_envelope.png")


if __name__ == "__main__":
    lateral()
    longitudinal()
    axles()
    envelope()
