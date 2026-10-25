function [t, x, y] = projectile_trajectory(u, theta, g)

    // Convert angle from degrees to radians
    theta_rad = theta * %pi / 180;

    // Calculate total time of flight
    T = (2 * u * sin(theta_rad)) / g;

    // Generate time values
    t = linspace(0, T, 200);

    // Horizontal position
    x = u * cos(theta_rad) .* t;

    // Vertical position
    y = u * sin(theta_rad) .* t ...
        - 0.5 * g .* t.^2;

    // Remove small negative values
    y(y < 0) = 0;

endfunction

function [T, H, R] = projectile_calculate(u, theta, g)

    // Convert angle from degrees to radians
    theta_rad = theta * %pi / 180;

    // Time of Flight
    T = (2 * u * sin(theta_rad)) / g;

    // Maximum Height
    H = (u^2 * sin(theta_rad)^2) / (2 * g);

    // Horizontal Range
    R = (u^2 * sin(2 * theta_rad)) / g;

endfunction

function projectile_run(f)

    // Find controls
    velocity_control = findobj(f, "tag", "velocity");

    angle_control = findobj(f, "tag", "angle");

    gravity_control = findobj(f, "tag", "gravity");


    // Read values
    u = evstr(velocity_control.string);

    theta = evstr(angle_control.string);

    g = evstr(gravity_control.string);


    // Validation
    if u <= 0 then
        messagebox("Velocity must be greater than zero.");
        return;
    end

    if theta <= 0 | theta >= 90 then
        messagebox("Angle must be between 0 and 90 degrees.");
        return;
    end

    if g <= 0 then
        messagebox("Gravity must be greater than zero.");
        return;
    end


    // Calculate
    [T, H, R] = projectile_calculate(u, theta, g);


    // Display results

    time_result = findobj(f, "tag", "time_result");

    height_result = findobj(f, "tag", "height_result");

    range_result = findobj(f, "tag", "range_result");


    time_result.string = "Time of Flight: " + string(round(T*10000)/10000) + " s";

    height_result.string = "Maximum Height: " + string(round(H*10000)/10000) + " m";

    range_result.string = "Range: " + string(round(R*10000)/10000) + " m";


    // Plot

    ax = findobj(f, "tag", "projectile_axes");

    [t, x, y] = projectile_trajectory(u, theta, g);

    sca(ax);

    delete(ax.children);

    plot(x, y);

    xlabel("Horizontal Distance (m)");

    ylabel("Vertical Height (m)");

    title("Projectile Trajectory");

    xgrid();

endfunction

function projectile_gui()

    f = figure();

    f.figure_name = "SciLab SimuVerse - Projectile Motion";
    f.figure_position = [100 50];
    f.figure_size = [1200 700];


    // ======================================================
    // TITLE
    // ======================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "PROJECTILE MOTION SIMULATOR", ...
        "position", [350 600 500 40], ...
        "fontsize", 20,...
        "horizontalalignment","center");


    // ======================================================
    // INPUT LABELS
    // ======================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Initial Velocity (m/s)", ...
        "position", [50 550 200 30]);

    uicontrol(f, ...
        "style", "edit", ...
        "string", "20", ...
        "tag", "velocity", ...
        "position", [250 550 120 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Launch Angle (degree)", ...
        "position", [50 500 200 30]);

    uicontrol(f, ...
        "style", "edit", ...
        "string", "45", ...
        "tag", "angle", ...
        "position", [250 500 120 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Gravity (m/s^2)", ...
        "position", [50 450 200 30]);

    uicontrol(f, ...
        "style", "edit", ...
        "string", "9.81", ...
        "tag", "gravity", ...
        "position", [250 450 120 30]);


    // ======================================================
    // CALCULATE BUTTON
    // ======================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "SIMULATE", ...
        "position", [100 370 250 60], ...
        "fontsize", 16, ...
        "callback", "projectile_run(gcf())");


    // ======================================================
    // RESULTS
    // ======================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Results:", ...
        "position", [50 300 150 30], ...
        "fontsize", 16);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Time of Flight:", ...
        "tag", "time_result", ...
        "position", [50 250 300 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Maximum Height:", ...
        "tag", "height_result", ...
        "position", [50 210 300 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Range:", ...
        "tag", "range_result", ...
        "position", [50 170 300 30]);


    // ======================================================
    // GRAPH AXES
    // ======================================================

    ax = newaxes();

    ax.parent = f;

    ax.axes_bounds = [0.4 0.15 0.55 0.7];

    ax.tag = "projectile_axes";

endfunction

// ============================================================
// SCILAB SIMUVERSE
// RC CIRCUIT SIMULATOR
// ============================================================


// ============================================================
// READ RC INPUTS
// Reads R, C and V from GUI
// ============================================================

function [R, C, V, valid] = read_rc_inputs()

    // Get current GUI
    f = gcf();

    // Find input controls
    R_control = findobj(f, "tag", "rc_R");

    C_control = findobj(f, "tag", "rc_C");

    V_control = findobj(f, "tag", "rc_V");


    // Default validation status
    valid = %t;


    // Check if controls exist

    if size(R_control, "*") == 0 then

        messagebox("Resistance input not found.");

        valid = %f;

        return;

    end


    if size(C_control, "*") == 0 then

        messagebox("Capacitance input not found.");

        valid = %f;

        return;

    end


    if size(V_control, "*") == 0 then

        messagebox("Voltage input not found.");

        valid = %f;

        return;

    end


    // Try to read input values

    R = evstr(R_control.string);

    C = evstr(C_control.string);

    V = evstr(V_control.string);


    // Validate resistance

    if R <= 0 then

        messagebox( ...
            "Resistance must be greater than zero.");

        valid = %f;

        return;

    end


    // Validate capacitance

    if C <= 0 then

        messagebox( ...
            "Capacitance must be greater than zero.");

        valid = %f;

        return;

    end


    // Validate voltage

    if V <= 0 then

        messagebox( ...
            "Voltage must be greater than zero.");

        valid = %f;

        return;

    end

endfunction



// ============================================================
// RC CHARGING
//
// Formula:
// Vc(t) = V * (1 - exp(-t/(R*C)))
//
// Returns:
// tau = Time constant
// t   = Time vector
// vc  = Capacitor voltage
// ============================================================

function [tau, t, vc] = rc_charge(R, C, V)

    // Calculate time constant
    tau = R * C;


    // Simulate charging for 5 time constants
    t = linspace(0, 5 * tau, 300);


    // Capacitor charging equation
    vc = V * (1 - exp(-t ./ tau));

endfunction



// ============================================================
// RC DISCHARGING
//
// Formula:
// Vc(t) = V * exp(-t/(R*C))
// ============================================================

function [tau, t, vc] = rc_discharge(R, C, V)

    // Calculate time constant
    tau = R * C;


    // Simulate for 5 time constants
    t = linspace(0, 5 * tau, 300);


    // Capacitor discharging equation
    vc = V * exp(-t ./ tau);

endfunction



// ============================================================
// CALCULATE CHARGING PERCENTAGE
// ============================================================

function percentage = rc_charge_percentage(t, tau)

    percentage = 100 * ...
        (1 - exp(-t / tau));

endfunction



// ============================================================
// CALCULATE DISCHARGING PERCENTAGE
// ============================================================

function percentage = rc_discharge_percentage(t, tau)

    percentage = 100 * ...
        exp(-t / tau);

endfunction



// ============================================================
// RC CHARGING CALLBACK
// ============================================================

function rc_charge_callback()

    // Read inputs

    [R, C, V, valid] = ...
        read_rc_inputs();


    // Stop if invalid

    if valid == %f then

        return;

    end


    // Calculate charging

    [tau, t, vc] = ...
        rc_charge(R, C, V);


    // Get GUI

    f = gcf();


    // Find result controls

    tau_result = findobj(f, ...
        "tag", "tau_result");

    final_result = findobj(f, ...
        "tag", "final_result");

    status_result = findobj(f, ...
        "tag", "status_result");


    // Display time constant

    tau_result.string = ...
        "Time Constant: " + ...
        string(round(tau * 10000) / 10000) + ...
        " s";


    // Display final voltage

    final_result.string = ...
        "Final Voltage: " + ...
        string(round(V * 10000) / 10000) + ...
        " V";


    // Display status

    status_result.string = ...
        "Status: Charging Simulation Complete";


    // Find graph

    ax = findobj(f, ...
        "tag", "electronics_axes");


    // Check graph

    if size(ax, "*") == 0 then

        messagebox( ...
            "Graph axes not found.");

        return;

    end


    // Select graph

    sca(ax);


    // Clear previous graph

    delete(ax.children);


    // Plot charging curve

    plot(t, vc);


    // Labels

    xlabel("Time (seconds)");

    ylabel("Capacitor Voltage (V)");

    title("RC Circuit Charging Curve");


    // Display grid

    xgrid();


    // Calculate 63.2% voltage

    V63 = 0.632 * V;


    // Mark time constant

    plot([tau tau], [0 V]);


    // Mark 63.2% voltage

    plot([0 tau], [V63 V63]);


    // Legend

    legend([
        "Charging Curve";
        "Time Constant";
        "63.2% Voltage"
    ]);

endfunction



// ============================================================
// RC DISCHARGING CALLBACK
// ============================================================

function rc_discharge_callback()

    // Read inputs

    [R, C, V, valid] = ...
        read_rc_inputs();


    // Stop if invalid

    if valid == %f then

        return;

    end


    // Calculate discharge

    [tau, t, vc] = ...
        rc_discharge(R, C, V);


    // Get GUI

    f = gcf();


    // Find result controls

    tau_result = findobj(f, ...
        "tag", "tau_result");

    final_result = findobj(f, ...
        "tag", "final_result");

    status_result = findobj(f, ...
        "tag", "status_result");


    // Display time constant

    tau_result.string = ...
        "Time Constant: " + ...
        string(round(tau * 10000) / 10000) + ...
        " s";


    // Display initial voltage

    final_result.string = ...
        "Initial Voltage: " + ...
        string(round(V * 10000) / 10000) + ...
        " V";


    // Display status

    status_result.string = ...
        "Status: Discharging Simulation Complete";


    // Find axes

    ax = findobj(f, ...
        "tag", "electronics_axes");


    // Check axes

    if size(ax, "*") == 0 then

        messagebox( ...
            "Graph axes not found.");

        return;

    end


    // Select axes

    sca(ax);


    // Clear previous graph

    delete(ax.children);


    // Plot

    plot(t, vc);


    // Labels

    xlabel("Time (seconds)");

    ylabel("Capacitor Voltage (V)");

    title("RC Circuit Discharging Curve");


    // Grid

    xgrid();


    // Legend

    legend("Discharging Curve");

endfunction



// ============================================================
// WHAT-IF COMPARISON
// Compare R, 2R and 5R
// ============================================================

function rc_compare_callback()

    // Read inputs

    [R, C, V, valid] = ...
        read_rc_inputs();


    // Stop if invalid

    if valid == %f then

        return;

    end


    // Three resistance scenarios

    R1 = R;

    R2 = 2 * R;

    R3 = 5 * R;


    // Calculate simulations

    [tau1, t1, vc1] = ...
        rc_charge(R1, C, V);

    [tau2, t2, vc2] = ...
        rc_charge(R2, C, V);

    [tau3, t3, vc3] = ...
        rc_charge(R3, C, V);


    // Get GUI

    f = gcf();


    // Find graph

    ax = findobj(f, ...
        "tag", "electronics_axes");


    // Check graph

    if size(ax, "*") == 0 then

        messagebox( ...
            "Graph axes not found.");

        return;

    end


    // Select graph

    sca(ax);


    // Clear previous graph

    delete(ax.children);


    // Plot three curves

    plot(t1, vc1);

    plot(t2, vc2);

    plot(t3, vc3);


    // Labels

    xlabel("Time (seconds)");

    ylabel("Capacitor Voltage (V)");

    title("WHAT-IF ANALYSIS: Effect of Resistance");


    // Legend

    legend([
        "R = " + string(R1) + " Ohm";
        "R = " + string(R2) + " Ohm";
        "R = " + string(R3) + " Ohm"
    ]);


    // Grid

    xgrid();


    // Update status

    status_result = findobj(f, ...
        "tag", "status_result");


    status_result.string = ...
        "Status: What-If Comparison Complete";

endfunction



// ============================================================
// RC GUI
// ============================================================

function rc_gui()

    // ========================================================
    // CREATE MAIN WINDOW
    // ========================================================

    f = figure();

    f.figure_name = ...
        "SciLab SimuVerse - RC Circuit Simulator";

    f.figure_position = [50 50];

    f.figure_size = [1200 700];


    // ========================================================
    // TITLE
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "RC CIRCUIT SIMULATOR", ...
        "position", [400 600 400 40], ...
        "fontsize", 22,...
        "horizontalalignment","center");


    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Interactive Electronics Laboratory", ...
        "position", [400 580 400 25], ...
        "fontsize", 12,...
        "horizontalalignment","center");


    // ========================================================
    // INPUT SECTION
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Resistance R (Ohm)", ...
        "position", [50 520 180 30], ...
        "fontsize", 11);


    uicontrol(f, ...
        "style", "edit", ...
        "string", "1000", ...
        "tag", "rc_R", ...
        "position", [240 520 130 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Capacitance C (F)", ...
        "position", [50 470 180 30], ...
        "fontsize", 11);


    uicontrol(f, ...
        "style", "edit", ...
        "string", "0.001", ...
        "tag", "rc_C", ...
        "position", [240 470 130 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Input Voltage V (V)", ...
        "position", [50 420 180 30], ...
        "fontsize", 11);


    uicontrol(f, ...
        "style", "edit", ...
        "string", "5", ...
        "tag", "rc_V", ...
        "position", [240 420 130 30]);


    // ========================================================
    // BUTTONS
    // ========================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "CHARGE", ...
        "position", [50 340 140 50], ...
        "callback", "rc_charge_callback()");


    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "DISCHARGE", ...
        "position", [210 340 140 50], ...
        "callback", "rc_discharge_callback()");


    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "WHAT-IF COMPARE", ...
        "position", [90 270 220 50], ...
        "callback", "rc_compare_callback()");


    // ========================================================
    // RESULTS
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "RESULTS:", ...
        "position", [50 200 150 30], ...
        "fontsize", 14);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Time Constant: -", ...
        "tag", "tau_result", ...
        "position", [50 160 320 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Final Voltage: -", ...
        "tag", "final_result", ...
        "position", [50 125 320 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Status: Ready", ...
        "tag", "status_result", ...
        "position", [50 90 320 30]);


    // ========================================================
    // GRAPH
    // ========================================================

    ax = newaxes();

    ax.parent = f;

    ax.axes_bounds = ...
        [0.40 0.15 0.55 0.65];

    ax.tag = ...
        "electronics_axes";

endfunction

// ============================================================
// SCILAB SIMUVERSE
// NUMERICAL METHODS LAB
//
// Methods:
// 1. Bisection Method
// 2. Newton-Raphson Method
//
// Features:
// - Function input
// - Numerical root finding
// - Iteration count
// - Final error
// - Function graph
// - Convergence visualization
// - What-If comparison
// ============================================================


// ============================================================
// BISECTION METHOD
// ============================================================

function [root, iterations, error_value, history] = ...
    bisection_method(f, a, b, tol, maxIter)

    // Initialize
    history = [];

    fa = f(a);
    fb = f(b);


    // Check valid bracket

    if fa * fb > 0 then

        root = %nan;

        iterations = 0;

        error_value = %nan;

        return;

    end


    // Bisection iterations

    for i = 1:maxIter

        c = (a + b) / 2;

        fc = f(c);


        // Store current approximation

        history(i) = c;


        // Calculate error

        error_value = abs(b - a) / 2;


        // Check convergence

        if abs(fc) < tol | error_value < tol then

            root = c;

            iterations = i;

            return;

        end


        // Update interval

        if fa * fc < 0 then

            b = c;

            fb = fc;

        else

            a = c;

            fa = fc;

        end

    end


    // If maximum iterations reached

    root = c;

    iterations = maxIter;

endfunction



// ============================================================
// NUMERICAL DERIVATIVE
// Used for Newton-Raphson Method
// ============================================================

function df = numerical_derivative(f, x)

    h = 1e-6;

    df = (f(x + h) - f(x - h)) / (2 * h);

endfunction



// ============================================================
// NEWTON-RAPHSON METHOD
// ============================================================

function [root, iterations, error_value, history] = ...
    newton_raphson_method(f, x0, tol, maxIter)

    // Initialize

    history = [];

    x = x0;


    for i = 1:maxIter

        // Calculate function value

        fx = f(x);


        // Calculate derivative

        dfx = numerical_derivative(f, x);


        // Check derivative

        if abs(dfx) < 1e-12 then

            root = x;

            iterations = i;

            error_value = %nan;

            history(i) = x;

            return;

        end


        // Newton-Raphson formula

        x_new = x - fx / dfx;


        // Store iteration

        history(i) = x_new;


        // Calculate error

        error_value = abs(x_new - x);


        // Check convergence

        if error_value < tol then

            root = x_new;

            iterations = i;

            return;

        end


        // Update x

        x = x_new;

    end


    // Maximum iterations reached

    root = x;

    iterations = maxIter;

endfunction



// ============================================================
// READ NUMERICAL INPUTS
// ============================================================

function [f, expression, method, a, b, x0, tol, maxIter, valid] = ...
    read_numerical_inputs()

    // Get current GUI

    fig = gcf();


    // Default values

    f = [];

    expression = "";

    method = 1;

    a = 0;

    b = 0;

    x0 = 0;

    tol = 0;

    maxIter = 0;

    valid = %t;


    // ========================================================
    // FIND GUI CONTROLS
    // ========================================================

    method_control = ...
        findobj(fig, "tag", "numerical_method");

    function_control = ...
        findobj(fig, "tag", "function_input");

    lower_control = ...
        findobj(fig, "tag", "lower_bound");

    upper_control = ...
        findobj(fig, "tag", "upper_bound");

    guess_control = ...
        findobj(fig, "tag", "initial_guess");

    tolerance_control = ...
        findobj(fig, "tag", "tolerance");

    iteration_control = ...
        findobj(fig, "tag", "max_iterations");


    // ========================================================
    // CHECK CONTROLS
    // ========================================================

    if size(method_control, "*") == 0 then

        messagebox( ...
            "Method selection control not found.");

        valid = %f;

        return;

    end


    if size(function_control, "*") == 0 then

        messagebox( ...
            "Function input control not found.");

        valid = %f;

        return;

    end


    // ========================================================
    // READ METHOD
    // ========================================================

    method = method_control.value;


    // ========================================================
    // READ FUNCTION
    // ========================================================

    expression = function_control.string;


    if expression == "" then

        messagebox( ...
            "Please enter a function.");

        valid = %f;

        return;

    end


    // ========================================================
    // CREATE FUNCTION
    //
    // Example:
    // x^3-x-2
    //
    // The function becomes:
    // f(x) = x^3-x-2
    // ========================================================

    deff("y = f(x)", ...
        "y = " + expression);


    // ========================================================
    // READ LOWER BOUND
    // ========================================================

    a = evstr(lower_control.string);


    // ========================================================
    // READ UPPER BOUND
    // ========================================================

    b = evstr(upper_control.string);


    // ========================================================
    // READ INITIAL GUESS
    // ========================================================

    x0 = evstr(guess_control.string);


    // ========================================================
    // READ TOLERANCE
    // ========================================================

    tol = evstr(tolerance_control.string);


    // ========================================================
    // READ MAXIMUM ITERATIONS
    // ========================================================

    maxIter = evstr(iteration_control.string);


    // ========================================================
    // VALIDATION
    // ========================================================

    if tol <= 0 then

        messagebox( ...
            "Tolerance must be greater than zero.");

        valid = %f;

        return;

    end


    if maxIter <= 0 then

        messagebox( ...
            "Maximum iterations must be greater than zero.");

        valid = %f;

        return;

    end


    if a >= b then

        messagebox( ...
            "Lower bound must be less than upper bound.");

        valid = %f;

        return;

    end


    // Convert to integer

    maxIter = round(maxIter);


    // ========================================================
    // BISECTION VALIDATION
    // ========================================================

    if method == 1 then

        fa = f(a);

        fb = f(b);


        if fa * fb > 0 then

            messagebox( ...
                "For Bisection Method, f(a) and f(b) must have opposite signs.");

            valid = %f;

            return;

        end

    end

endfunction



// ============================================================
// CREATE FUNCTION PLOT
// ============================================================

function create_function_plot(f, a, b, root, ax)

    // Generate x values

    x = linspace(a, b, 300);


    // Calculate function values

    y = zeros(x);


    for i = 1:length(x)

        y(i) = f(x(i));

    end


    // Select axes

    sca(ax);


    // Clear previous graph

    delete(ax.children);


    // Plot function

    plot(x, y);


    // Plot x-axis

    plot([a b], [0 0]);


    // Plot root

    plot(root, f(root), "ro");


    // Labels

    xlabel("x");

    ylabel("f(x)");

    title("Function and Calculated Root");


    // Grid

    xgrid();

endfunction



// ============================================================
// NUMERICAL CALCULATE CALLBACK
// ============================================================

function numerical_calculate_callback()

    // Read inputs

    [f, expression, method, a, b, x0, tol, maxIter, valid] = ...
        read_numerical_inputs();


    // Stop if invalid

    if valid == %f then

        return;

    end


    // ========================================================
    // SELECT METHOD
    // ========================================================

    if method == 1 then

        // Bisection Method

        [root, iterations, error_value, history] = ...
            bisection_method( ...
            f, a, b, tol, maxIter);

    else

        // Newton-Raphson Method

        [root, iterations, error_value, history] = ...
            newton_raphson_method( ...
            f, x0, tol, maxIter);

    end


    // ========================================================
    // GET GUI
    // ========================================================

    fig = gcf();


    // ========================================================
    // FIND RESULT CONTROLS
    // ========================================================

    root_result = ...
        findobj(fig, "tag", "root_result");

    iteration_result = ...
        findobj(fig, "tag", "iteration_result");

    error_result = ...
        findobj(fig, "tag", "error_result");

    status_result = ...
        findobj(fig, "tag", "numerical_status");


    // ========================================================
    // DISPLAY RESULTS
    // ========================================================

    root_result.string = ...
        "Root: " + ...
        string(round(root * 1000000) / 1000000);


    iteration_result.string = ...
        "Iterations: " + ...
        string(iterations);


    error_result.string = ...
        "Final Error: " + ...
        string(round(error_value * 1000000) / 1000000);


    // ========================================================
    // DISPLAY STATUS
    // ========================================================

    if method == 1 then

        status_result.string = ...
            "Status: Bisection Calculation Complete";

    else

        status_result.string = ...
            "Status: Newton-Raphson Calculation Complete";

    end


    // ========================================================
    // FIND GRAPH AXES
    // ========================================================

    ax = findobj(fig, ...
        "tag", "numerical_axes");


    if size(ax, "*") == 0 then

        messagebox( ...
            "Graph axes not found.");

        return;

    end


    // ========================================================
    // PLOT FUNCTION
    // ========================================================

    if method == 1 then

        create_function_plot( ...
            f, a, b, root, ax);

    else

        // For Newton-Raphson,
        // plot around initial guess

        plot_a = x0 - 5;

        plot_b = x0 + 5;


        create_function_plot( ...
            f, plot_a, plot_b, root, ax);

    end

endfunction



// ============================================================
// WHAT-IF COMPARISON
// Compare Bisection and Newton-Raphson
// ============================================================

function numerical_compare_callback()

    // Read inputs

    [f, expression, method, a, b, x0, tol, maxIter, valid] = ...
        read_numerical_inputs();


    // Stop if invalid

    if valid == %f then

        return;

    end


    // ========================================================
    // BISECTION
    // ========================================================

    fa = f(a);

    fb = f(b);


    if fa * fb > 0 then

        messagebox( ...
            "Comparison requires f(a) and f(b) to have opposite signs for Bisection.");

        return;

    end


    [root_bis, iter_bis, error_bis, history_bis] = ...
        bisection_method( ...
        f, a, b, tol, maxIter);


    // ========================================================
    // NEWTON-RAPHSON
    // ========================================================

    [root_newton, iter_newton, error_newton, history_newton] = ...
        newton_raphson_method( ...
        f, x0, tol, maxIter);


    // ========================================================
    // GET GUI
    // ========================================================

    fig = gcf();


    // ========================================================
    // FIND GRAPH
    // ========================================================

    ax = findobj(fig, ...
        "tag", "numerical_axes");


    if size(ax, "*") == 0 then

        messagebox( ...
            "Graph axes not found.");

        return;

    end


    // ========================================================
    // CLEAR GRAPH
    // ========================================================

    sca(ax);

    delete(ax.children);


    // ========================================================
    // PREPARE ITERATION NUMBERS
    // ========================================================

    n1 = length(history_bis);

    n2 = length(history_newton);


    iter1 = 1:n1;

    iter2 = 1:n2;


    // ========================================================
    // PLOT CONVERGENCE
    // ========================================================

    plot(iter1, history_bis);

    plot(iter2, history_newton);


    // ========================================================
    // LABELS
    // ========================================================

    xlabel("Iteration");

    ylabel("Approximate Root");

    title("WHAT-IF ANALYSIS: Method Comparison");


    // ========================================================
    // LEGEND
    // ========================================================

    legend([
        "Bisection";
        "Newton-Raphson"
    ]);


    // ========================================================
    // GRID
    // ========================================================

    xgrid();


    // ========================================================
    // UPDATE RESULTS
    // ========================================================

    root_result = ...
        findobj(fig, "tag", "root_result");

    iteration_result = ...
        findobj(fig, "tag", "iteration_result");

    error_result = ...
        findobj(fig, "tag", "error_result");

    status_result = ...
        findobj(fig, "tag", "numerical_status");


    root_result.string = ...
        "Bisection Root: " + ...
        string(round(root_bis * 1000000) / 1000000);


    iteration_result.string = ...
        "Bisection Iterations: " + ...
        string(iter_bis);


    error_result.string = ...
        "Bisection Error: " + ...
        string(round(error_bis * 1000000) / 1000000);


    status_result.string = ...
        "Comparison: Bisection vs Newton-Raphson";


endfunction



// ============================================================
// NUMERICAL METHODS GUI
// ============================================================

function numerical_gui()

    // ========================================================
    // CREATE MAIN WINDOW
    // ========================================================

    f = figure();


    f.figure_name = ...
        "SciLab SimuVerse - Numerical Methods Lab";


    f.figure_position = ...
        [50 50];


    f.figure_size = ...
        [1200 700];


    // ========================================================
    // TITLE
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "NUMERICAL METHODS LAB", ...
        "position", ...
        [400 600 400 40], ...
        "fontsize", 22,...
        "horizontalalignment","center");


    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Root Finding and Numerical Analysis", ...
        "position", ...
        [400 585 400 25], ...
        "fontsize", 12,...
        "horizontalalignment","center");


    // ========================================================
    // METHOD SELECTION
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Select Method", ...
        "position", ...
        [50 550 180 30], ...
        "fontsize", 11);


    uicontrol(f, ...
        "style", "popupmenu", ...
        "string", ...
        "Bisection|Newton-Raphson", ...
        "value", 1, ...
        "tag", ...
        "numerical_method", ...
        "position", ...
        [240 550 180 30]);


    // ========================================================
    // FUNCTION INPUT
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Function f(x)", ...
        "position", ...
        [50 500 180 30], ...
        "fontsize", 11);


    uicontrol(f, ...
        "style", "edit", ...
        "string", ...
        "x^3-x-2", ...
        "tag", ...
        "function_input", ...
        "position", ...
        [240 500 180 30]);


    // ========================================================
    // LOWER BOUND
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Lower Bound (a)", ...
        "position", ...
        [50 450 180 30]);


    uicontrol(f, ...
        "style", "edit", ...
        "string", ...
        "1", ...
        "tag", ...
        "lower_bound", ...
        "position", ...
        [240 450 180 30]);


    // ========================================================
    // UPPER BOUND
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Upper Bound (b)", ...
        "position", ...
        [50 400 180 30]);


    uicontrol(f, ...
        "style", "edit", ...
        "string", ...
        "2", ...
        "tag", ...
        "upper_bound", ...
        "position", ...
        [240 400 180 30]);


    // ========================================================
    // INITIAL GUESS
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Initial Guess (x0)", ...
        "position", ...
        [50 350 180 30]);


    uicontrol(f, ...
        "style", "edit", ...
        "string", ...
        "1.5", ...
        "tag", ...
        "initial_guess", ...
        "position", ...
        [240 350 180 30]);


    // ========================================================
    // TOLERANCE
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Tolerance", ...
        "position", ...
        [50 300 180 30]);


    uicontrol(f, ...
        "style", "edit", ...
        "string", ...
        "0.0001", ...
        "tag", ...
        "tolerance", ...
        "position", ...
        [240 300 180 30]);


    // ========================================================
    // MAX ITERATIONS
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Maximum Iterations", ...
        "position", ...
        [50 250 180 30]);


    uicontrol(f, ...
        "style", "edit", ...
        "string", ...
        "50", ...
        "tag", ...
        "max_iterations", ...
        "position", ...
        [240 250 180 30]);


    // ========================================================
    // CALCULATE BUTTON
    // ========================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", ...
        "CALCULATE", ...
        "position", ...
        [50 170 160 50], ...
        "fontsize", 12, ...
        "callback", ...
        "numerical_calculate_callback()");


    // ========================================================
    // COMPARE BUTTON
    // ========================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", ...
        "COMPARE METHODS", ...
        "position", ...
        [230 170 190 50], ...
        "fontsize", 12, ...
        "callback", ...
        "numerical_compare_callback()");


    // ========================================================
    // RESULTS TITLE
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "RESULTS", ...
        "position", ...
        [50 120 150 30], ...
        "fontsize", 14);


    // ========================================================
    // ROOT RESULT
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Root: -", ...
        "tag", ...
        "root_result", ...
        "position", ...
        [50 85 350 30]);


    // ========================================================
    // ITERATION RESULT
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Iterations: -", ...
        "tag", ...
        "iteration_result", ...
        "position", ...
        [50 50 350 30]);


    // ========================================================
    // ERROR RESULT
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Final Error: -", ...
        "tag", ...
        "error_result", ...
        "position", ...
        [50 15 350 30]);


    // ========================================================
    // STATUS
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "Status: Ready", ...
        "tag", ...
        "numerical_status", ...
        "position", ...
        [400 85 350 30]);


    // ========================================================
    // GRAPH AXES
    // ========================================================

    ax = newaxes();


    ax.parent = f;


    ax.axes_bounds = ...
        [0.40 0.15 0.55 0.65];


    ax.tag = ...
        "numerical_axes";


endfunction

// ============================================================
// SCILAB SIMUVERSE
// DATA VISUALIZATION DASHBOARD
// FINAL CORRECTED VERSION
// ============================================================


// ============================================================
// GLOBAL DATA
// ============================================================

global DATASET;
global HEADERS;

DATASET = [];
HEADERS = [];


// ============================================================
// CREATE SAMPLE DATA
// ============================================================

function [data, headers] = create_sample_data()

    // Student ID
    student_id = (1:20)';

    // Study Hours
    study_hours = [
        1.5;
        2;
        2.5;
        3;
        3.5;
        4;
        4.5;
        5;
        5.5;
        6;
        6.5;
        7;
        7.5;
        8;
        8.5;
        9;
        9.5;
        10;
        10.5;
        11
    ];

    // Attendance
    attendance = [
        55;
        60;
        62;
        65;
        68;
        70;
        72;
        75;
        76;
        78;
        80;
        82;
        84;
        85;
        87;
        89;
        90;
        92;
        94;
        96
    ];

    // Marks
    marks = [
        42;
        48;
        51;
        55;
        59;
        62;
        65;
        68;
        70;
        73;
        75;
        78;
        80;
        82;
        85;
        87;
        89;
        92;
        94;
        97
    ];

    // Combine data
    data = [
        student_id study_hours attendance marks
    ];

    // Headers
    headers = [
        "Student_ID";
        "Study_Hours";
        "Attendance";
        "Marks"
    ];

endfunction


// ============================================================
// CALCULATE BASIC STATISTICS
// ============================================================

function [mean_val, median_val, mode_val, ...
          variance_val, std_val, min_val, max_val] = ...
          calculate_statistics(x)

    // Remove NaN values
    x = x(~isnan(x));

    if length(x) == 0 then

        mean_val = %nan;
        median_val = %nan;
        mode_val = %nan;
        variance_val = %nan;
        std_val = %nan;
        min_val = %nan;
        max_val = %nan;

        return;

    end

    // Mean
    mean_val = mean(x);

    // Median
    median_val = median(x);

    // Mode
    unique_values = unique(x);

    frequency = zeros(1, length(unique_values));

    for i = 1:length(unique_values)

        frequency(i) = ...
            sum(x == unique_values(i));

    end

    [max_frequency, index] = max(frequency);

    if max_frequency > 1 then

        mode_val = unique_values(index);

    else

        mode_val = %nan;

    end

    // Variance
    variance_val = variance(x);

    // Standard deviation
    std_val = stdev(x);

    // Minimum
    min_val = min(x);

    // Maximum
    max_val = max(x);

endfunction


// ============================================================
// CORRELATION
// ============================================================

function correlation_value = calculate_correlation(x, y)

    correlation_value = correl(x, y);

endfunction


// ============================================================
// SIMPLE LINEAR REGRESSION
//
// y = m*x + c
// ============================================================

function [m, c, y_pred] = linear_regression(x, y)

    n = length(x);

    denominator = ...
        n * sum(x .* x) - sum(x)^2;

    // Avoid division by zero
    if abs(denominator) < 1d-12 then

        m = 0;

        c = mean(y);

        y_pred = m * x + c;

        return;

    end

    // Slope
    m = ...
        (n * sum(x .* y) - ...
        sum(x) * sum(y)) / denominator;

    // Intercept
    c = ...
        (sum(y) - m * sum(x)) / n;

    // Predicted values
    y_pred = m * x + c;

endfunction


// ============================================================
// DATASET INFORMATION
// ============================================================

function [rows, columns] = dataset_info(data)

    [rows, columns] = size(data);

endfunction


// ============================================================
// LOAD CSV CALLBACK
// ============================================================

function data_load_csv_callback()

    global DATASET;
    global HEADERS;

    // Select CSV file
    [filename, pathname] = ...
        uigetfile(["*.csv"], ...
        "Select CSV Dataset");

    // Cancel check
    if filename == "" then

        return;

    end

    // Full file path
    filepath = pathname + filename;

    // Read CSV
    try

        DATASET = csvRead(filepath);

    catch

        messagebox( ...
            "Error reading CSV file.");

        return;

    end

    // Get dimensions
    [rows, columns] = size(DATASET);

    // Generate generic headers
    HEADERS = [];

    for i = 1:columns

        HEADERS(i) = ...
            "Column_" + string(i);

    end

    // Get GUI
    fig = gcf();

    // Update rows
    findobj(fig, ...
        "tag", "rows_result").string = ...
        "Rows: " + string(rows);

    // Update columns
    findobj(fig, ...
        "tag", "columns_result").string = ...
        "Columns: " + string(columns);

    // Update status
    findobj(fig, ...
        "tag", "data_status").string = ...
        "Status: CSV Loaded Successfully";

    messagebox( ...
        "Dataset loaded successfully." + ...
        ascii(10) + ...
        "Rows: " + string(rows) + ...
        ascii(10) + ...
        "Columns: " + string(columns));

endfunction


// ============================================================
// SAMPLE DATA CALLBACK
// ============================================================

function data_sample_callback()

    global DATASET;
    global HEADERS;

    // Create sample data
    [DATASET, HEADERS] = ...
        create_sample_data();

    // Get dimensions
    [rows, columns] = ...
        size(DATASET);

    // Get GUI
    fig = gcf();

    // Update rows
    findobj(fig, ...
        "tag", "rows_result").string = ...
        "Rows: " + string(rows);

    // Update columns
    findobj(fig, ...
        "tag", "columns_result").string = ...
        "Columns: " + string(columns);

    // Update status
    findobj(fig, ...
        "tag", "data_status").string = ...
        "Status: Sample Dataset Loaded";

    messagebox( ...
        "Sample student dataset loaded.");

endfunction


// ============================================================
// VISUALIZATION CALLBACK
// ============================================================

function data_visualize_callback()

    global DATASET;

    // Check dataset
    if size(DATASET, 1) == 0 then

        messagebox( ...
            "Please load a dataset first.");

        return;

    end

    // Get GUI
    fig = gcf();

    // Get X selection
    x_control = ...
        findobj(fig, "tag", "x_column");

    // Get Y selection
    y_control = ...
        findobj(fig, "tag", "y_column");

    // Get chart selection
    chart_control = ...
        findobj(fig, "tag", "chart_type");

    x_index = x_control.value;

    y_index = y_control.value;

    chart_index = chart_control.value;

    // Check valid column indexes
    [rows, columns] = size(DATASET);

    if x_index > columns | y_index > columns then

        messagebox( ...
            "Invalid column selection.");

        return;

    end

    // Select data
    x = DATASET(:, x_index);

    y = DATASET(:, y_index);

    // Find embedded GUI axes
    ax = findobj(fig, ...
        "tag", "data_axes");

    // Check axes
    if size(ax, "*") == 0 then

        messagebox( ...
            "Graph axes not found.");

        return;

    end

    // ========================================================
    // IMPORTANT FIX
    // ========================================================
    // Select embedded axes
    sca(ax);

    // Clear ONLY the embedded axes
    delete(ax.children);

    // ========================================================
    // LINE PLOT
    // ========================================================

    if chart_index == 1 then

        plot(x, y);

        xlabel("X Data");

        ylabel("Y Data");

        title("Line Plot");

        xgrid();


    // ========================================================
    // BAR CHART
    // ========================================================

    elseif chart_index == 2 then

        bar(x, y);

        xlabel("X Data");

        ylabel("Y Data");

        title("Bar Chart");


    // ========================================================
    // HISTOGRAM
    // ========================================================

    elseif chart_index == 3 then

        histplot(20, y);

        xlabel("Value");

        ylabel("Frequency");

        title("Histogram");


    // ========================================================
    // SCATTER PLOT
    // ========================================================

    elseif chart_index == 4 then

        plot(x, y, "o");

        xlabel("X Data");

        ylabel("Y Data");

        title("Scatter Plot");

        xgrid();

    end

    // Update status
    findobj(fig, ...
        "tag", "data_status").string = ...
        "Status: Visualization Generated";

endfunction


// ============================================================
// ANALYZE DATA CALLBACK
// ============================================================

function data_analyze_callback()

    global DATASET;

    // Check dataset
    if size(DATASET, 1) == 0 then

        messagebox( ...
            "Please load a dataset first.");

        return;

    end

    // Get GUI
    fig = gcf();

    // Get Y column
    y_index = ...
        findobj(fig, ...
        "tag", "y_column").value;

    // Get Y data
    y = DATASET(:, y_index);

    // Calculate statistics
    [mean_val, median_val, mode_val, ...
     variance_val, std_val, ...
     min_val, max_val] = ...
     calculate_statistics(y);

    // Display mean
    findobj(fig, ...
        "tag", "mean_result").string = ...
        "Mean: " + string(mean_val);

    // Display median
    findobj(fig, ...
        "tag", "median_result").string = ...
        "Median: " + string(median_val);

    // Display standard deviation
    findobj(fig, ...
        "tag", "std_result").string = ...
        "Std Dev: " + string(std_val);

    // Display minimum
    findobj(fig, ...
        "tag", "min_result").string = ...
        "Min: " + string(min_val);

    // Display maximum
    findobj(fig, ...
        "tag", "max_result").string = ...
        "Max: " + string(max_val);

    // Update status
    findobj(fig, ...
        "tag", "data_status").string = ...
        "Status: Statistical Analysis Complete";

endfunction


// ============================================================
// ML INSIGHTS CALLBACK
// ============================================================

function data_ml_callback()

    global DATASET;

    // Check dataset
    if size(DATASET, 1) == 0 then

        messagebox( ...
            "Please load a dataset first.");

        return;

    end

    // Get GUI
    fig = gcf();

    // Get X column
    x_index = ...
        findobj(fig, ...
        "tag", "x_column").value;

    // Get Y column
    y_index = ...
        findobj(fig, ...
        "tag", "y_column").value;

    // Extract data
    x = DATASET(:, x_index);

    y = DATASET(:, y_index);

    // Calculate correlation
    correlation_value = ...
        calculate_correlation(x, y);

    // Calculate linear regression
    [m, c, y_pred] = ...
        linear_regression(x, y);

    // Display correlation
    findobj(fig, ...
        "tag", "correlation_result").string = ...
        "Correlation: " + ...
        string(correlation_value);

    // Determine relationship
    if correlation_value > 0.7 then

        insight = ...
            "Strong Positive Relationship";

    elseif correlation_value > 0.3 then

        insight = ...
            "Moderate Positive Relationship";

    elseif correlation_value < -0.7 then

        insight = ...
            "Strong Negative Relationship";

    elseif correlation_value < -0.3 then

        insight = ...
            "Moderate Negative Relationship";

    else

        insight = ...
            "Weak or No Linear Relationship";

    end

    // Display ML insight
    findobj(fig, ...
        "tag", "ml_result").string = ...
        "ML Insight: " + insight;

    // Find embedded axes
    ax = findobj(fig, ...
        "tag", "data_axes");

    // Check axes
    if size(ax, "*") == 0 then

        messagebox( ...
            "Graph axes not found.");

        return;

    end

    // ========================================================
    // IMPORTANT FIX
    // ========================================================

    // Select embedded GUI axes
    sca(ax);

    // Clear ONLY embedded axes
    delete(ax.children);

    // Plot actual data
    plot(x, y, "o");

    // Plot regression
    plot(x, y_pred);

    // Labels
    xlabel("Feature X");

    ylabel("Target Y");

    title("Linear Regression Trend Analysis");

    xgrid();

    // Legend
    legend([
        "Actual Data";
        "Regression Trend"
    ]);

    // Update status
    findobj(fig, ...
        "tag", "data_status").string = ...
        "Status: ML Insight Generated";

endfunction


// ============================================================
// MAIN GUI
// ============================================================

function data_gui()

    // Create figure
    f = figure();

    f.figure_name = ...
        "SciLab SimuVerse - Data Visualization Dashboard";

    f.figure_position = [50 50];

    f.figure_size = [1200 700];


    // ========================================================
    // TITLE
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", ...
        "DATA VISUALIZATION DASHBOARD", ...
        "position", [350 600 500 40], ...
        "fontsize", 20,...
        "horizontalalignment","center");


    // ========================================================
    // LOAD CSV
    // ========================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "LOAD CSV", ...
        "position", [50 550 150 45], ...
        "callback", ...
        "data_load_csv_callback()");


    // ========================================================
    // SAMPLE DATA
    // ========================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "SAMPLE DATA", ...
        "position", [220 550 150 45], ...
        "callback", ...
        "data_sample_callback()");


    // ========================================================
    // DATASET INFO
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Rows: -", ...
        "tag", "rows_result", ...
        "position", [50 500 150 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Columns: -", ...
        "tag", "columns_result", ...
        "position", [220 500 150 30]);


    // ========================================================
    // X COLUMN
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "X Column", ...
        "position", [50 440 120 30]);


    uicontrol(f, ...
        "style", "popupmenu", ...
        "string", ...
        "Student_ID|Study_Hours|Attendance|Marks", ...
        "tag", "x_column", ...
        "position", [180 440 200 30]);


    // ========================================================
    // Y COLUMN
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Y Column", ...
        "position", [50 390 120 30]);


    uicontrol(f, ...
        "style", "popupmenu", ...
        "string", ...
        "Student_ID|Study_Hours|Attendance|Marks", ...
        "tag", "y_column", ...
        "position", [180 390 200 30]);


    // ========================================================
    // CHART TYPE
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Chart Type", ...
        "position", [50 340 120 30]);


    uicontrol(f, ...
        "style", "popupmenu", ...
        "string", ...
        "Line Plot|Bar Chart|Histogram|Scatter Plot", ...
        "tag", "chart_type", ...
        "position", [180 340 200 30]);


    // ========================================================
    // VISUALIZE BUTTON
    // ========================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "VISUALIZE", ...
        "position", [50 270 150 50], ...
        "callback", ...
        "data_visualize_callback()");


    // ========================================================
    // ANALYZE BUTTON
    // ========================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "ANALYZE DATA", ...
        "position", [220 270 150 50], ...
        "callback", ...
        "data_analyze_callback()");


    // ========================================================
    // ML INSIGHTS BUTTON
    // ========================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "ML INSIGHTS", ...
        "position", [50 210 320 45], ...
        "callback", ...
        "data_ml_callback()");


    // ========================================================
    // STATISTICS
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Mean: -", ...
        "tag", "mean_result", ...
        "position", [50 150 150 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Median: -", ...
        "tag", "median_result", ...
        "position", [220 150 150 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Std Dev: -", ...
        "tag", "std_result", ...
        "position", [50 115 150 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Min: -", ...
        "tag", "min_result", ...
        "position", [220 115 150 30]);


    uicontrol(f, ...
        "style", "text", ...
        "string", "Max: -", ...
        "tag", "max_result", ...
        "position", [50 80 150 30]);


    // ========================================================
    // CORRELATION
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Correlation: -", ...
        "tag", "correlation_result", ...
        "position", [220 80 180 30]);


    // ========================================================
    // ML RESULT
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "ML Insight: -", ...
        "tag", "ml_result", ...
        "position", [50 40 350 30]);


    // ========================================================
    // EMBEDDED GRAPH AXES
    // ========================================================

    ax = newaxes();

    ax.parent = f;

    ax.axes_bounds = ...
        [0.40 0.20 0.55 0.65];

    ax.tag = "data_axes";


    // ========================================================
    // STATUS
    // ========================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Status: Ready", ...
        "tag", "data_status", ...
        "position", [500 50 400 30]);

endfunction


// ============================================================
// START APPLICATION
// ============================================================


function simuverse_main()

    // ======================================================
    // CREATE MAIN WINDOW
    // ======================================================

    f = figure();

    f.figure_name = "SciLab SimuVerse";

    // Window position
    f.figure_position = [100 50];

    // Window size
    f.figure_size = [1200 700];

    // Background color
    f.background = [0.94 0.96 0.98];


    // ======================================================
    // TITLE
    // ======================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "SCILAB SIMUVERSE", ...
        "position", [300 600 600 50], ...
        "fontsize", 24, ...
        "fontweight", "bold",...
        "horizontalalignment","center");


    // ======================================================
    // SUBTITLE
    // ======================================================

    uicontrol(f, ...
        "style", "text", ...
        "string", "Interactive Virtual STEM & Engineering Laboratory", ...
        "position", [300 585 600 30], ...
        "fontsize", 12,...
        "horizontalalignment","center");


    // ======================================================
    // PHYSICS LAB
    // ======================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "PHYSICS LAB", ...
        "position", [150 380 350 80], ...
        "fontsize", 16, ...
        "callback", "projectile_gui()");


    // ======================================================
    // ELECTRONICS LAB
    // ======================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "ELECTRONICS LAB", ...
        "position", [600 380 350 80], ...
        "fontsize", 16, ...
        "callback", "rc_gui()");


    // ======================================================
    // NUMERICAL LAB
    // ======================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "NUMERICAL LAB", ...
        "position", [150 250 350 80], ...
        "fontsize", 16, ...
        "callback", "numerical_gui()");


    // ======================================================
    // DATA SCIENCE
    // ======================================================

    uicontrol(f, ...
        "style", "pushbutton", ...
        "string", "DATA SCIENCE", ...
        "position", [600 250 350 80], ...
        "fontsize", 16, ...
        "callback", "data_gui()");


endfunction

// Start application
simuverse_main();

