classdef Loop < handle
    properties
        loopCase
        loopsArray
        out
        progress
        allProgress
        progressBar
    end
    
    methods
        function obj = Loop(loopCase, loopsArray)
            obj.loopCase = loopCase;
            obj.loopsArray = loopsArray;
            obj.out = zeros(loopsArray);
            obj.progressBar = waitbar(0, loopCase.getName());
            obj.allProgress = prod(obj.loopsArray);
            obj.progress = 0;
        end
        function out = start(obj)
            obj.doStart(obj.loopCase, [], obj.loopsArray)
            out = obj.out;
            close(obj.progressBar);
            obj.loopCase.processResults(out);
        end
        
        function doStart(obj, loopCase, currIndices, remainingLoopArray)
            if isempty(remainingLoopArray)
                try
                    cellIndices = num2cell(currIndices);
                    obj.out(cellIndices{:}) = loopCase.evaluate(currIndices);
                    obj.progress = obj.progress + 1;
                    waitbar( obj.progress/obj.allProgress, obj.progressBar);
                    return
                catch err
                    currIndices
                    err.rethrow();
                end
            end
            for i=1:remainingLoopArray(1)
                obj.doStart(loopCase, [currIndices i], remainingLoopArray(2:end));
            end
        end
        
%         function progress = evaluateProgress(obj, currIndices)
%             progress = 0;
%             for i=1:length(currIndices)
%                 progress = progress + currIndices(i)*prod(obj.loopsArray(i+1:end));
%             end
%             progress
%         end
    end
    
end