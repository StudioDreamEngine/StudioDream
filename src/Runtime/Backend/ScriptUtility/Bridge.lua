-- Welcome to the sixth layer of metatable hell
-- Black magic brought to you by bloctans :3
local Bridge = {}

local function CheckProxied(Instance)
    if (not Instance.Proxied) then -- Temporary catch
        print("Indexing non-proxied thing")
        print(debug.traceback())
    end
end

local function BridgeCreator(Table, k, v)
    if k == "Type" then return end

    if Utils.TypeOf(Table) == "Thing" then -- Custom creator if the table is a thing
        CheckProxied(Table)

        local ThingProxy = Runtime.Things.Get(Table.UUID) -- Get the ThingProxy in the case the function is using a non-proxied object
        Runtime.Things.SetProperty(ThingProxy, k, v)
    else
        Table[k] = v
    end
end

local function ProxyThing(Instance, Key)
    CheckProxied(Instance)

    if (not Instance[Key]) then -- Assume child
        local Child = Instance:FindFirstChild(Key)

        return Bridge.Proxy(Child)
    else
        return Bridge.Proxy(Instance[Key])
    end
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
    local Type = Utils.TypeOf(Object)

    if Type == "function" then -- Custom proxy for function
        return function(...) return ProxyFunction(Object, ...) end 
    else
        return Object
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