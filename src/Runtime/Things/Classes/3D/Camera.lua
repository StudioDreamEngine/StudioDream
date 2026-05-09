local Things = Runtime.Things

---@class Camera: Base3D
local Camera = Things.Extend("Base3D")

function Camera:new()
    Camera.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "Camera"
    }

    self.FieldOfView = 70 -- FOV
    self.Viewport = nil

    self.Drawable = Dream.camera
end

-- From https://stackoverflow.com/a/23976134
-- Idk man, i gotta understand and use dot products more
function Camera:RayDirectionToPlane(PlaneOrigin, PlaneAxis, RayDirection)
    local RayOrigin = self.Position -- RayOrigin is always assumed to be where the camera is for now

    local Denom = PlaneAxis.Dot(RayDirection)
    local Distance = (PlaneOrigin - RayOrigin).Dot(PlaneAxis) / Denom

    local Final = RayOrigin + Distance * RayDirection
    Final.W = Distance

    return Final
end

function Camera:LocalRayDirectionToPlane(PlaneOrigin, PlaneAxis, RayDirection)
    local Plane = self:RayDirectionToPlane(PlaneOrigin, PlaneAxis, RayDirection)

    return Plane - PlaneOrigin
end

function Camera:GetFocalLength()
    local CamFov = Dream.camera.fov
    return math.tan(CamFov / 2)
end

function Camera:VectorToWorldSpace(vec2) -- Alot of reaserch :sob: i dont want any more math
    local ViewWidth = self.Viewport.AbsoluteSize.X
    local ViewHeight = self.Viewport.AbsoluteSize.Y

    local x = (2 * vec2.X / ViewWidth - 1)
    local y = (1 - 2 * vec2.Y / ViewHeight)

    local ViewAspect = ViewWidth / ViewHeight
    local TanFov = self:GetFocalLength()

    local DirCamera = Vector3.new(x * ViewAspect * TanFov,y * TanFov,-TanFov)
    local m = Dream.camera.transform

    local dirWorld = Vector3.new(
        m[1] * DirCamera.X + m[2] * DirCamera.Y + m[3] * DirCamera.Z,
        m[5] * DirCamera.X + m[6] * DirCamera.Y + m[7] * DirCamera.Z,
        m[9] * DirCamera.X + m[10]* DirCamera.Y + m[11]* DirCamera.Z
    )

    return dirWorld
end

-- TODO: We might be calling this more than once per frame, should we just grab from a variable updated each frame instead?
function Camera:GetMouseRay()
    return self:VectorToWorldSpace(self.Viewport.MousePosition)
end

function Camera:Update(dt)
    local Environment = Things.GetRoot("Environment")

    if (not Environment.Viewport) then
        return
    else
        self.Viewport = Environment.Viewport
    end

    Camera.super.Update(self, dt)
end

return Camera