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

% MCP9700A sensor constants
% V0C is the output voltage at 0 degrees Celsius
% TC is the temperature coefficient in V/degree Celsius
V0C = 0.500;
TC = 0.010;

% Test one voltage reading from the temperature sensor
testVoltage = readVoltage(a, tempPin);
testTemperature = (testVoltage - V0C) / TC;

fprintf('Task 1a test reading:\n');
fprintf('Voltage = %.3f V\n', testVoltage);
fprintf('Temperature = %.2f C\n\n', testTemperature);



%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]




%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]




%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

