---@class SpatialService
local SpatialService = {}

function SpatialService.Init() end

---@param World Environment
---@param AreaRect Rect
function SpatialService.FindObjectsInArea(AreaRect, World)
	local InArea = {}

	---@param Object Drawable3D
	for _, Object in pairs(World.Objects) do
		assert(Object:IsA("Drawable3D"), "Object was not a Drawable3D, this should not be possible")

		if Object:CheckAABB(AreaRect.Min, AreaRect.Max) then
			table.insert(InArea, Object)
		end
	end

	return InArea
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
		if WorldObject.IsEnv then
			ThingClass = Runtime.Things.Get(ThingClass)
		end

		---@class CastResult
		local FriendlyCastResult = {
			Thing = ThingClass,
			UUID = Object.UUID,
			Position = CastResult:getPosition(),
			Normal = CastResult:getNormal(),
			UV = CastResult:getUV(),
			Type = "CastResult",
		}

		return FriendlyCastResult
	end
end

return SpatialService
