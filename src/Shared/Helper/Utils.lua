local Utils = {}

function Utils.OptionalCall(Module, Function, ...)
    if Module and Module[Function] then
        return Module[Function](...)
    end
end

return Utils