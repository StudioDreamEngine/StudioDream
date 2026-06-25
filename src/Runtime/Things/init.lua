-- I dont like the organization of this much...
local Things = {}

-- AllThings doesnt roll off the tounge as well
local Objects = {}
local Classes = {}

Things.API = {}
Things.ClassDump = {} -- Copy of classes for stuff such as IsA

local ObjectsCreated = 0
local CreateRoot

function Things.Init()
    Classes = Utils.LoadModules("Runtime/Things/Classes/")
    CreateRoot = require("Runtime.Things.CreateRoot")

    Things.ObjectProxy = require("Runtime.Things.ObjectProxy")

    Things.Root = CreateRoot.CreateRoot()

    print("Tree Created")
end

function Things.CreateApiDump()
    for Class, _ in pairs(Classes) do
        local ClassObject = Things.Type(Class) ---@class Thing
        --Things.ClassDump[Class] = ClassObject

        ClassObject = ClassObject()
        ClassObject:DefineAPI()
        
        Things.API[Class] = ClassObject.Proxy
    end
end

function Things.CreateEnviornment()
    CreateRoot.CreateEnviornment(Things.Root)
end

function Things.GetRootViewport()
    return Things.GetRoot("ViewportInternal")
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
    assert(Classes[ThingType], "Invalid type ("..ThingType..")")
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
            if Utils.TypeOf(Object[Index]) == "Signal" then
                Object[Index]:Connect(Value)
            else
                Things.SetProperty(Object, Index, Value)
            end
        end

        return Object
    end
end

function Things.New(ThingType, CustomUUID)
    local Thing = Things.Type(ThingType)()
    Thing:new()
    Thing:DefineAPI()

    ObjectsCreated = ObjectsCreated + 1

    assert(Thing.UUID, ThingType.." is not a thing! did you forget to call the superfunctions?")

    Thing.Name = ThingType
    Thing.ClassName = ThingType
    
    Thing.NumericalID = ObjectsCreated

    if CustomUUID then
        Thing.UUID = CustomUUID
    end

    Thing:OnReady()

    local Proxy = setmetatable({
        Proxied = true,
        ProxyMessage = "This object is proxied, thus it's contents will not show up here"
    }, {
        __metatable = getmetatable(Thing),
        __index = Thing,
        __tostring = function (t)
            return Thing.Name..": "..Thing.ClassName.." ("..Thing.UUID..")"
        end,
        __newindex = function (_, k, v)
            --print("__newindex", _, k, v)

            --Profiler.Start("Thing Property Changed")

            if Thing[k] ~= v then
                Thing.PropertyChanged.Invoke(k,v)
            end
            
            --print("Thing "..Thing.Name..", Changed "..k.." To "..tostring(v).." Their old Value is: "..tostring(Thing[k]))

           -- Profiler.End()

            Thing[k] = v
        end
    })

    assert(not Objects[Proxy.UUID], "UUID Collision, This isnt good!!")

    Objects[Proxy.UUID] = Proxy

    return Proxy
end

function Things.Get(UUID)
    return Objects[UUID]
end

function Things.Remove(Thing)
    Thing:OnRemove()
    Objects[Thing.UUID] = nil
end

function Things.UpdatePass(Name, dt)
    Profiler.Start("Update Classes - "..Name)

    for _, Thing in pairs(Objects) do
        --[[
            HACK (i think)
            Fixes issue where things can still update even when not parented,
            Presumably we'd fix this by figuring out what causes that in the first place, 
            but this works too - Bloctans
        ]]
        if Thing.Parent then
            Profiler.Start("Update Class ("..Name..") - "..Thing.ClassName)
            Thing[Name](Thing, dt)
            Profiler.End()
        end
    end

    Profiler.End()
end

function Things.Update(dt)
    Things.UpdatePass("Update", dt)
    Things.UpdatePass("Invalidate", dt)
end

return Things