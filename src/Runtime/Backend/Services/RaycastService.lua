-- Maybe make this not an whole service on lauch?

local RaycastService = {}

function RaycastService:Init()

end

function RaycastService:Raycast(Viewport, origin, direction, onlyRaytraceMeshes)
   return Dream.raycast:cast(Viewport, origin, direction, onlyRaytraceMeshes)
end

return RaycastService