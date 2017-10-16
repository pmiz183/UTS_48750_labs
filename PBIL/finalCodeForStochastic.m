clear all;

%Parameters to change
NumTrials = 100;         %Size of our Epoch
LearningRate = 0.01;     %Smaller takes longer, but better answer
numLoops = 2000;
%End parameters to change

CostTable = xlsread('dataTable.xlsx');  % Import the cost table
%CostTable = CostTable(2:9,2:13);        % Remove row and column numbers.
                                        % Makes it easier to use CostTable
CostTrials = zeros(NumTrials,1);        % A place to store the Costs of each
                                        % trial in an Epoch
PV = ones(1,36)*0.5;                    % Create the first probability Vector
                                        % of 36 Probabilities 
Epoch = zeros(NumTrials,36);            % Initialise an array to store the 
                                        % Epoch
CostBin2Dec = @(CostIndexBin) ...         % This is an anmonyous function tp
                CostIndexBin(1)*4 + ...   % get the decimal value from the 
                CostIndexBin(2)*2 + ...   % 3 binary bits
                CostIndexBin(3);
ConcentratorConnections = zeros(8,1);   %Tmp list of 
%% MainLoop. This loop creates epochs of trials and tests them
% It will continue looping until the result settles down. Let's assume the
% maxium number of loops may be 1000. But we will break out of it long
% before then
for MainLoop = 1:numLoops
    % create an empty epoch. then populate based on the current probability
    % vector
    Epoch = zeros(NumTrials,36);
    CostTrials = zeros(NumTrials,1);
    for EpochLoop = 1:NumTrials
        Epoch(EpochLoop,:) = rand(1,36)<PV;
    end
    % now we have an epoch. lets calculate the cost of each trial. We will
    % re-use the EpochLoop and NumTrials
    for EpochLoop = 1:NumTrials
        ConcentratorConnections = zeros(8,1);
        CostIndexesBin = reshape(Epoch(EpochLoop,:),12,3);
        %Get decimal values to go into the CostTable
        for TerminalNum = 1:12
            CostIndexDec(TerminalNum) = ...
                CostBin2Dec(CostIndexesBin(TerminalNum,:));
            ConcentratorConnections(CostIndexDec(TerminalNum)+1) ...
                = ConcentratorConnections(CostIndexDec(TerminalNum)+1) + 1;
        end
        %work with the CostTable to get the trial cost
        for TerminalNum = 1:12
            Tmp = CostTable(CostIndexDec(TerminalNum)+1,TerminalNum);
            CostTrials(EpochLoop,1) = CostTrials(EpochLoop,1) + Tmp;
        end
        %let's check if this is a legal trial. If not legal set it's cost
        %to 9999
        for ConcentratorNum = 1:8
            if ConcentratorConnections(ConcentratorNum,1)>3
                CostTrials(EpochLoop,1) = 9999;
            end
        end
    end
    % Now let us find the Index of the minimum cost trial. We can the use
    % this to find the 36 bit binary string that corresponds to this
    [MinimumValue,MinIndex] = min(CostTrials);
    CostMinProgressive(MainLoop) = MinimumValue;
    % Test to see if we are finished
    if MainLoop > 20
        if std(CostMinProgressive(1,end-10:end)) == 0
            break
        end
    end
    % Then epochmin is found as follows
    EpochMin = Epoch(MinIndex,:);
    % Write the same code that updates PV
    for j = 1:36
        if EpochMin(j) > 0
            PV(1,j) = PV(1,j) + LearningRate;
            if PV(1,j) > 1
                PV(1,j) = 1;
            end
        else
            PV(1,j) = PV(1,j) - LearningRate;
            if PV(1,j) < 0
                PV(1,j) = 0;
            end
        end
    end
    % time to end this main Loop
end
%% Give Some Results
figure
subplot(2,2,1);
plot(CostMinProgressive);
title('Progressive minimums')

subplot(2,2,2);
pie(ConcentratorConnections');
title('Connections per Concentrator')

subplot(2,2,3);
bar(CostIndexDec);
title('Connections Selected Per Terminal')

subplot(2,2,4);
plot(CostMinProgressive(1,end-10:end));
titletxt = strcat('Final value:', num2str(CostMinProgressive(1,end)));
title(titletxt);
            
    


