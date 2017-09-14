classdef Trunk
    %Trunk class
    %   Used to generate track trunk data
    
    properties
        is_in_call; % 
    end
    
    methods
        % Trunk constructor
        % returns a Trunk object
        function obj = Trunk()
                obj.is_in_call = false;
        end
        
        % Start call function
        function obj = startCall(obj)
            obj.is_in_call = true;
        end
        
        % End call function
        function obj = endCall(obj)
            obj.is_in_call = false;
        end
    end
    
end

