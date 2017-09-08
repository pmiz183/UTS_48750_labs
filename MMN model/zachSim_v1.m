

call_probability = input('Enter the probability of a call: ');
subscribers = 1000;
holding_time = 12/60;
current_calls_in_progress = input('Enter the number of call in progress: ');
trunks = 30;
GoS = 0;

arrival_rate = t_obs(subscribers, call_probability) * subscribers * call_probability;
calls = 0;
lost = 0;
k = 0;

for j = 0:trunks
    while rand(1) > poisson(0,arrival_rate)
        calls = calls +1;
        k = k +1;
        while k > trunks
            k = trunks;
            lost = lost +1;
        end
    end
    if rand(1) < p_ending(k, t_obs(subscribers, call_probability), holding_time)
        k = k-1;
    end
end
GoS = lost/calls;
disp("GoS");
disp(GoS);
    




%Poission Function
function y = poisson(x,u)
    if u < 0 
        y=0
        elseif x < 0
        y=0
    else
        p=((u^x)*exp(-u))/factorial(x);
        y = p;
    end
end

%Poission Function
function obs = t_obs(subscribers, call_probability)
    obs = 0.1/subscribers * call_probability;
end

%Probability of a call endin
function p_end = p_ending(current_calls_in_progress, t_obs,holding_time)
    p_end = (current_calls_in_progress * t_obs)/holding_time;
end

