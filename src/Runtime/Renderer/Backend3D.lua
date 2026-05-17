---@diagnostic disable: inject-field
local Backend3D = {}
local DreamWorld, DreamAdorns

local Raycast = Dream:getExtension("raytrace")

function Backend3D.Init()
    Dream:init() ---@diagnostic disable-line: missing-parameter

    Dream:setSky(love.graphics.newCubeImage("Assets/sky.png"))
    Dream:setDistortionMargin()

    -- Stores the entire world, and the objects the runtime sees
    DreamWorld = Dream:newObject()
    DreamWorld.name = "DreamWorld"

    -- Stores Objects that are not nesscessarily part of the enviornment itself, instead intended to be visible only to the object using them and 3dreamengine
    DreamAdorns = Dream:newObject()
    DreamAdorns.name = "DreamAdorns"
end

function Backend3D.GetWorld() return DreamWorld end
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

    if not Utils.IntersectPoint2D(Runtime.Things.Root.EnvironmentViewport:GetRect(), Runtime.Things.Root.EnvironmentViewport.MousePosition) then return {["NotOnViewport"]=true} end
    
    local CastResult = Raycast:cast(WorldObject, Origin.ToDream(), Direction.ToDream())

    if CastResult then
        local Object = CastResult:getObject()
        assert(Object.ClassReference, "Raycast returned object with no ClassReference!")

        ---@class CastResult
        local FriendlyCastResult = {
            Thing = Object.ClassReference,
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

local function LoadObjectBase(Path, Reference)
    local DreamObject = Dream:loadObject(Path)
    AssignClassReference(DreamObject, Reference)

    return DreamObject
end

function Backend3D.LoadAdorn(Path, Parent, Reference)
    local DreamObject = LoadObjectBase(Path, Reference)

    Parent.objects[CreateUUID()] = DreamObject
    return DreamObject
end

function Backend3D.LoadObject(Path, Object)
    local DreamObject = LoadObjectBase(Path, Object)
    DreamWorld.objects[Object.UUID] = DreamObject

    return DreamObject
end

function Backend3D.RemoveObject(Object)
    if type(Object) == "table" then
        DreamWorld.objects[Object.UUID] = nil
    else -- assume adorn
        DreamAdorns.objects[Object] = nil
    end
end

return Backend3D