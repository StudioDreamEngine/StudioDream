-- Just realized how useless this is, 
local Bridge = {}

local function ProxyThing(Instance, Key)
    if (not Instance[Key]) then
        -- Assume child
        local Child = Instance:FindFirstChild(Key)

        return Bridge.Proxy(Child)
    else
        return Bridge.Proxy(Instance[Key])
    end
end

local function BridgeCreator(Table, k, v)
    if k == "Type" then return end

    print(k,v)
    Table[k] = v
end

local function ProxyFunction(OldFunction, ...)
    local Result = OldFunction(...)
    local NewResult

    if Utils.TypeOf(Result) == "table" then
        for _, v in pairs(Result) do
            table.insert(NewResult, Bridge.Proxy(v))
        end
    else
        NewResult = Bridge.Proxy(Result)
    end

    return NewResult
end

local function ProxyObject(Object)
    local Type = type(Object)

    if Type == "function" then -- Custom proxy for function
        return function(...) ProxyFunction(Object, ...) end 
    else -- Otherwise, return as proxy
        return Bridge.Proxy(Object)
    end
end

function BridgeIndexer(Table, k)
    if Utils.TypeOf(Table) == "Thing" then -- Custom proxy if the table is a thing
        return ProxyThing(Table, k)
    else -- Otherwise, return regular proxied object
        return ProxyObject(Table[k])
    end
end

function Bridge.Proxy(Table, Script)
    if type(Table) == "table" then
        return setmetatable({}, {
            __index = function (_,k)
                return BridgeIndexer(Table, k)
            end,
            __newindex = function (_, k, v)
                BridgeCreator(Table, k, v)
            end
        })
    else
        return Table
    end
end

return Bridge