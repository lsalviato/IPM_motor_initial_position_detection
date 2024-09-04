function [fitresult, gof] = createFit(x, y)
%% Fit: 'fit 1'. Matlab fitting function
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'poly2' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', 'fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on