local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
---@class Camera: Thing
local Camera = Things.Extend("Thing")

function Camera:new()
    Camera.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "Camera"
    }
    self.Position = Vector3.new(0, 0, 0)
    self.Orientation = Vector3.new(0, 0, 0)

    self.FieldOfView = 70 -- FOV

    self.DreamCamera = Dream.camera
    self.Viewport = nil
end

-- From https://stackoverflow.com/a/23976134
function Camera:RayDirectionToPlane(PlaneOrigin, PlaneAxis, RayDirection)
    local RayOrigin = self.Position -- RayOrigin is always assumed to be where the camera is for now

    local Denom = PlaneAxis.Dot(RayDirection)
    local Value = (PlaneOrigin - RayOrigin).Dot(PlaneAxis) / Denom

    return RayOrigin + Value * RayDirection
end

function Camera:GetFocalLength()
    local CamFov = Dream.camera.fov
    local TanFov = math.tan(CamFov / 2)

    return TanFov
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

function Camera:Update(dt)
    local _Camera = self.DreamCamera

    local keyDown = love.keyboard.isDown
    local mouseDown = love.mouse.isDown

    local speed = 0.2
    local anyDown = false

    if keyDown('w') then
        anyDown = true
        self.Position.X = self.Position.X + math.cos(self.Orientation.Y - math.pi / 2) * speed
        self.Position.Z = self.Position.Z + math.sin(self.Orientation.Y - math.pi / 2) * speed
    end
    if keyDown("s") then
        anyDown = true
		self.Position.X = self.Position.X + math.cos(self.Orientation.Y + math.pi - math.pi / 2) * speed
		self.Position.Z = self.Position.Z + math.sin(self.Orientation.Y + math.pi - math.pi / 2) * speed
	end
	if keyDown("a") then
        anyDown = true
		self.Position.X = self.Position.X + math.cos(self.Orientation.Y - math.pi / 2 - math.pi / 2) * speed
		self.Position.Z = self.Position.Z + math.sin(self.Orientation.Y - math.pi / 2 - math.pi / 2) * speed
	end
	if keyDown("d") then
        anyDown = true
		self.Position.X = self.Position.X + math.cos(self.Orientation.Y + math.pi / 2 - math.pi / 2) * speed
		self.Position.Z = self.Position.Z + math.sin(self.Orientation.Y + math.pi / 2 - math.pi / 2) * speed
	end
    
    _Camera:resetTransform()
    _Camera:translate(self.Position.X, self.Position.Y, self.Position.Z)
    _Camera:rotateX(self.Orientation.X)
    _Camera:rotateY(self.Orientation.Y)
    _Camera:rotateZ(self.Orientation.Z)

    local Environment = Things.GetRoot("Environment")

    local Vector = self:VectorToWorldSpace(Environment.Viewport.MousePosition)

    Things.DebugObj.Position = self:RayDirectionToPlane(Vector3.zero, Vector3.zAxis, Vector)
    --Things.DebugObj2.Position = self.Position + Vector*5
end

return Camera