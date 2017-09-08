clear all;
% This is the Simulation part of the lab which has the poission traffic 
% 
%Written by Samrat Pant Contributed by Zach and Patrick
%Calculating the total u in the condition P0 and P1
for u = 0.00:0.01:0.99
   P0 = poission (0,u);
   P1 = poission(1,u);
   pTotal = P0+P1;
   %disp(pTotal);
   %plot(u,pTotal);% Hence using  u as 0.15 we can get P0+P1 as 0.99 
end
pA= poission(0,0.15);%using the u achieved we are now calulating the probability
%disp(pA);
pB = poission (1, 0.15);
%disp(pB);


% Now we are using the u =0.1 for better accuracy. 
%Intialize Variables;
Scrb = 1000;%Total Numbers of Subscribers
Pcall = 0.1; % Probabilty of incoming calls
observTime = 0.1/(Scrb*Pcall); % Observation time
holdTime = 12/60;
%Traffic in Erlangs
A= (0.1*holdTime)/observTime;
NumberTrunks = 30;% Number of trunks or resources.
k = input('Enter the number of call in progress: ')% Could be any number from 0 to maximum trunks avilable

StateOfSystem= State(10000,Pcall,Scrb,holdTime,observTime);%calculates and returns the state
%StateOfBusySystem = StateB(10000,Pcall,Scrb,holdTime,observTime,1)
%Below functions to calculate the poission distribution




function PZ = poission(x,u) 
PZ = (u)^x*exp(-(u))/factorial(x);
end
%Below function will calculate the Probabili    ty of Call Ending process
function PE = pEnd(k,observTime,holdTime)
        PE = (k*observTime)/holdTime;
end

 % average arrival rate in the observation time
 function ts = State(N,Pcall,Scrb,holdTime,observTime)
        C = observTime*Scrb*Pcall; %average arrival rate the entered observation time
        k =0; % k is the instantaneous calls in progress
    for j = 0:N
        randNumber = rand(1);
    if randNumber > poission (0,C)% increases the value if the call arrives
        k = k+1;
    else randNumber< pEnd(k,observTime,holdTime)%decreases the value if the call ends
        k = k - 1;
    end
    end
    
 end
 %Code to repesent Congestion
 
    
function [stB] = StateB(N,Pcall,Scrb,holdTime,observTime,Q)
        C = observTime*Scrb*Pcall; %average arrival rate in the observation time.
        Calls = 0;
        Losts = 0;
        k =0; 
    for j = 0:N
    while rand(1)> poission (0,C)
        k = k+1;
        Calls = Calls+1
        while k > Q;
            k = Q;
            Losts = Losts+1;
        end
    if rand(1) < pEnd(k,observTime,holdTime)
        k = k - 1;
    end
    end
    end
    [st] = k;
end

%Erlang B Equation
%for r=0:N
%	esum = ((A ^ r))/ factorial(r);
 %  B = A ^ N / (factorial(N) /esum);
   
%end

