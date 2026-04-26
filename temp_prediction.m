function temp_prediction(a, tempPin, greenPin, yellowPin, redPin)
%TEMP_PREDICTION Predict capsule temperature using Arduino data.
% This function continuously reads the MCP9700A temperature sensor,
% calculates the temperature change rate in C/s, predicts the temperature
% after 5 minutes, prints the results, and controls LEDs. The red LED
% indicates heating faster than 4 C/min, the yellow LED indicates cooling
% faster than 4 C/min, and the green LED indicates stable temperature
% within the comfort range.

lowerLimit = 18;        % Set the lowerlimit in deg C
upperLimit = 24;        % Set the upper limit deg C
sampleInterval = 1;     % seconds
predictionTime = 300;   % 5 minutes = 300 seconds
rateLimitMin = 4;               % deg C/min
rateLimitSec = rateLimitMin/60; % deg C/s
Samples = 10; % Number of recent samples used to estimate the rate
timeData = []; % array stores time data
tempData = []; % array stores temperature data

startTime = tic; % Start the timer
disp('Task 3 temperature prediction started.');
while true

    currentTime = toc(startTime); % Record time

    voltage = readVoltage(a, tempPin);
    currentTemp = (voltage - V0C) / TC;

    timeData(end + 1) = currentTime; % Refresh current time
    tempData(end + 1) = currentTemp; % Refresh current temperature

    if length(tempData) >= 2 % At least two points are needed to caculate

        % Use the most recent Samples point to reduce noise effect
        firstIndex = max(1, length(tempData) - Samples + 1);

        deltaTemp = tempData(end) - tempData(firstIndex);
        deltaTime = timeData(end) - timeData(firstIndex);

        rateSec = deltaTemp / deltaTime;

    else

        rateSec = 0;  % The case that not enough data to calculate a rate yet

    end





