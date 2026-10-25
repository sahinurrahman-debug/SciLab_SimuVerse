# SciLab SimuVerse

> An interactive virtual STEM and engineering laboratory built with Scilab, enabling students to simulate physical systems, explore numerical methods, and analyze datasets through a graphical interface.

**Developed for the Scilab GUIVerse Hackathon 2026**  
*FOSSEE — Free/Libre and Open Source Software in Education, IIT Bombay*

---

## What It Does

SciLab SimuVerse transforms scientific calculations into interactive experiments through a unified desktop GUI. Users can simulate projectile motion, investigate RC circuit charging and discharging, solve nonlinear equations using numerical methods, and explore datasets through statistical analysis and visualization. The platform combines mathematical modeling, computational methods, and graphical feedback to make STEM concepts easier to understand through experimentation.

---

## Features

### Physics Lab — Projectile Motion
- **Interactive Simulation** — Configure initial velocity, launch angle, and gravitational acceleration.
- **Trajectory Visualization** — Plot the projectile's horizontal and vertical motion.
- **Analytical Results** — Calculate time of flight, maximum height, and horizontal range.
- **Input Validation** — Check physical parameters before performing calculations.

### Electronics Lab — RC Circuit Simulator
- **Charging and Discharging** — Visualize capacitor voltage over time using exponential models.
- **Time-Constant Analysis** — Calculate \(\tau = RC\) to understand circuit response.
- **What-If Analysis** — Compare charging curves under different resistance values.
- **Graphical Feedback** — Display voltage-time curves with labeled axes and simulation status.

### Numerical Methods Lab
- **Bisection Method** — Approximate roots of nonlinear equations using interval-based iteration.
- **Newton–Raphson Method** — Estimate roots using numerical derivatives and iterative updates.
- **Convergence Analysis** — Visualize error progression across iterations.
- **Method Comparison** — Compare root estimates, iteration counts, and convergence behavior.

### Data Visualization Dashboard
- **Sample Dataset** — Load built-in sample data to explore the analysis workflow.
- **CSV Import** — Load numeric datasets from local CSV files.
- **Statistical Analysis** — Calculate descriptive statistics, including mean, median, and mode.
- **Relationship Analysis** — Explore correlation and linear regression.
- **Graphical Exploration** — Visualize selected dataset variables and examine trends.

### Interactive GUI
- **Unified Dashboard** — Access the four laboratory modules from one main window.
- **Event-Driven Controls** — Use buttons, editable fields, and callbacks to configure experiments.
- **Visual Results** — Combine numerical outputs with graphical representations.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| **Scilab** | Scientific computing, mathematical modeling, and numerical calculations |
| **Scilab GUI Components** | Desktop interface, input controls, buttons, and event callbacks |
| **Scilab Graphics** | Trajectory plots, circuit response curves, convergence graphs, and data visualization |
| **Numerical Methods** | Bisection, Newton–Raphson, numerical differentiation, and convergence analysis |
| **CSV Data Handling** | Importing and processing numeric datasets |
| **Git & GitHub** | Source-code version control and project hosting |

---

## Getting Started

### Prerequisites

- [Scilab](https://www.scilab.org/)
- The `simuverse_gui.sce` source file downloaded or cloned from this repository.

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
```

Replace the URL with your actual GitHub repository URL.

**2. Open Scilab**

Launch Scilab on your system and open its editor, SciNotes.

**3. Load the source file**

Open `simuverse_gui.sce` in SciNotes.

**4. Run the application**

Execute the complete script using Scilab's **Execute** option. The script initializes the project and launches the main SimuVerse dashboard.

**5. Explore the laboratory modules**

Select a module from the dashboard, enter the required parameters, and run the corresponding simulation or analysis.

---

## Challenges Faced & Solutions

### 1. Integrating Plots with the GUI
**Challenge:** Keeping simulation visualizations associated with the correct laboratory window while updating graphs.

**Solution:** Used tagged axes and figure handles to identify the relevant plotting area and manage graph updates.

### 2. Maintaining Reliable Calculations
**Challenge:** Ensuring that user-supplied physical parameters and numerical-method settings produce meaningful results.

**Solution:** Added parameter validation and used established equations and iterative numerical algorithms.

### 3. Implementing Numerical Convergence
**Challenge:** Comparing root-finding algorithms with different convergence behavior.

**Solution:** Implemented iteration and error tracking for Bisection and Newton–Raphson, with convergence information presented through the GUI.

### 4. Connecting Data Analysis with Visualization
**Challenge:** Making statistical analysis useful beyond displaying isolated numerical results.

**Solution:** Integrated CSV import, descriptive statistics, correlation, linear regression, and graphical exploration into a common dashboard.

### 5. Organizing Interactive Functionality
**Challenge:** Coordinating user inputs, simulation calculations, graph updates, and displayed results.

**Solution:** Structured the source around separate computational functions, GUI construction functions, and event callbacks to make the application easier to understand and debug.

---

## Future Improvements

- Add real-time sliders for continuous parameter exploration.
- Improve GUI styling, responsiveness, and accessibility.
- Expand input validation and automated numerical test coverage.
- Add richer dataset summaries and clearer statistical visualizations.
- Split the source into reusable `.sci` modules as the project grows.

---

## What I Learned

- **Scientific Computing:** Translating mathematical equations into executable simulations.
- **GUI Development:** Connecting interface controls to computational functions through callbacks.
- **Numerical Analysis:** Understanding root-finding algorithms, numerical differentiation, and convergence behavior.
- **Mathematical Modeling:** Applying projectile-motion equations and exponential RC circuit models.
- **Data Analysis:** Working with CSV data, descriptive statistics, correlation, and linear regression.
- **Debugging:** Investigating issues involving GUI controls, figure handles, plotting axes, and numerical inputs.
- **Software Design:** Separating interface logic from calculations to improve readability and maintainability.
- **Technical Communication:** Presenting computational results through meaningful graphs, labels, and output fields.

---
