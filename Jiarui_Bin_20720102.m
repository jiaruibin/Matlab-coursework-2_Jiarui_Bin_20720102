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
tempPin = 'A0'; % Analogue pin connected to the output pin of the MCP9700A sensor
location = 'Nottingham';
V0C = 0.500; % V0C is the output voltage at 0 degrees Celsius
TC = 0.010; % V0C is the output voltage at 0 degrees Celsius

testVoltage = readVoltage(a, tempPin); % Test one voltage reading 
testTemperature = (testVoltage - V0C) / TC;

fprintf('Task 1a test reading:\n');
fprintf('Voltage = %.3f V\n', testVoltage);
fprintf('Temperature = %.2f C\n\n', testTemperature);

% (b) Acquire temperature data for 600 seconds
duration = 600; % Total acquisition time in seconds
sampleInterval = 1; % Sampling interval in seconds
% Number of samples, including time = 0 s and time = 600 s
numSamples = floor(duration / sampleInterval) + 1;
timeData = zeros(numSamples, 1); % store time
voltageData = zeros(numSamples, 1); % store reading voltage
temperatureData = zeros(numSamples, 1); % store temperature

startTimer = tic; % start the timer

for k = 1:numSamples
    targetTime = (k - 1) * sampleInterval; % Target time for this sample
    % Wait until the target sampling time is reached
    while toc(startTimer) < targetTime
        pause(0.01);
    end
    timeData(k) = toc(startTimer); % Record the actual elapsed time
    voltageData(k) = readVoltage(a, tempPin); % read voltage
    temperatureData(k) = (voltageData(k) - V0C) / TC; % convert voltage to temperature

    if mod(k - 1, 60) == 0  % Print progress every 60 seconds
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

% (d) - Format output 
% Extract temperatures at Minute 0, 1, 2, ..., 10
minuteTimes = 0:60:duration;
minuteTemps = interp1(timeData, temperatureData, minuteTimes, 'linear', 'extrap');
date = datestr(now, 'dd/mm/yyyy'); % Date of data logging
% Build formatted text using sprintf
screenText = sprintf('Data logging initiated - %s\n', date);
screenText = [screenText, sprintf('Location - %s\n\n', location)];

for m = 0:10
    screenText = [screenText, sprintf('Minute %d\n', m)];
    screenText = [screenText, sprintf('\tTemperature %.2f C\n\n', minuteTemps(m + 1))];
end

screenText = [screenText, sprintf('Max temp %.2f C\n', maxTemp)];
screenText = [screenText, sprintf('Min temp %.2f C\n', minTemp)];
screenText = [screenText, sprintf('Average temp %.2f C\n\n', avgTemp)];
screenText = [screenText, sprintf('Data logging terminated\n')]; %final output result

fprintf('%s', screenText); % Print formatted output to the command window

% (e) - Write the same data to a text log file
fileName = 'capsule_temperature.txt'; % Open file with writing permission
fileID = fopen(fileName, 'w');

% Check that the file opened correctly
if fileID == -1
    error('Could not open capsule_temperature.txt for writing.');
end

fprintf(fileID, '%s', screenText); % Write formatted text to file
fclose(fileID); % close file

% Open the file again to check it has been written correctly
fileID = fopen(fileName, 'r');

if fileID == -1
    error('Could not open capsule_temperature.txt for reading.');
end

% Close the file and print the result on the command window
fileContent = fread(fileID, '*char')';
fclose(fileID);
fprintf('\nContents read back from capsule_temperature.txt:\n\n');
fprintf('%s\n', fileContent);




%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% (f)Three LED hardware pin configuration
% Three LEDs are connected to three separate Arduino digital pins.
% The LED long legs are connected to digital pins.
% The LED short legs are connected to ground through 220 ohm resistors.

% Digital pins connected to the LED long legs
greenPin = 'D8';
yellowPin = 'D9';
redPin = 'D10';
% Make sure all LEDs are initially switched off
writeDigitalPin(a, greenPin, 0);
writeDigitalPin(a, yellowPin, 0);
writeDigitalPin(a, redPin, 0);

% Call the temperature monitoring function
% Tip: I set a command in temp_monitor that which can stop if 
% figure window is closed.
temp_monitor(a, tempPin, greenPin, yellowPin, redPin,18,24);



%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Reset the state of LEDs
writeDigitalPin(a, greenPin, 0);
writeDigitalPin(a, yellowPin, 0);
writeDigitalPin(a, redPin, 0);

% Call the temperature prediction function
temp_prediction(a, tempPin, greenPin, yellowPin, redPin);



%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

