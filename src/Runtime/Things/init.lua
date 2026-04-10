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

-- Luawiz create instance code
function Things.Create(Object, Parent)
    Object = (type(Object) == "string" and Things.New(Object) or Object)

    if Parent then
        Object.Parent = Parent
    end

    return function(Properties)
        for Index, Value in pairs(Properties) do
            if Object["Set"..Index] then
                Object["Set"..Index](Object, Value)
            elseif tonumber(Index) then
                Value.Parent = Object
            else
                Object[Index] = Value
            end
        end

        return Object
    end
end

function Things.New(ThingType)
    local Thing = Things.Type(ThingType)()

    assert(Thing, "Invalid type ("..ThingType..")")
    assert(Thing.UUID, ThingType.." is not a thing! did you forget to call the superfunctions?")

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
    Profiler:start("Update Object")

    for _, Thing in pairs(Objects) do
        Thing:Update(dt)
    end

    Profiler:stop()
end

return Things