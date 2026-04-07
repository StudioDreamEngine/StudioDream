local Main = {}
local ChangedSignals = {}

Globals = {}

CurrentGlobals = {
    "Envorioment",
    "UI",
    "Scripts",
    "Assets"
}

local function FireChanged(WhatChanged,WhereChanged)
    for i,v in pairs(ChangedSignals) do
        v.InvokeEvent(WhatChanged,WhereChanged)
    end
end

function Main.AddGlobal(Name)
    Globals[i] = setmetatable({},{
        __index = function(WhatChanged)
            local Globs = rawget(Globals)

            FireChanged(WhatChanged,"Global") -- change this later to whatever the parent of the table is

            return Globs
        end
    })
end

function Main.AddThingToGlobal(Where,What) -- make this suport trails (aka Example.Example.Example) and aways add as a child
    if Globals[Where] then
        return Globals[Where][What] = {}
    else
        error("Coulnt find "..Where.."" Global."")
    end
end

function Main.NotifyGlobalChange()
    local self = {}
    local ChangeSignal = Signal:New("GlobalChanged")
    local WhatChanged
    local WhereChanged

    function self:Connect(func)
        table.insert(ChangedSignals,ChangeSignal)
    end
    
    return self
end

function Main.GlobalUpdate()
    for i,v in pairs(CurrentGlobals) do
        Main.AddGlobal(i)
    end
end

function Main.Init()
    Main.GlobalUpdate()


end

return Main