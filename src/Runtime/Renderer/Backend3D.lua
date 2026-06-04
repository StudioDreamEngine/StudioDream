---@diagnostic disable: inject-field
local Backend3D = {}
local DreamAdorns

local Raycast = Dream:getExtension("raytrace")

function Backend3D.Init()
    Dream:init() ---@diagnostic disable-line: missing-parameter

    Dream:setSky(love.graphics.newCubeImage("Assets/sky.png"))
    Dream:setDistortionMargin()

    -- Stores Objects that are not nesscessarily part of the enviornment itself, instead intended to be visible only to the object using them and 3dreamengine
    DreamAdorns = Dream:newObject()
    DreamAdorns.name = "DreamAdorns"
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

function Backend3D.Raycast(Origin, Direction, WorldObject)
    assert(WorldObject, "Internal raycast function requires a WorldObject!")

    local CastResult = Raycast:cast(WorldObject, Origin.ToDream(), Direction.ToDream())

    if CastResult then
        local Object = CastResult:getObject()
        assert(Object.ClassReference, "Raycast returned object with no ClassReference!")

        local ThingClass = Object.ClassReference
        
        -- Env world objects always assume to return thing objects
        if WorldObject.IsEnv then ThingClass = Runtime.Things.Get(ThingClass) end

        ---@class CastResult
        local FriendlyCastResult = {
            Thing = ThingClass,
            Position = CastResult:getPosition(),
            Normal = CastResult:getNormal(),
            UV = CastResult:getUV(),
            Type = "CastResult"
        }

        return FriendlyCastResult
    end
end

-- Object stuff --

function Backend3D.CreateAdorn(Name)
    local Object = Dream:newObject()
    Object.name = Name
    Object.UUID = CreateUUID()

    DreamAdorns.objects[Object.UUID] = Object
    return Object
end

function Backend3D.LoadObject(Identifier, Reference)
    local ResourceIdentifier = Runtime.Resources.GetIdentifier(Identifier)
    local Resource = Runtime.Resources.GetResource(ResourceIdentifier)

    local DreamObject = Dream:loadObjectBytes(Resource.Bytes, Resource.Type)
    AssignClassReference(DreamObject, Reference)

    return DreamObject
end

function Backend3D.LoadAdorn(Identifier, Parent, Reference)
    local DreamObject = Backend3D.LoadObject(Identifier, Reference)

    Parent.objects[CreateUUID()] = DreamObject
    return DreamObject
end

function Backend3D.RemoveAdorn(Object)
    DreamAdorns.objects[Object] = nil
end

return Backend3D