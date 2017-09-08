clear all;
% M/M/N simulation
% Patrick Miziewicz & Zach Newton

%constants
max_time = 30.0;
avg_call_duration = 12;
trunk_count = 30;
observed_call_count = 50;
number_of_ticks = max_time * 60;
observation_time = 1/60;

%variables
average_lines_in_use = 0.0;
grade_of_service = 0.0;
simulation_time = 60;
all_trunks(1:trunk_count) = false;
call_probability = input('Enter the call probability (0.00 - 1.00): ');
results(1:number_of_ticks) = 0;
dropped_calls(1:number_of_ticks) = 0;
caller = 0;
lost = 0;
count = 0;
number_of_calls = 0;

for i = 1:number_of_ticks
    number_of_calls = 0;
    number_of_callers = 0;
    for z = 1:trunk_count
        if randomGen(call_probability) == true
            number_of_callers = number_of_callers + 1; 
        end
        if all_trunks(z) == true
            number_of_calls = number_of_calls + 1;
        end
    end
    
    for x = 1:trunk_count
        if all_trunks(x) == true
            if isCallEnding(number_of_calls, observation_time, avg_call_duration) == false
                all_trunks(x) = false;
                number_of_calls = number_of_calls - 1;
            end
        end
    end
    
    for ii = 1:trunk_count
        if all_trunks(ii) == false && number_of_callers > 0
            all_trunks(ii) = true;
            number_of_calls = number_of_calls + 1;
            number_of_callers = number_of_callers - 1;
        end
    end
   
    disp('people_in_calls');
    disp(number_of_calls);
    disp('Lost');
    disp(number_of_callers);
    results(i) = number_of_calls;
    dropped_calls(i) = number_of_callers;
end

time(1:number_of_ticks) = 0;
for i = 1:number_of_ticks
   time(i) = i; 
end

plot(time, results, time, dropped_calls),
legend('Trunks Occupied', 'Calls Dropped')
xlabel('Time'), ylabel('Count')
title('Trunks occupied and dropped calls over time');

disp(calcGradeOfService(dropped_calls, results));

%Poission Function
function y = poisson(x,u,T)
u=u*T
    if u < 0 
        y=0
        elseif x < 0
        y=0
    else
        p=((u^x)*exp(-u))/factorial(x);
        y = p;
    end
end



function [C]=ErlangC(A,N)
    % Erlang B calculation
    EB = (A^N/factorial(N))/sum(A^(0:N)/factorial(0:N));
    % Calc C
    EC = (N/(N-A))*B;
    %Outut verification
    if C>1
        C=1
    else
        if C<0
            C=0
        end
    end
end

% get blocked_calls array and results array.
function gos = calcGradeOfService(blocked_calls, offered_calls)
    blocked_calls = sum(blocked_calls);
    offered_calls = sum(offered_calls);
    gos = blocked_calls / (offered_calls + blocked_calls);
end

function isCallWaiting = randomGen(probability)
   r = rand(1, 'double');
   disp(r);
   if probability >= r
       isCallWaiting = true
   else
       isCallWaiting = false
   end
end

%number_of_calls = number of trunks currently in use
%observation_time = the delta time period
%avg_call_duration = observed average call duration
function endCall = isCallEnding(number_of_calls, observation_time, avg_call_duration)
    disp('END CALL NUMBER OF CALLS');
    disp(number_of_calls);
    probability = (number_of_calls * observation_time)/ avg_call_duration;
    disp(probability);
    endCall = randomGen(probability);
end


