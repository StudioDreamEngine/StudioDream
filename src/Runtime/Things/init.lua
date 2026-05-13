-- I dont like the organization of this much...
local Things = {}

-- AllThings doesnt roll off the tounge as well
local Objects = {}
local Classes = {}

local ObjectsCreated = 0

function Things.Init()
    Classes = Utils.LoadModules("Runtime/Things/Classes/")

    Things.Root = require("Runtime.Things.CreateRoot")()

    print("Tree Created")

    require("Runtime.Things.CreateTests")()
end


function Things.GetRoot(Object)
    assert(Things.Root, "Tree hasnt been created yet! are you trying to access it before creation?")

    return Things.Root:FindFirstChild(Object)
end

function Things.ClearRoot()
    for _, Object in pairs(Things.Root:GetChildren()) do
        if Object.Serializable then
            Things.Remove(Object)
        end
    end
end

function Things.SetDebugObject(Object) Things.DebugObj = Object end



function Things.Type(ThingType) 
    assert(Classes[ThingType], "Thing Class "..ThingType.." doesnt exist!")
    return require(Classes[ThingType]) 
end

function Things.Extend(ThingType) return Things.Type(ThingType):extend() end




function Things.SetProperty(Object, Index, Value)
    local HasSetter = Object["Set"..Index]

    if HasSetter then
        HasSetter(Object, Value)
    else
        Object[Index] = Value
    end
end

-- Luawiz create instance code
function Things.Create(Object, UUID)
    Object = (type(Object) == "string" and Things.New(Object, UUID) or Object)

    return function(Properties)
        for Index, Value in pairs(Properties) do
            if tonumber(Index) then
                Value.Parent = Object
            else
                Things.SetProperty(Object, Index, Value)
            end
        end

        return Object
    end
end

function Things.New(ThingType, CustomUUID)
    local Thing = Things.Type(ThingType)()

    ObjectsCreated = ObjectsCreated + 1

    assert(Thing, "Invalid type ("..ThingType..")")
    assert(Thing.UUID, ThingType.." is not a thing! did you forget to call the superfunctions?")

    Thing.__tostring = function(self) return "<"..ThingType..">"..self.Name end

    Thing.Name = ThingType
    Thing.ClassName = ThingType
    
    Thing.NumericalID = ObjectsCreated

    if CustomUUID then
        Thing.UUID = CustomUUID
    end

    Objects[Thing.UUID] = Thing

    return Thing
end

function Things.Get(UUID)
    return Objects[UUID]
end

function Things.Remove(Thing)
    Thing:OnRemove()
    Objects[Thing.UUID] = nil
end

function Things.Update(dt)
    Profiler.Start("Update Things")

    for _, Thing in pairs(Objects) do
        --[[
            HACK (i think)
            Fixes issue where things can still update even when not parented,
            Presumably we'd fix this by figuring out what causes that in the first place, 
            but this works too - Bloctans
        ]]
        if Thing.Parent then
            Profiler.Start("Update Class - "..Thing.Name)
            Thing:Update(dt)
            Profiler.End()
        end
    end

    Profiler.End()
end

return Things