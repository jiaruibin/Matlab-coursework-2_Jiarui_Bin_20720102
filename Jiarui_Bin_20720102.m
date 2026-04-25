% Jiarui Bin
% ssyjb3@nottingham.edu.cn
clear;
clc;

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]
% Create Arduino object
a = arduino('COM4', 'Uno');

% Select the digital pin connected to the long leg of the LED
ledPin = 'D8';

% Switch LED ON
writeDigitalPin(a, ledPin, 1);
pause(1)

% Switch LED OFF
writeDigitalPin(a, ledPin, 0);
pause(1)
% Number of blinking cycles
numBlinks = 10;

% Blink the LED at 0.5 s intervals
for i = 1:numBlinks

    % Switch LED ON
    writeDigitalPin(a, ledPin, 1);
    pause(0.5);

    % Switch LED OFF
    writeDigitalPin(a, ledPin, 0);
    pause(0.5);

end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% (a) Arduino and thermistor setup

% Analogue pin connected to the output pin of the MCP9700A sensor
tempPin = 'A0';

% Location used in the formatted output
location = 'Nottingham';

% V0C is the output voltage at 0 degrees Celsius
V0C = 0.500;
% TC is the temperature coefficient in V/degree Celsius
TC = 0.010;

% Test one voltage reading from the temperature sensor
testVoltage = readVoltage(a, tempPin);
testTemperature = (testVoltage - V0C) / TC;

fprintf('Task 1a test reading:\n');
fprintf('Voltage = %.3f V\n', testVoltage);
fprintf('Temperature = %.2f C\n\n', testTemperature);

% (b) Acquire temperature data for 600 seconds

% Total acquisition time in seconds
duration = 600;

% Sampling interval in seconds
sampleInterval = 1;

% Number of samples, including time = 0 s and time = 600 s
numSamples = floor(duration / sampleInterval) + 1;

% Pre-allocate arrays for time, voltage and temperature
timeData = zeros(numSamples, 1);
voltageData = zeros(numSamples, 1);
temperatureData = zeros(numSamples, 1);

% Start timing
startTimer = tic;

for k = 1:numSamples

    % Target time for this sample
    targetTime = (k - 1) * sampleInterval;

    % Wait until the target sampling time is reached
    while toc(startTimer) < targetTime
        pause(0.01);
    end

    % Record the actual elapsed time
    timeData(k) = toc(startTimer);

    % Read voltage from the temperature sensor
    voltageData(k) = readVoltage(a, tempPin);

    % Convert voltage to temperature using MCP9700A equation
    temperatureData(k) = (voltageData(k) - V0C) / TC;

    % Print progress every 60 seconds
    if mod(k - 1, 60) == 0
        fprintf('Acquired data at %.0f s: %.2f C\n', ...
            timeData(k), temperatureData(k));
    end
end

% Max temperature
maxTemp = max(temperatureData);
% Min temperature
minTemp = min(temperatureData);
% Average temperature
avgTemp = mean(temperatureData);

% (c) - Plot temperature against time figure

figure;
plot(timeData, temperatureData, '-o');
xlabel('Time / s');
ylabel('Temperature / C');
title('Capsule Temperature Data');
grid on;



%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]




%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]




%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

