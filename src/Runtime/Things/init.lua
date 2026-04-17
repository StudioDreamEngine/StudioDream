local Things = {}

-- AllThings doesnt roll off the tounge as well
local Objects = {}
local Classes = {}

function Things.Init()
    local ClassesList = Utils.GetFolderDescendants("Runtime/Things/Classes/", false, true)

    for _, v in pairs(ClassesList) do
        local Path = string.split(v, "%/")
        local Name = Path[#Path]

        Classes[Name] = v
    end

    Things.Root = require("Runtime.Things.CreateRoot")()
end

function Things.Get(UUID)
    return Objects[UUID]
end

function Things.Type(ThingType) return require(Classes[ThingType]) end
function Things.Extend(ThingType) return Things.Type(ThingType):extend() end

function Things.GetRoot(Name)
    return Things.Root[Name]
end

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
    Profiler:start("Update Objects")

    for _, Thing in pairs(Objects) do
        Profiler:start("Update Object - "..Thing.Name)
        Thing:Update(dt)
        Profiler:stop()
    end

    Profiler:stop()
end

return Things