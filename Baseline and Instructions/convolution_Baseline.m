function convolution_Baseline()
    % Create figure
    fig = figure('Name', 'Graphical Convolution Demo', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 800, 650]);  % Increased figure height

    % Dropdown menus for input and impulse response selection (Moved higher)
    uicontrol('Style', 'text', 'Position', [120 630 120 20], 'String', 'Input Signal');
    inputMenu = uicontrol('Style', 'popupmenu', 'Position', [120 600 180 30], ...
                          'String', {'Rectangular Pulse', 'Triangular Pulse', 'Exponential Decay', 'Sine Wave', 'Unit Step'});

    uicontrol('Style', 'text', 'Position', [500 630 140 20], 'String', 'Impulse Response');
    impulseMenu = uicontrol('Style', 'popupmenu', 'Position', [500 600 180 30], ...
                            'String', {'Rectangular Pulse', 'Triangular Pulse', 'Exponential Decay', 'Sine Wave', 'Unit Step'});

    % Button to compute and visualize convolution (Moved higher)
    uicontrol('Style', 'pushbutton', 'Position', [320 600 150 30], 'String', 'Run Convolution', ...
              'Callback', @(src,event) runConvolution(fig, inputMenu, impulseMenu));

    % Axes for plotting
    ax1 = axes('Position', [0.1 0.65 0.35 0.25]); 
    title(ax1, 'Input Signal'); xlabel(ax1, 'Time'); ylabel(ax1, 'Amplitude');
    grid(ax1, 'on');

    ax2 = axes('Position', [0.55 0.65 0.35 0.25]); 
    title(ax2, 'Impulse Response'); xlabel(ax2, 'Time'); ylabel(ax2, 'Amplitude');
    grid(ax2, 'on');

    ax3 = axes('Position', [0.1 0.25 0.8 0.35]); 
    title(ax3, 'Graphical Convolution Animation'); xlabel(ax3, 'Time'); ylabel(ax3, 'Amplitude');
    grid(ax3, 'on');

    % Store axes handles in the figure for later access
    setappdata(fig, 'ax1', ax1);
    setappdata(fig, 'ax2', ax2);
    setappdata(fig, 'ax3', ax3);
end

function runConvolution(fig, inputMenu, impulseMenu)
    % Time vector
    dt = 0.02;  
    t = -5:dt:5; 
    
    % Get user selections
    inputIdx = get(inputMenu, 'Value');
    impulseIdx = get(impulseMenu, 'Value');
    
    % Generate selected signals
    x = getFunction(inputIdx, t);
    h = getFunction(impulseIdx, t);
    
    % Compute convolution
    conv_result = conv(x, h, 'same') * dt; 
    t_conv = linspace(2*min(t), 2*max(t), length(conv_result));

    % Retrieve stored axes handles from figure
    ax1 = getappdata(fig, 'ax1');
    ax2 = getappdata(fig, 'ax2');
    ax3 = getappdata(fig, 'ax3');

    % Plot input and impulse response
    cla(ax1); % Clear previous plots
    plot(ax1, t, x, 'b', 'LineWidth', 2);
    title(ax1, 'Input Signal'); grid(ax1, 'on');
    ylim(ax1, [-0.5, 2.5]);

    cla(ax2);
    plot(ax2, t, h, 'r', 'LineWidth', 2);
    title(ax2, 'Impulse Response'); grid(ax2, 'on');
    ylim(ax2, [-0.5, 2.5]);

    % Animation - Graphical Convolution
    cla(ax3);
    hold(ax3, 'on');
    conv_values = zeros(size(t));
    for i = 1:length(t)
        tau = t(i);
        
        % Flipped and shifted impulse response
        %flipped_h = getFunction(impulseIdx, t - tau);
        flipped_h = getFunction(impulseIdx, -t + tau);

        % Compute convolution at this shift
        conv_values(i) = sum(x .* flipped_h) * dt;

        % Clear and replot animation
        cla(ax3);
        plot(ax3, t, x, 'b', 'LineWidth', 2);
        plot(ax3, t, flipped_h, 'r--', 'LineWidth', 2);
        plot(ax3, t(1:i), conv_values(1:i), 'g', 'LineWidth', 2);
        title(ax3, 'Graphical Convolution Animation');
        legend(ax3, 'Input Signal', 'Flipped & Shifted Impulse', 'Convolution Result');
        ylim(ax3, [-0.5, 2.5]);
        grid(ax3, 'on');
        pause(0.1);
    end
end

function y = getFunction(index, t)
    % Function selector based on dropdown index
    switch index
        case 1 % Rectangular Pulse
            y = (t >= -1 & t <= 1);
        case 2 % Triangular Pulse
            y = (1 - abs(t)) .* (abs(t) <= 1);
        case 3 % Exponential Decay
            y = exp(-abs(t)) .* (t >= 0);
        case 4 % Sine Wave
            y = sin(2 * pi * 0.5 * t) .* (abs(t) <= 2);
        case 5 % Unit Step Function
            y = (t >= 0);  % Heaviside step function
    end
end