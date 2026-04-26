function temp_monitor(a, tempPin, greenPin, yellowPin, redPin, lowerLimit, upperLimit)
%TEMP_MONITOR monitor temperature and control three LEDs using Arduino.
% The function continuously readsthe MCP9700A temperature sensor connected 
% to tempPin, plots temperatureagainst time, and controls three LEDs. 
% The green LED is constant whentemperature is between 18 and 24 C. 
% The yellow LED blinks every 0.5 sbelow this range. The red LED blinks 
% every 0.25 s above this range.I write some codes to make the graph more 
% readableandset an extra function that it can close the live plot window 
% to stop monitoring.

% This function is saved as a separate .m file.
% The Arduino object and pin names are passed from the main coursework file.

% Set default temperature limits if they are not provided
if nargin < 6 
    lowerLimit = 18; % Default lowerlimit
end

if nargin < 7 
    upperLimit = 24; % Default upperlimit
end

% Sensor constants
V0C = 0.500;      % Output voltage at 0 C, in volts
TC = 0.010;       % Temperature coefficient, in volts per degree C
sampleInterval = 1.0;       % seconds between temperature readings
yellowInterval = 0.5;       % yellow LED blink interval in seconds
redInterval = 0.25;         % red LED blink interval in seconds
timeData = []; % Store time
temperatureData = []; % Store temperature
yellowState = 0; % Initial state of yellow LED
redState = 0; % Initial state of red LED
 
mainTimer = tic; % Start the timer
lastSampleTime = -sampleInterval; % Force the first temperature sample to occur immediately
lastYellowToggle = 0;  % Yellow LED blinking timer, 0.5 s interval
lastRedToggle = 0; % Red LED blinking timer, 0.25 s interval
currentTemperature = NaN; % No temperature has been measured before the first sensor reading.

% Create live temperature plot

figureHandle = figure;
plotHandle = plot(NaN, NaN, '-o');
xlabel('Time / s');
ylabel('Temperature / C');
title('Live Capsule Temperature Monitoring');
grid on;

% To make sure all LEDs are switched off when the function stops,
% I use cleanup command which can still work though the program stops.
% Relating functions are on the bottom of temp_monitor function
cleanupObject = onCleanup(@() switchOffLEDs(a, greenPin, yellowPin, redPin));

while true % Continuous monitoring while loop

    elapsedTime = toc(mainTimer); % Record time

    if elapsedTime - lastSampleTime >= sampleInterval

        % Read voltage from Arduino analogue pin
        sensorVoltage = readVoltage(a, tempPin);

        % Convert sensor voltage to temperature
        currentTemperature = (sensorVoltage - V0C) / TC;

        % Store time and temperature data
        timeData(end + 1) = elapsedTime;
        temperatureData(end + 1) = currentTemperature;

        % Print current reading to command window
        fprintf('Time %.1f s | Temperature %.2f C\n', ...
            elapsedTime, currentTemperature);

        % Update live graph data
        set(plotHandle, 'XData', timeData, 'YData', temperatureData);

        % Keep x-axis readable as time increases
        if elapsedTime < 60
            xlim([0 60]);
        else
            xlim([elapsedTime - 60, elapsedTime]);
        end

        % Keep y-axis appropriate for the measured temperature values
        minY = min(temperatureData) - 2;
        maxY = max(temperatureData) + 2;

        if minY == maxY
            minY = currentTemperature - 5;
            maxY = currentTemperature + 5;
        end

        ylim([min(15, minY), max(30, maxY)]);

        drawnow; % Refresh graph

        lastSampleTime = elapsedTime; % Update the last sample time
    end

    % The loop should achieve below temperature control logic:
    % Green LED: constant ON when temperature is between 18 C and 24 C.
    % Yellow LED: blinks every 0.5 s when temperature is below 18 C.
    % Red LED: blinks every 0.25 s when temperature is above 24 C.

    if ~isnan(currentTemperature) % judge if data is reasonable
        % Case 1: temperature is within comfort range
        if (currentTemperature >= lowerLimit) && (currentTemperature <= upperLimit)
            writeDigitalPin(a, greenPin, 1);
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, redPin, 0);
            yellowState = 0;
            redState = 0;
% Case 2: temperature is below comfort range
        elseif currentTemperature < lowerLimit

            writeDigitalPin(a, greenPin, 0);
            writeDigitalPin(a, redPin, 0);
            redState = 0;
            % Toggle yellow LED every 0.5 s
            if elapsedTime - lastYellowToggle >= yellowInterval
                yellowState = 1 - yellowState;
                writeDigitalPin(a, yellowPin, yellowState);
                lastYellowToggle = elapsedTime;
            end
        % Case 3: temperature is above comfort range
        elseif currentTemperature > upperLimit
            writeDigitalPin(a, greenPin, 0);
            writeDigitalPin(a, yellowPin, 0);
            yellowState = 0;
            % Toggle red LED every 0.25 s
            if elapsedTime - lastRedToggle >= redInterval
                redState = 1 - redState;
                writeDigitalPin(a, redPin, redState);
                lastRedToggle = elapsedTime;
            end
        end
    end
    pause(0.02);  % Short pause for overall timing control
end
disp('Temperature monitoring stopped.');
end % End of the function

% Define the above function which should be needed for clean up command
function switchOffLEDs(a, greenPin, yellowPin, redPin)
writeDigitalPin(a, greenPin, 0);
writeDigitalPin(a, yellowPin, 0);
writeDigitalPin(a, redPin, 0);
end