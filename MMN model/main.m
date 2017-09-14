clear all;
% M/M/N Emulation
% Patrick Miziewicz, Zach Newton, Samrat Pant

%constants
max_time = 30.0; %The virtual observed time in minutes
avg_call_duration = 12; % observed average call duration in minutes
trunk_count = 30; % Number of trunks in the system
number_of_ticks = max_time * 60; % Number of computational ticks
observation_time = 1/60; % Inverse of tick multiplier giving our observational period

% variables
all_trunks(1:trunk_count) = Trunk(); % Initialise object array with trunk instances
call_probability = input('Enter the call probability (0.00 - 1.00): '); % take call probability input from user
results(1:number_of_ticks) = 0; % results vector
dropped_calls(1:number_of_ticks) = 0; % dropped calls vector

% main loop. 
for i = 1:number_of_ticks
    number_of_calls = 0; % number of trunks in use
    number_of_callers = 0; % number of people in qeueue
    % loop over all trunks calculating the amount of people to put in the qeueue
    for z = 1:trunk_count 
        if randomGen(call_probability) == true
            number_of_callers = number_of_callers + 1; 
        end
        if all_trunks(z) == true
            number_of_calls = number_of_calls + 1;
        end
    end
    
    % Loop over over all of the trunks calculating whether the trunk is elegible to hang up the user
    for x = 1:trunk_count 
        if all_trunks(x) == true
            if isCallEnding(number_of_calls, observation_time, avg_call_duration) == false
                all_trunks(x).endCall();
                number_of_calls = number_of_calls - 1;
            end
        end
    end
    
    % Loop over all of the trunks calculating whether to put the user into
    % a trunk
    for ii = 1:trunk_count
        if all_trunks(ii).is_in_call ~= true && number_of_callers > 0
            all_trunks(ii).startCall;
            number_of_calls = number_of_calls + 1;
            number_of_callers = number_of_callers - 1;
        end
    end
    
    % setting value according to the number of people in calls at time i
    results(i) = number_of_calls; 
    
    % dropped calls = amount of people still left in qeueue after
    % calculations
    dropped_calls(i) = number_of_callers; 
end

% prefilling time vector
time(1:number_of_ticks) = 0;
for i = 1:number_of_ticks
   time(i) = i; 
end

% plotting data
plot(time, results, time, dropped_calls),
legend('Trunks Occupied', 'Calls Dropped')
xlabel('Time'), ylabel('Count')
title('Trunks occupied and dropped calls over time');

disp(calcGradeOfService(dropped_calls, results));

% Inputs:
% blocked_calls: Integer Vector
% offered_calls: Integer Vector
% Outputs:
% gos: Integer (Grade Of Service)
% This function calculates the grade of servie
function gos = calcGradeOfService(blocked_calls, offered_calls)
    blocked_calls = sum(blocked_calls);
    offered_calls = sum(offered_calls);
    gos = blocked_calls / (offered_calls + blocked_calls);
end

% Inputs:
% probability: Float Point Integer
% Outputs:
% isCallWaiting: Boolean
% This function acts as a random number generator that challenges the
% probability argument
function isCallWaiting = randomGen(probability)
   r = rand(1, 'double');
   disp(r);
   if probability >= r
       isCallWaiting = true
   else
       isCallWaiting = false
   end
end

% Inputs:
% number_of_calls = number of trunks currently in use
% observation_time = the delta time period
% avg_call_duration = observed average call duration
% Outputs:
% endCall: Boolean
% This function determines whether to end a call that is in a trunk using
% the random number generator.
function endCall = isCallEnding(number_of_calls, observation_time, avg_call_duration)
    disp('END CALL NUMBER OF CALLS');
    disp(number_of_calls);
    probability = (number_of_calls * observation_time)/ avg_call_duration;
    disp(probability);
    endCall = randomGen(probability);
end


