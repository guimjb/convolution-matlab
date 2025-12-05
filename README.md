# convolution-matlab
USF Class Project

## Graphical Convolution GUI (MATLAB)

### Overview
- Two-mode MATLAB GUI: **General Graphical Convolution** and **Probability & Statistics (PDF)**.
- Entry point: run `convolution_GuilhermeMachado` in MATLAB (this file lives in this folder).
- Instructor baseline is preserved in `convolution_Baseline.m` (single-mode demo); this project extends it with a mode selector, richer controls, and probability analysis.

### Screenshots
- Mode selector:  
  ![Mode selector](mainmenuScreenshot.png)
- General convolution workflow:  
  ![General mode](toolScreenshot.png)
- Probability & statistics workflow:  
  ![Probability mode](probabilityScreenshot.png)

### How to Run
- Open MATLAB and set the working folder to this directory.
- Run `convolution_GuilhermeMachado`.
- Choose a mode on the startup screen; use `<- Back` anytime to return to the selector.

### What You'll See
- **Mode selector:** single window with two large buttons (General, Probability & Statistics) plus aligned back controls.
- **Shared controls (top band):** templates for `x(t)` and `h(t)` (Rect, Tri, Exp, Sine, Step, Ramp, Custom), amplitude, width, time range (`tstart`, `tend`, `dt`), and custom expressions. Status line near the bottom for validation feedback.
- **Layouts:** General mode uses four axes (x, h, overlap/product, y). Probability mode uses three axes (x PDF, h PDF, y PDF) plus a stats table to the right of the bottom controls.
- **Bottom controls:** General mode has Generate / Run / Pause / Reset and a conv() verification toggle. Probability mode has `Generate PDFs & Stats` and a Normalize toggle.

### General Graphical Convolution (Mode 1)
- **Generate Signals:** builds `x(t)` and `h(t)` from templates or custom expressions; titles show approximate widths (`signalWidth` uses first/last non-negligible points).
- **Run Convolution:** manual sweep computes `y(t0) = sum x(tau) * h(t0 - tau) * dt` and animates:
  - Overlap axis shows `x(t)` (blue), shifted `h(t0 - t)` (red dashed), and their product (magenta).
  - Output axis shows the accumulating `y(t)`.
- **Verification:** optional conv() overlay plotted in yellow against the manual trace.
- **Controls:** pause toggle halts the sweep; reset rebuilds the mode view without restarting MATLAB.

### Probability & Statistics Mode (Mode 2)
- **PDF enforcement:** `x(t)` and `h(t)` are clipped to non-negative; optional normalization forces integrals to one.
- **Outputs:** `y(t) = x*h` via conv() on the same grid; displayed on a wide bottom axis.
- **Statistics:** table reports mean, variance, and integral for `x`, `h`, and `y`. Consistency checks compare `mu_y ~= mu_x + mu_h` and `sigma_y^2 ~= sigma_x^2 + sigma_h^2` (tolerance 1e-2) and list integrals.
- **Same controls as General:** templates/custom signals, adjustable amplitudes/widths, non-integer `dt`, and clear status messaging.
- **Note:** Monte Carlo overlay was removed; the PDF view is purely analytical.

### Quick Usage
- General mode: set templates/widths, click `Generate Signals`, then `Run Convolution`; toggle verification to compare with conv().
- Probability mode: set templates, enable `Normalize` if you need proper PDFs, then `Generate PDFs & Stats` to see integrals, means, variances, and checks.

### Notes and Limits
- Time grid is uniform; very small `dt` slows the animation.
- Custom expressions evaluate in terms of `t` and must return a vector the same length as `t`.
- Shifted `h` is zero-padded via linear interpolation outside its support for smooth animation.
