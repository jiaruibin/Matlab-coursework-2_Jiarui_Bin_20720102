function temp_monitor(a, tempPin, greenPin, yellowPin, redPin, lowerLimit, upperLimit)
%TEMP_MONITOR Monitor temperature and control three LEDs using Arduino.
% TEMP_MONITOR(a,tempPin,greenPin,yellowPin,redPin) continuously reads
% the MCP9700A temperature sensor connected to tempPin, plots temperature
% against time, and controls three LEDs. The green LED is constant when
% temperature is between 18 and 24 C. The yellow LED blinks every 0.5 s
% below this range. The red LED blinks every 0.25 s above this range.

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


% Timing settings

sampleInterval = 1.0;       % seconds between temperature readings
yellowInterval = 0.5;       % yellow LED blink interval in seconds
redInterval = 0.25;         % red LED blink interval in seconds

%Initialise data arrays
timeData = []; % Store time
temperatureData = []; % Store temperature

%Initialize LED state
yellowState = 0;
redState = 0;

% Initialise timing variables
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

% Make sure all LEDs are switched off when the function stops
% Cleanup relating functions are on the bottom of temp_monitor function
cleanupObject = onCleanup(@() switchOffLEDs(a, greenPin, yellowPin, redPin));

% Continuous monitoring while loop
while ishandle(figureHandle)

    elapsedTime = toc(mainTimer);

% Read voltage, convert it to temperature, store the value, and update the graph 

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
        
        % Update the last sample time
        lastSampleTime = elapsedTime;
    end