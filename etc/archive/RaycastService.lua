-- Maybe make this not an whole service on lauch?

local RaycastService = {}

local Raycast = Dream:getExtension("raytrace")

function RaycastService:Init()

end

function RaycastService:Raycast(origin, direction, onlyRaytraceMeshes)
   return Raycast:cast(Runtime.Backend3D.GetWorld(), origin.ToDream(), direction.ToDream(), onlyRaytraceMeshes)
end

return RaycastService