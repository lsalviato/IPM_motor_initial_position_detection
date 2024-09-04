%% Code to calculate the fitting of the obtained data
%  both in the case burst = 0 and burst = 1 
%  (burst should be set only in the Project_parameters script)
%  to be executed after the Simulink simulation

simout = get(out.i_pulse);
i_pulse = simout.Data;
t_pulse = simout.Time;

y = i_pulse(2:(n_pulse+1));  % current pulses [A]
%discard the first sample because it has no meaning
x = t_pulse(1:n_pulse)*(ramp); % electrical angles [electrical radians]
%IMPORTANT: in case of test with method to prevent rotor drift, replace the previous line with:
%x = t_pulse(1:n_pulse)*(ramp-pi);

if not(burst)
    yu = max(y);
    yl = min(y);
    yr = (yu-yl);    % Range of ‘y’
    ym = mean(y);   % Estimate offset
    fit = @(b,x)  b(1)*( sin( x*2 + b(2)) ) + b(3);  % Function to fit
    fcn = @(b) sum((fit(b,x) - y).^2);  % Least-Squares cost function
    s = fminsearch(fcn, [yr;  0;  ym]);   % Minimize Least-Squares
    %s = fminsearch(fcn, [yr;  2;  0;  ym]);
    figure(1);
    t = linspace(0,2*pi,1000);
    plot(180/pi*x,y,'b', 180/pi*t,s(1)*(sin(t*2+s(2)))+s(3),'r');
    title("Fitting result")
    xlabel("angle [deg]")
    ylabel("Current [A]")
    grid on;
    hold on;
    
    %calculation of the point where the derivative of the sine is zero.
    theta_estimated = ( + pi/2 - s(2) )/2 ; %angular position of the rotor with respect to phase A [electrical radians]
    
    % correction of the angle in case the minimum point was found instead
    % of the maximum point
        if ( ( s(1)*sin( theta_estimated*2 + s(2)) ) < 0)
            theta_estimated = theta_estimated + pi/2;
        end
    theta_estimated = theta_estimated*180/pi; % [electrical degrees]
    
    %translation of the solution into a more readable interval
    if ( theta_estimated < 0)
        theta_estimated = theta_estimated + 180;
    elseif ( theta_estimated > 180)
        theta_estimated = theta_estimated - 180;
    end
    
    theta_estimated_mecc = theta_estimated/p % [mechanical degrees]
    % determined up to a factor of k*180/p [deg] k={0,1,..,2*p-1}
    % i.e., ±90 degrees

elseif burst  
    plot(x*180/pi,y);
    hold on;
    [fitresult, gof] = createFit(x, y); %2nd degree polynomial fitting
    [poly] = coeffvalues(fitresult);
    x_max = -poly(2)/2/poly(1); %formula for the maximum point of the parabola
    theta_estimated_burst = phase0 + x_max; % [electrical radians]
    theta_estimated_burst = theta_estimated_burst*180/pi; % [electrical degrees]
    theta_estimated_burst = theta_estimated_burst/p % [mechanical degrees]
end %burst