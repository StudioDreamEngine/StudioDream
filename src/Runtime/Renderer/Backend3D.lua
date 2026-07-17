---@diagnostic disable: inject-field
local Backend3D = {}
local DreamAdorns

function Backend3D.Init()
    -- Stores Objects that are not nesscessarily part of the enviornment itself, instead intended to be visible only to the object using them and 3dreamengine
    DreamAdorns = Dream:newObject()
    DreamAdorns.name = "DreamAdorns"
end

function Backend3D.SetupDebug()
    Backend3D.Debug = Dream.cubeObject:clone()
    Backend3D.SetTransform(Transform3D.FromPosition(0,-200,0))
end

function Backend3D.SetTransform(Transform)
    Backend3D.Debug:resetTransform()
    Backend3D.Debug:setTransform(Transform.GetMatrix())
end

---@return DreamObject
function Backend3D.CreateWorld()
    local DreamWorld = Dream:newObject()
    DreamWorld.name = "DreamWorld"

    return DreamWorld
end

function Backend3D.GetAdorns() return DreamAdorns end

--- Assign all DreamObjects the ClassReference object, instead of merging the object into one single mesh
--- @param Object DreamObject
--- @param ClassReference Drawable3D
local function AssignClassReference(Object, ClassReference)
    Object.ClassReference = ClassReference

    for _, ChildObject in pairs(Object.objects) do
        AssignClassReference(ChildObject, ClassReference)
    end
end

-- Object stuff --

function Backend3D.RegisterObject(Object, UUID)
    DreamAdorns.objects[UUID] = Object
end

function Backend3D.UnregisterObject(UUID)
    DreamAdorns.objects[UUID] = nil
end

function Backend3D.CreateAdorn(Name)
    local Object = Dream:newObject()
    Object.name = Name
    Object.UUID = CreateUUID()

    DreamAdorns.objects[Object.UUID] = Object
    return Object
end

function Backend3D.LoadObject(Identifier, Reference)
    local Resource, ResourceIdentifier = Runtime.Resources.LoadResourceFromIdentifier(Identifier, Reference)
    if (not Resource) then return end

    local DreamObject = Dream:loadObjectBytes(Resource.Bytes, Resource.Type)
    AssignClassReference(DreamObject, Reference)

    return DreamObject, ResourceIdentifier
end

function Backend3D.LoadAdorn(Identifier, Parent, Reference)
    local DreamObject = Backend3D.LoadObject(Identifier, Reference)
    local UUID = CreateUUID()

    DreamObject.UUID = UUID

    Parent.objects[UUID] = DreamObject
    return DreamObject
end

function Backend3D.RemoveAdorn(Object)
    DreamAdorns.objects[Object] = nil
end

return Backend3D