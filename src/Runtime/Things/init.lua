-- I dont like the organization of this much...
local Things = {} ---@class Things

-- AllThings doesnt roll off the tounge as well
local Objects = setmetatable({}, {
    __mode = 'v'
})

local Classes = {}

Things.API = {}
Things.ClassDump = {} -- Copy of classes for stuff such as IsA

Things.TreeChanged = Signal:New("HierachyChanged")

local CreateRoot
local Invalidated = 0

function Things.Init()
    Classes = Utils.LoadModules("Runtime/Things/Classes/")
    CreateRoot = require("Runtime.Things.CreateRoot")

    Things.ObjectProxy = require("Runtime.Things.ObjectProxy")

    printVerbose("Creating root tree")
    Things.Root, Things.RenderRoot = CreateRoot.CreateRoot()
    Things.FireTreeChange = false

    printVerbose("Tree Created")
end

function Things.CreateApiDump()
    for Class, _ in pairs(Classes) do
        local Success, Message = pcall(function()
            local ClassObject = Things.Type(Class) ---@class Thing
            --Things.ClassDump[Class] = ClassObject

            ClassObject = ClassObject()
            ClassObject:DefineAPI()
            
            Things.API[Class] = ClassObject.Proxy
        end)

        if (not Success) then
            error("Failed to create API dump for "..Class..", make sure the class is properly formatted and created")
            print(Message)
        end
    end
end

function Things.CreateEnviornment()
    CreateRoot.CreateEnviornment(Things.Root)
end

function Things.ClearRoot()
    for _, Object in pairs(Things.Root:GetChildren()) do
        if Object.Serializable then
            Things.Remove(Object)
        end
    end
end

function Things.SetDebugObject(Object) Things.DebugObj = Object end
function Things.GetObjects() return Objects end
function Things.RequestTreeChange(From) Things.FireTreeChange = From end

function Things.Type(ThingType) 
    assert(Classes[ThingType], "Invalid type ("..ThingType..")")
    return require(Classes[ThingType])
end

function Things.Extend(SuperType, HyperType)
    local Class = Things.Type(SuperType):extend()
    
    if HyperType then
        return Things.Implement(Class, HyperType)
    else
        return Class
    end
end

-- Copy over the functions from an object into this object
function Things.Implement(Class, Type)
    Class.hyper = {}

    for Name, Function in pairs(Things.Type(Type)) do
        if type(Function) == "function" then
            Class.hyper[Name] = Function
        else
            print("Thing class "..Type.." has non-function value called "..Name..", this will become an error in the future.")
        end
    end
end

function Things.SetProperty(Object, Index, Value)
    local HasSetter = Object["Set"..Index]
    --[[local CopiedValue

    if type(Value) == "table" and Value:Copy then
        CopiedValue = Value:Copy()
    else
        CopiedValue = Value
    end]]

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

function Things.CollectOrphans()
    local ScriptOrphans, Orphans = {}, {}

    for _, Object in pairs(Objects) do
        if (Object.Unreferenced) then
            table.insert(Orphans, Object.OrphanedPath.." ("..Object.ClassName..")")
        elseif (not Object.Parent) then
            table.insert(ScriptOrphans, Object.OrphanedPath.." ("..Object.ClassName..")")
        end
    end

    return ScriptOrphans, Orphans
end

function Things.LogInvalidation()
    Invalidated = Invalidated + 1
end

function Things.New(ThingType, CustomUUID)
    ---@class Thing
    local Thing = Things.Type(ThingType)()
    Thing:new()
    Thing:DefineAPI()

    assert(Thing.UUID, ThingType.." is not a thing! did you forget to call the superfunctions?")

    Thing.Name = ThingType
    Thing.ClassName = ThingType

    if CustomUUID then
        Thing.UUID = CustomUUID
    end

    Thing:OnReady()

    local Proxy = setmetatable({
        Proxied = true,
        ProxyMessage = "This object is proxied, this it's contents will not show up here"
    }, {
        __metatable = getmetatable(Thing),
        __index = Thing,
        __tostring = function (t)
            return Thing.Name..": "..Thing.ClassName.." ("..Thing.UUID..")"
        end,
        __newindex = function (_, k, v)
            if Thing[k] ~= v then
                Thing.PropertyChanged.Invoke(k,v)
            end

            Thing[k] = v
        end
    })

    assert(not Objects[Proxy.UUID], "UUID Collision ("..Proxy.UUID..")! Make sure the CustomUUID isnt colliding with another object in the scene. Otherwise, this isnt good!!")

    Objects[Proxy.UUID] = Proxy

    return Proxy
end

function Things.Get(UUID)
    return Objects[UUID]
end

function Things.Remove(Thing)
    Thing:OnRemove()
end

function Things.GetCount()
    local ScriptOrphans, Orphans = Things.CollectOrphans()

    return {
        Objects = table.length(Objects),
        Invalidated = Invalidated,
        Orphans = "("..#Orphans..") "..table.concat(Orphans, ", "),
        ScriptOrphans = "("..#ScriptOrphans..") "..table.concat(ScriptOrphans, ", "),
    }
end

function Things.UpdatePass(Name, dt, Function)
    Profiler.Start(Name.." Pass")

    for _, Thing in pairs(Objects) do
        --[[
            HACK (i think)
            Fixes issue where things can still update even when not parented,
            Presumably we'd fix this by figuring out what causes that in the first place, 
            but this works too - Bloctans
        ]]
        if Thing.Parent then
            --Profiler.Start("Update Class ("..Name..") - "..Thing.ClassName)

            if Function then
                Function(Thing)
            else
                Thing[Name](Thing, dt)
            end

            --Profiler.End()
        end
    end

    Profiler.End()
end

function Things.Update(dt)
    Invalidated = 0

    Profiler.Start("Things - Update Passes")
    Things.UpdatePass("Update", dt) -- LEAK: Check trello
    Things.UpdatePass("Invalidate", dt)
    Things.UpdatePass("PostUpdate", dt)
    Profiler.End()
    
    if Things.FireTreeChange then
        print("Tree Change: "..Things.FireTreeChange:GetPath())
        Things.TreeChanged.Invoke()
        Things.FireTreeChange = false
    end
end

return Things