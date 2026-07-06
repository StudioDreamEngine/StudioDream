local Bridge = {}

function Bridge.OnError(...)
    print(...)
end

local function CaughtFunction(Value, ...)
    local Success, Result = xpcall(Value, Bridge.OnError, ...)

    if Success then 
        return Bridge.BridgeProxy(Result)
    end
end

local SignalFunctions = { "Connect" }

-- Signal function that is wrapped in a error catcher
local function CaughtSignal(Connect)
    -- Value in this case would be Connect
    return function(_, ActualFunction, Listener)
        local Function = function(...) -- Wrap the connected function in an xpcall
            return CaughtFunction(ActualFunction, ...)
        end

        return Connect(_, Function, Listener) -- We dont need to proxy this
    end
end

local function BridgeIndexer(Table, k)
    local Value = Table[k]
    local Type = Utils.TypeOf(Table)

    if (Type == "Signal") and table.find(SignalFunctions, k) then
        return CaughtSignal(Value)
    elseif (Type == "function") then
        return function(...) 
            return CaughtFunction(Value, ...)
        end
    elseif (k == "Type") then -- Temporary 
        return
    else
        return Bridge.BridgeProxy(Value)
    end
end

function Bridge.Proxy(Table, Script)
    return setmetatable({}, {
        __index = function (_,k)
            BridgeIndexer(Table, k)--, Script)
        end
    })
end

return Bridge