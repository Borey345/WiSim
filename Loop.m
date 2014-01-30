classdef Loop < handle
    properties
        loopCase
        loopsArray
        out
    end
    
    methods
        function obj = Loop(loopCase, loopsArray)
            obj.loopCase = loopCase;
            obj.loopsArray = loopsArray;
            obj.out = zeros(loopsArray);
        end
        function out = start(obj)
            obj.doStart(obj.loopCase, [], obj.loopsArray)
            out = obj.out;
        end
        
        function doStart(obj, loopCase, currIndices, remainingLoopArray)
            if isempty(remainingLoopArray)
                try
                    obj.out(currIndices) = loopCase.evaluate(currIndices);
                    return
                catch err
                    currIndices
                    err.rethrow();
                end
            end
            for i=1:remainingLoopArray(1)
                obj.doStart(loopCase, [currIndices i], remainingLoopArra(2:end));
            end
        end
    end
end