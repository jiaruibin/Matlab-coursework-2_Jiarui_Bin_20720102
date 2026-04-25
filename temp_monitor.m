function temp_monitor(a, tempPin, greenPin, yellowPin, redPin, lowerLimit, upperLimit)
%TEMP_MONITOR Monitor temperature and control three LEDs using Arduino.
%   TEMP_MONITOR(a,tempPin,greenPin,yellowPin,redPin) continuously reads
%   the MCP9700A temperature sensor connected to tempPin, plots temperature
%   against time, and controls three LEDs. The green LED is constant when
%   temperature is between 18 and 24 C. The yellow LED blinks every 0.5 s
%   below this range. The red LED blinks every 0.25 s above this range.

% Task 2h -  Function setup
% This function is saved as a separate .m file.
% The Arduino object and pin names are passed from the main coursework file.

lowerLimit = 18; % lower temperature limit in degrees Celsius
upperLimit = 24; % upper temperature limit in degrees Celsius

% Sensor constants
V0C = 0.500;      % Output voltage at 0 C, in volts
TC = 0.010;       % Temperature coefficient, in volts per degree C


% Timing settings

sampleInterval = 1.0;       % seconds between temperature readings
yellowInterval = 0.5;       % yellow LED blink interval in seconds
redInterval = 0.25;         % red LED blink interval in seconds


