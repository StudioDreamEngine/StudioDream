local Things = {}

-- AllThings doesnt roll off the tounge as well
local Objects = {}

function Things.Init()
    Things.Root = require("Runtime.Things.CreateRoot")()
end

function Things.Get(UUID)
    return Objects[UUID]
end

function Things.Type(ThingType) return require("Runtime.Things.Classes."..ThingType) end
function Things.Extend(ThingType) return Things.Type(ThingType):extend() end

function Things.New(ThingType, ...)
    local Thing = Things.Type(ThingType)(...)

    Thing.__tostring = function(self) return "<"..ThingType..">"..self.Name end

    Thing.Name = ThingType

    Objects[Thing.UUID] = Thing

    return Thing
end

function Things.Remove(Thing)
    local UUID = Thing.UUID
    Objects[UUID] = nil
end

function Things.Update(dt)
    for _, Thing in pairs(Objects) do
        Thing:Update(dt)
    end
end

return Things