classdef $CASE_NAME$ < Case

    properties(Constant)
        LOOP_ARRAY = [5 3000];
    end
    
    properties
    end
    
    methods
        function obj = $CASE_NAME$
            obj@Case('$CASE_NAME$', $CASE_NAME$.LOOP_ARRAY);
        end
        
        
        function out = evaluate(obj, indices)
        end
        
        function processResults(obj, out)
        end
    end
    
    methods(Static)
        function start()
            case1 = $CASE_NAME$();
            case1.go();
        end
    end
end