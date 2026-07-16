---@class SpatialService
local SpatialService = {}

function SpatialService.Init()
    
end

function SpatialService.FindObjectsInArea()
    
end

local Raycast = Dream:getExtension("raytrace")

function SpatialService.Raycast(Origin, Direction, WorldObject, IgnoreList)
    assert(WorldObject, "Internal raycast function requires a WorldObject!")

    local ObjIgnoreList = {}
    
    for _, Object in pairs(IgnoreList or {}) do
        if Utils.TypeOf(Object) == "Thing" and Object:IsA("Drawable3D") then
            table.insert(ObjIgnoreList, Object.Drawable)
        end
    end
    
    local CastResult = Raycast:cast(WorldObject, Origin.ToDream(), Direction.ToDream(), ObjIgnoreList)

    if CastResult then
        local Object = CastResult:getObject()
        assert(Object.ClassReference, "Raycast returned object with no ClassReference!")

        local ThingClass = Object.ClassReference
        --print(ThingClass)

        -- Env world objects always assume to return thing objects
        if WorldObject.IsEnv then ThingClass = Runtime.Things.Get(ThingClass) end

        ---@class CastResult
        local FriendlyCastResult = {
            Thing = ThingClass,
            UUID = Object.UUID,
            Position = CastResult:getPosition(),
            Normal = CastResult:getNormal(),
            UV = CastResult:getUV(),
            Type = "CastResult"
        }

        return FriendlyCastResult
    end
end

return SpatialService