classdef PathlossCost231
    %PATHLOSSCOST321 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        freq
        bsHeight
        msHeight
        isMetropolitan = 0;
    end
    
    methods
        function obj = PathlossCost231(frequency_MHz, bsHeight_m, msHeight_m, isMetropolitanO)
            if frequency_MHz < 1500 || frequency_MHz > 2000
                error('Frequency is out of range [1500, 2000]');
            end
            obj.freq = frequency_MHz;
            
            if bsHeight_m < 30 || bsHeight_m > 200
                error('bsHeight_m is out of rang [30, 200] meters')
            end
            obj.bsHeight = bsHeight_m;
            
            if msHeight_m < 1 || msHeight_m > 10
                error('bsHeight_m is out of rang [1, 10] meters')
            end
            obj.msHeight = msHeight_m;
            
            if nargin > 3
                obj.isMetropolitan = isMetropolitanO;
            end
        end
        
        function lossDb = getPathloss(obj, distance_km)
            lossDb = PathlossCost231.pathloss(obj.freq, obj.bsHeight, obj.msHeight, obj.isMetropolitan, distance_km);
        end
        
    end
    
    methods(Static)
        function lossDb = pathloss(frequency_MHz, bsHeight_m, msHeight_m, isMetropolitan, distance_km)
            if isMetropolitan
                C = 3;
            else
                C = 0;
            end
            
            a = (1.1*log10(frequency_MHz) - 0.7)*msHeight_m-(1.56*log10(frequency_MHz) - 0.8);
            lossDb = 46.3+33.9*log10(frequency_MHz) - 13.82*log10(bsHeight_m)-a ...
                + (44.9 - 6.55*log10(bsHeight_m))*log10(distance_km) + C;
        end
    end
    
end

