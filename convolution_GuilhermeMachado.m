function convolution_GuilhermeMachado
% GRAPHICAL_CONVOLUTION_PROJECT
% Two-mode GUI:
%   1) General Graphical Convolution
%   2) Probability & Statistics Mode (PDFs)
%
% This file extends the behavior of the original convolution_gui2.m idea
% into a multi-mode project-style GUI.

    % Create main figure (Mode Selector)
    fig = figure('Name', 'Graphical Convolution Project', ...
             'NumberTitle', 'off', ...
             'Position', [100 50 1200 1200], ...  
             'MenuBar', 'none', ...
             'ToolBar', 'none');


    % Store figure handle in appdata for easy access
    setappdata(fig, 'mainFig', fig);

    buildModeSelector(fig);
end

function yTop = topControlsY(fig)
    % Place controls near the top with a comfortable offset (scales with height).
    figPos = get(fig, 'Position');
    figWidth = figPos(3);
    figHeight = figPos(4);
    yBottom = bottomControlsY(fig);
    yTop = figHeight * 0.95;  % about 5% margin from the top
end

function yBottom = bottomControlsY(fig)
    % Place bottom controls about 20% above the bottom (scales with height).
    figPos = get(fig, 'Position');
    figHeight = figPos(4);
    yBottom = figHeight * 0.15;
end

%% ====== MODE SELECTOR SCREEN ============================================
function buildModeSelector(fig)
    clf(fig);

    figPos = get(fig, 'Position');
    figWidth = figPos(3);
    figHeight = figPos(4);
    figHeight = figPos(4);

    buttonWidth  = 360;
    buttonHeight = 70;
    centerX      = (figWidth - buttonWidth) / 2;

    % Wider centered title/subtitle so the text does not get clipped
    titleWidth = figWidth - 100;
    titleX = (figWidth - titleWidth) / 2;
    titleY = figHeight - 120;
    
    % Title
    uicontrol('Parent', fig, 'Style', 'text', ...
        'String', 'Graphical Convolution Project', ...
        'FontSize', 22, 'FontWeight', 'bold', ...
        'BackgroundColor', get(fig, 'Color'), ...
        'HorizontalAlignment', 'center', ...
        'Position', [titleX titleY titleWidth 50]);
    
    % Subtitle
    uicontrol('Parent', fig, 'Style', 'text', ...
        'String', 'Please choose a mode to begin', ...
        'FontSize', 14, ...
        'BackgroundColor', get(fig, 'Color'), ...
        'HorizontalAlignment', 'center', ...
        'Position', [titleX titleY-40 titleWidth 30]);
    
    % General Mode Button
    uicontrol('Parent', fig, 'Style', 'pushbutton', ...
        'String', 'General Graphical Convolution', ...
        'FontSize', 14, 'FontWeight', 'bold', ...
        'BackgroundColor', [0.9 0.9 1], ...
        'Position', [centerX 640 buttonWidth buttonHeight], ...
        'Callback', @(~,~) buildGeneralMode(fig));
    
    % Probability Mode Button
    uicontrol('Parent', fig, 'Style', 'pushbutton', ...
        'String', 'Probability && Statistics Mode', ...
        'FontSize', 14, 'FontWeight', 'bold', ...
        'BackgroundColor', [0.9 1 0.9], ...
        'Position', [centerX 560 buttonWidth buttonHeight], ...
        'Callback', @(~,~) buildProbabilityMode(fig));

end

%% ========================================================================
%                        COMMON SIGNAL CONTROLS
% ========================================================================

function handles = buildCommonSignalControls(fig, yTop)

    figPos = get(fig, 'Position');
    figHeight = figPos(4);

    font = 11;
    left = 180;      
    spacing = 180;   
    statusY = figHeight * 0.05;  % keep status line ~5% above bottom

    % x(t) Template
    uicontrol('Parent', fig, 'Style', 'text', ...
        'String', 'x(t) Template', ...
        'FontSize', font, ...
        'BackgroundColor', get(fig, 'Color'), ...
        'Position', [left yTop 150 25]);
    handles.popupX = uicontrol('Parent', fig, 'Style', 'popupmenu', ...
        'FontSize', font, ...
        'Position', [left yTop-35 150 28], ...
        'String', {'Rect','Tri','Exp','Sine','Step','Ramp','Custom'});

    % h(t) Template
    uicontrol('Parent', fig, 'Style', 'text', ...
        'String', 'h(t) Template', ...
        'FontSize', font, ...
        'BackgroundColor', get(fig, 'Color'), ...
        'Position', [left + spacing yTop 150 25]);
    handles.popupH = uicontrol('Parent', fig, 'Style', 'popupmenu', ...
        'FontSize', font, ...
        'Position', [left + spacing yTop-35 150 28], ...
        'String', {'Rect','Tri','Exp','Sine','Step','Ramp','Custom'});

    % Amplitudes
    uicontrol('Parent', fig, 'Style', 'text', ...
        'String', 'Amplitude Ax, Ah', ...
        'FontSize', font, ...
        'BackgroundColor', get(fig, 'Color'), ...
        'Position', [left + 2*spacing yTop 150 25]);
    handles.editAx = uicontrol('Parent', fig, 'Style', 'edit', ...
        'FontSize', font, ...
        'Position', [left + 2*spacing yTop-35 70 28], 'String', '1');
    handles.editAh = uicontrol('Parent', fig, 'Style', 'edit', ...
        'FontSize', font, ...
        'Position', [left + 2*spacing + 80 yTop-35 70 28], 'String', '1');

    % Width
    uicontrol('Parent', fig, 'Style', 'text', ...
        'String', 'Width Wx, Wh', ...
        'FontSize', font, ...
        'BackgroundColor', get(fig, 'Color'), ...
        'Position', [left + 3*spacing yTop 150 25]);
    handles.editWx = uicontrol('Parent', fig, 'Style', 'edit', ...
        'FontSize', font, ...
        'Position', [left + 3*spacing yTop-35 70 28], 'String', '2');
    handles.editWh = uicontrol('Parent', fig, 'Style', 'edit', ...
        'FontSize', font, ...
        'Position', [left + 3*spacing + 80 yTop-35 70 28], 'String', '2');

    % Time Range
    uicontrol('Parent', fig, 'Style', 'text', ...
        'String', 'tstart, tend, dt', ...
        'FontSize', font, ...
        'BackgroundColor', get(fig, 'Color'), ...
        'Position', [left + 4*spacing yTop 200 25]);
    handles.editTstart = uicontrol('Parent', fig,'Style','edit', ...
        'FontSize', font, 'Position',[left + 4*spacing yTop-35 70 28],'String','-6');
    handles.editTend = uicontrol('Parent', fig,'Style','edit', ...
        'FontSize', font, 'Position',[left + 4*spacing + 80 yTop-35 70 28],'String','6');
    handles.editDt = uicontrol('Parent', fig,'Style','edit', ...
        'FontSize', font,'Position',[left + 4*spacing + 160 yTop-35 70 28],'String','0.02');

    % Custom x(t)
    uicontrol('Parent', fig,'Style','text', ...
        'String','Custom x(t) =', ...
        'FontSize', font,'BackgroundColor',get(fig,'Color'), ...
        'Position',[left yTop-90 150 25]);
    handles.editCustomX = uicontrol('Parent', fig,'Style','edit', ...
        'FontSize', font, 'Position',[left+120 yTop-90 350 28], ...
        'String','exp(-abs(t)).*(t>=0)');

    % Custom h(t)
    uicontrol('Parent', fig,'Style','text', ...
        'String','Custom h(t) =', ...
        'FontSize', font,'BackgroundColor',get(fig,'Color'), ...
        'Position',[left+500 yTop-90 150 25]);
    handles.editCustomH = uicontrol('Parent', fig,'Style','edit', ...
        'FontSize', font,'Position',[left+620 yTop-90 350 28], ...
        'String','sin(2*pi*0.5*t).*(abs(t)<=2)');

    % Status Line
    handles.textStatus = uicontrol('Parent', fig,'Style','text', ...
        'String','Ready','FontSize', 11, ...
        'HorizontalAlignment','left', ...
        'BackgroundColor', get(fig,'Color'), ...
        'Position',[left statusY 1000 30]);
end


function [t, x, h, ok, msg] = generateSignalsFromControls(handles)
% Read parameters and generate x(t), h(t). 

    ok = false;
    msg = '';

    % Read params
    try
        Ax = str2double(get(handles.editAx, 'String'));
        Ah = str2double(get(handles.editAh, 'String'));
        Wx = str2double(get(handles.editWx, 'String'));
        Wh = str2double(get(handles.editWh, 'String'));
        tstart = str2double(get(handles.editTstart, 'String'));
        tend   = str2double(get(handles.editTend, 'String'));
        dt     = str2double(get(handles.editDt, 'String'));
    catch
        msg = 'Error parsing numeric parameters.';
        t = []; x = []; h = [];
        return;
    end

    if any(isnan([Ax Ah Wx Wh tstart tend dt])) || dt <= 0 || tend <= tstart
        msg = 'Invalid numeric parameters or time range.';
        t = []; x = []; h = [];
        return;
    end

    t = tstart:dt:tend;

    % Generate x(t)
    idxX = get(handles.popupX, 'Value');
    if idxX == 7  % custom
        exprX = get(handles.editCustomX, 'String');
        try
            x = evalCustomExpression(exprX, t);  % safe-ish wrapper
        catch
            msg = 'Error in custom x(t) expression.';
            t = []; x = []; h = [];
            return;
        end
    else
        x = templateFunction(idxX, t, Ax, Wx);
    end

    % Generate h(t)
    idxH = get(handles.popupH, 'Value');
    if idxH == 7  % custom
        exprH = get(handles.editCustomH, 'String');
        try
            h = evalCustomExpression(exprH, t);
        catch
            msg = 'Error in custom h(t) expression.';
            t = []; x = []; h = [];
            return;
        end
    else
        h = templateFunction(idxH, t, Ah, Wh);
    end

    % Apply amplitude (for custom, amplitude is included directly if they use Ax in expression,
    % but we'll still multiply by Ax/Ah to keep behavior consistent with templates)
    if idxX ~= 7
        x = Ax * x;
    end
    if idxH ~= 7
        h = Ah * h;
    end

    ok = true;
end

function y = templateFunction(index, t, A, W)
% Template definitions: Rect, Tri, Exp, Sine, Step, Ramp
    switch index
        case 1 % Rect
            y = (abs(t) <= W/2);
        case 2 % Tri
            y = (1 - abs(t)/(W/2)) .* (abs(t) <= W/2);
        case 3 % Exp (right-sided decay)
            y = exp(-abs(t)) .* (t >= 0) .* (t <= W);
        case 4 % Sine
            y = sin(2*pi*(1/W)*t) .* (abs(t) <= W/2);
        case 5 % Step
            y = (t >= 0);
        case 6 % Ramp
            y = (t >= 0 & t <= W) .* (t / max(W, eps));
        otherwise
            y = zeros(size(t));
    end
end

function y = evalCustomExpression(expr, t)
% Evaluate custom expression of t safely in workspace.
    % Only variable 't' is available. User should write in terms of t.
    y = eval(expr);
    if ~isvector(y) || numel(y) ~= numel(t)
        error('Custom expression must return a vector same size as t.');
    end
    y = y(:).'; % row vector
end

%% ========================================================================
%                        GENERAL CONVOLUTION MODE
% ========================================================================

function buildGeneralMode(fig)
    clf(fig);

    yBack = topControlsY(fig);

    % Back Button (unchanged)
    uicontrol('Parent', fig,'Style','pushbutton', ...
        'String','<- Back','FontSize',12,'FontWeight','bold', ...
        'BackgroundColor',[1 0.9 0.9], ...
        'Position',[20 yBack 120 35], ...
        'Callback',@(s,e) buildModeSelector(fig));

    % ======= TOP CONTROLS (Centered & Lowered) =======
    handles = buildCommonSignalControls(fig, topControlsY(fig));


    % ======= AXES (unchanged - EXACT positions preserved) =======
    handles.axX   = axes('Parent',fig,'Position',[0.08 0.52 0.38 0.23]);
    title(handles.axX, 'x(t)');
    grid(handles.axX, 'on');

    handles.axH   = axes('Parent',fig,'Position',[0.55 0.52 0.38 0.23]);
    title(handles.axH, 'h(t)');
    grid(handles.axH, 'on');

    handles.axProd= axes('Parent',fig,'Position',[0.08 0.25 0.38 0.23]);
    title(handles.axProd, 'x(\tau) h(t_0 - \tau)');
    grid(handles.axProd, 'on');

    handles.axConv= axes('Parent',fig,'Position',[0.55 0.25 0.38 0.23]);
    title(handles.axConv, 'y(t) = x*h');
    grid(handles.axConv, 'on');


    % ======= CENTERED BOTTOM BUTTON BAR =======

    figPos = get(fig, 'Position');
    figWidth = figPos(3);

    btnW = 150;
    btnH = 40;
    spacing = 25;

    % total width of 3 main buttons
    totalW = btnW*3 + spacing*2;
    startX = (figWidth - totalW) / 2;

    yBtn = bottomControlsY(fig);  % match bottom spacing logic to figure height


    % --- Generate Signals (Left button) ---
    uicontrol('Parent',fig,'Style','pushbutton', ...
        'String','Generate Signals','FontSize',12,'FontWeight','bold', ...
        'BackgroundColor',[0.8 0.9 1], ...
        'Position',[startX yBtn btnW btnH], ...
        'Callback',@(s,e) onGenerateGeneral(fig));


    % --- Run Convolution (Center button) ---
    uicontrol('Parent',fig,'Style','pushbutton', ...
        'String','Run Convolution','FontSize',12,'FontWeight','bold', ...
        'BackgroundColor',[0.8 1 0.8], ...
        'Position',[startX + btnW + spacing yBtn btnW btnH], ...
        'Callback',@(s,e) onRunConvolutionGeneral(fig));


    % --- Pause Toggle (Right button) ---
    handles.btnPause = uicontrol('Parent',fig,'Style','togglebutton', ...
        'String','Pause','FontSize',11, ...
        'Position',[startX + 2*(btnW + spacing) yBtn btnW btnH]);


    % --- Reset (just to the right of button row) ---
    uicontrol('Parent',fig,'Style','pushbutton','String','Reset', ...
        'FontSize',11,'BackgroundColor',[1 0.9 0.9], ...
        'Position',[startX + 3*(btnW + spacing) yBtn btnW btnH], ...
        'Callback',@(s,e) buildGeneralMode(fig));


    % --- Verification checkbox (left side like MATLAB apps) ---
    handles.chkVerify = uicontrol('Parent',fig,'Style','checkbox', ...
        'String','Show conv() verification','FontSize',11, ...
        'Position',[30 yBtn 220 25], 'Value',1);



    % ======= INTERNAL STATE =======
    handles.x = []; 
    handles.h = []; 
    handles.t = []; 
    handles.dt = [];
    handles.isAnimating = false;

    guidata(fig, handles);
end


function onGenerateGeneral(fig)
    handles = guidata(fig);

    [t, x, h, ok, msg] = generateSignalsFromControls(handles);
    if ~ok
        set(handles.textStatus, 'String', msg);
        return;
    end

    dt = t(2) - t(1);

    handles.t = t;
    handles.x = x;
    handles.h = h;
    handles.dt = dt;

    % Plot x and h
    cla(handles.axX); cla(handles.axH);
    plot(handles.axX, t, x, 'LineWidth', 2);
    title(handles.axX, sprintf('x(t), width ~= %.2f', signalWidth(t, x)));
    grid(handles.axX, 'on');

    plot(handles.axH, t, h, 'r', 'LineWidth', 2);
    title(handles.axH, sprintf('h(t), width ~= %.2f', signalWidth(t, h)));
    grid(handles.axH, 'on');

    set(handles.textStatus, 'String', 'Signals generated successfully.');
    guidata(fig, handles);
end

function onRunConvolutionGeneral(fig)
    handles = guidata(fig);

    if isempty(handles.t)
        set(handles.textStatus, 'String', 'Generate signals first.');
        return;
    end

    t = handles.t;
    x = handles.x;
    h = handles.h;
    dt = handles.dt;

    N = numel(t);

    % Preallocate convolution result (same t-grid as original for animation)
    y_anim = zeros(size(t));

    cla(handles.axProd);
    cla(handles.axConv);
    hold(handles.axConv, 'on');

    handles.isAnimating = true;
    guidata(fig, handles);

    % Manual convolution through graphical approach:
    % For each t0 in t, compute y(t0) = sum x(tau) * h(t0 - tau) dt
    for k = 1:N
        handles = guidata(fig);
        if ~handles.isAnimating
            break;
        end

        % Pause toggle check
        if get(handles.btnPause, 'Value') == 1
            pause(0.05);
            drawnow;
            continue;
        end

        t0 = t(k);
        % h(t0 - tau) using function template style evaluation
        % Evaluate h on shifted time: t0 - tau
        tau = t;
        h_shifted = interpShifted(h, t, t0, tau);

        % Pointwise product
        prodVal = x .* h_shifted;

        % Integral approximation
        y_anim(k) = sum(prodVal) * dt;

        % Plot x(t), shifted h(t0 - t), and their product
        cla(handles.axProd);
        hold(handles.axProd, 'on');
        plot(handles.axProd, t, x, 'b', 'LineWidth', 1.8);
        plot(handles.axProd, tau, h_shifted, 'r--', 'LineWidth', 1.8);
        plot(handles.axProd, tau, prodVal, 'm', 'LineWidth', 1.5);
        title(handles.axProd, sprintf('x(\\tau), h(t_0 - \\tau), product  (t_0=%.2f)', t0));
        legend(handles.axProd, {'x(t)','h(t_0 - t)','x(t)h(t_0 - t)'}, 'Location','best');
        grid(handles.axProd, 'on');
        hold(handles.axProd, 'off');

        % Plot partial convolution
        cla(handles.axConv);
        plot(handles.axConv, t(1:k), y_anim(1:k), 'g', 'LineWidth', 2);
        title(handles.axConv, 'y(t) = x*h (manual, animated)');
        grid(handles.axConv, 'on');

        drawnow;
        pause(0.03);
    end

    % Verification using conv()
    if get(handles.chkVerify, 'Value') == 1
        y_conv_full = conv(x, h) * dt;
        t_conv_full = linspace(2*t(1), 2*t(end), numel(y_conv_full));
        plot(handles.axConv, t_conv_full, y_conv_full, '--', 'Color', [1 0.8 0], 'LineWidth', 1.2); % bright yellow contrast
        legend(handles.axConv, 'Manual y(t)', 'conv() verification');
    end

    set(handles.textStatus, 'String', 'Convolution animation complete.');
end

function w = signalWidth(t, sig)
% Rough width: difference between first and last non-negligible points.
    thr = max(abs(sig)) * 0.01;
    idx = find(abs(sig) > thr);
    if isempty(idx)
        w = 0;
    else
        w = t(idx(end)) - t(idx(1));
    end
end

function hs = interpShifted(h, t, t0, tau)
% Build h(t0 - tau) on grid tau, using interpolation of discrete h(t).
    % We know h is defined on t. We want values of h at (t0 - tau).
    t_query = t0 - tau;
    hs = interp1(t, h, t_query, 'linear', 0); % outside support => 0
end

%% ====== PROBABILITY & STATISTICS MODE ===================================
function buildProbabilityMode(fig)
    clf(fig);

    yBack = topControlsY(fig);

    % Back Button (same position as general mode)
    uicontrol('Parent', fig,'Style','pushbutton', ...
        'String','<- Back','FontSize',12,'FontWeight','bold', ...
        'BackgroundColor',[1 0.9 0.9], ...
        'Position',[20 yBack 120 35], ...
        'Callback',@(s,e) buildModeSelector(fig));

    % Shared controls (same yTop as general mode)
    handles = buildCommonSignalControls(fig, topControlsY(fig));

    figPos = get(fig, 'Position');
    figWidth = figPos(3);
    figHeight = figPos(4);
    yBottom = bottomControlsY(fig);

    % Normalization toggle (aligned left like "Show conv() verification")
    handles.chkNormalize = uicontrol('Parent',fig,'Style','checkbox', ...
        'String','Normalize x, h, y to PDFs (integral = 1)', ...
        'FontSize',12, ...
        'Position',[30 yBottom 260 30], ...
        'Value',1);

    % === MATCH GENERAL MODE AXES LAYOUT ===
    % Top row: x(t) PDF, h(t) PDF
    handles.axXpdf = axes('Parent',fig,'Position',[0.08 0.52 0.38 0.23]);
    title(handles.axXpdf, 'x(t) PDF');
    grid(handles.axXpdf, 'on');

    handles.axHpdf = axes('Parent',fig,'Position',[0.55 0.52 0.38 0.23]);
    title(handles.axHpdf, 'h(t) PDF');
    grid(handles.axHpdf, 'on');

    % Bottom row: y(t) PDF (wide axis like gen-mode convolution output)
    handles.axYpdf = axes('Parent',fig,'Position',[0.08 0.25 0.85 0.23]);
    title(handles.axYpdf, 'y(t) = x*h PDF (Sum of RVs)');
    grid(handles.axYpdf, 'on');

    % === Bottom controls (matching general mode button layout) ===
    handles.btnGeneratePDF = uicontrol('Parent',fig,'Style','pushbutton', ...
        'String','Generate PDFs & Stats', ...
        'FontSize',12,'FontWeight','bold', ...
        'BackgroundColor',[0.8 1 0.8], ...
        'Position',[350 yBottom 200 40], ...
        'Callback',@(s,e) onGenerateProbability(fig));

    % Stats table (aligned right, same height region as buttons)
    handles.tableStats = uitable('Parent',fig, ...
        'Data', zeros(3,3), ...
        'ColumnName',{'Mean','Variance','Integral'}, ...
        'RowName',{'x','h','y'}, ...
        'FontSize',11, ...
        'Position',[820 yBottom 340 120]);

    % Consistency checks (placed just above table/buttons)
    handles.textChecks = uicontrol('Parent',fig,'Style','text', ...
        'String','', ...
        'FontSize',11, ...
        'HorizontalAlignment','left', ...
        'BackgroundColor', get(fig,'Color'), ...
        'Position',[30 max(yBottom - figHeight*0.10, 60) figWidth-60 60]);

    % Save handles
    handles.x = []; handles.h = []; handles.t = []; handles.dt = [];
    guidata(fig, handles);
end


function onGenerateProbability(fig)
    handles = guidata(fig);

    [t, x_raw, h_raw, ok, msg] = generateSignalsFromControls(handles);
    if ~ok
        set(handles.textStatus, 'String', msg);
        return;
    end

    dt = t(2) - t(1);

    % Enforce non-negativity for PDFs
    x = max(x_raw, 0);
    h = max(h_raw, 0);

    % Integrals
    Ix = sum(x)*dt;
    Ih = sum(h)*dt;

    % Normalize if requested
    if get(handles.chkNormalize, 'Value') == 1
        if Ix > 0
            x = x / Ix;
        end
        if Ih > 0
            h = h / Ih;
        end
    end

    % Convolution (PDF of sum)
    y = conv(x, h) * dt;
    t_y = (t(1)+t(1)) : dt : (t(end)+t(end));

    Iy = sum(y)*dt;

    % Means
    mux = sum(t .* x) * dt;
    muh = sum(t .* h) * dt;
    muy = sum(t_y .* y) * dt;

    % Variances
    varx = sum((t - mux).^2 .* x) * dt;
    varh = sum((t - muh).^2 .* h) * dt;
    vary = sum((t_y - muy).^2 .* y) * dt;

    % Plot PDFs
    cla(handles.axXpdf); cla(handles.axHpdf); cla(handles.axYpdf);
    plot(handles.axXpdf, t, x, 'LineWidth', 2);
    title(handles.axXpdf, sprintf('x(t) PDF, integral=%.3f', Ix));
    grid(handles.axXpdf, 'on');

    plot(handles.axHpdf, t, h, 'r', 'LineWidth', 2);
    title(handles.axHpdf, sprintf('h(t) PDF, integral=%.3f', Ih));
    grid(handles.axHpdf, 'on');

    plot(handles.axYpdf, t_y, y, 'g', 'LineWidth', 2);
    title(handles.axYpdf, sprintf('y(t) PDF, integral=%.3f', Iy));
    grid(handles.axYpdf, 'on');

    % Fill stats table
    statsData = [mux, varx, Ix; ...
                 muh, varh, Ih; ...
                 muy, vary, Iy];
    set(handles.tableStats, 'Data', statsData);

    % Consistency checks
    tol = 1e-2;
    checkMean = abs(muy - (mux + muh)) < tol;
    checkVar  = abs(vary - (varx + varh)) < tol;

    msgMean = sprintf('Check mu_Y ~= mu_X + mu_H: %.3f ~= %.3f  -> %s', ...
                       muy, mux + muh, tf(checkMean));
    msgVar  = sprintf('Check sigma_Y^2 ~= sigma_X^2 + sigma_H^2: %.3f ~= %.3f  -> %s', ...
                       vary, varx + varh, tf(checkVar));
    msgNorm = sprintf('Integrals (Ix, Ih, Iy) = (%.3f, %.3f, %.3f)', Ix, Ih, Iy);

    set(handles.textChecks, 'String', sprintf('%s\n%s\n%s', msgMean, msgVar, msgNorm));
    set(handles.textStatus, 'String', 'Probability mode computation complete.');

    % Save
    handles.t = t;
    handles.x = x;
    handles.h = h;
    handles.dt = dt;
    guidata(fig, handles);
end

function s = tf(boolVal)
    if boolVal
        s = 'OK';
    else
        s = 'NOT OK';
    end
end
