classdef Case < handle
    properties
        name;
        loop
    end
    methods
        function obj = Case(name, loopArray)
            obj.name = name;
            obj.loop = Loop(obj, loopArray);
        end
    end
    methods(Abstract)
        out = evaluate(obj, indices);
        processResults(obj, out);
    end
    methods
        function name = getName(obj)
            name = obj.name;
        end
        function go(obj)
            obj.loop.start();
        end
    end
end