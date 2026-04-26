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

-- For now, there might be some shinanigans we can do with like .Cross() but idk
local InverseLookup = {
    [Vector3.xAxis] = {
        "Y",
        "Z"
    },
    [Vector3.yAxis] = {
        "X",
        "Z"
    },
    [Vector3.zAxis] = {
        "Y",
        "X"
    }
}

--[[
    Takes a ray direction and checks where that ray intersects on a 2d plane

    PlaneAxis will be be direction that the plane doesnt extend in, if you want a plane across the x and y, then the PlaneAxis is (0,0,1)
    We could probably do some shitty vector rotation stuff in the future for diagonal planes, but for now, just planes that are aligned to an axis please!

    The idea is simillar to how it'd be done on a 2d plane
    where we use ``y = mx + b`` in order to check at which ``y`` that ``x`` will intersect
    ``x`` in this case will be where the Plane is relative to the RayOrigin

    I'm so thankful I paid attention in math class - Bloctans
]]
function Camera:RayDirectionToPlane(PlaneOrigin, PlaneAxis, RayDirection)
    local RayOrigin = self.Position -- RayOrigin is always assumed to be where the camera is for now
    local LocalPlaneOrigin = (PlaneOrigin - RayOrigin).Abs()
    local PlaneIntersect = (LocalPlaneOrigin * PlaneAxis).Axis()

    --[[
        We will always be ignoring one axis when handling this, so thats nice

        Example Equation (Z Axis):
            Y = Direction.Y * PlaneIntersect
            X = Direction.X * PlaneIntersect
    ]]
    
    local ToPlane = Vector3.zero
    local AxisAxises

    -- Cuz we cant just directly index another vector rn
    for Axises, Value in pairs(InverseLookup) do
        if Axises.Is(PlaneAxis) then
            AxisAxises = Value
        end
    end
    
    --[[
        It works, but now we gotta account more properly for perspective
    ]]

    for _, Axis in pairs(AxisAxises) do
        local Result = Vector3[string.lower(Axis).."Axis"] * (RayDirection[Axis] * PlaneIntersect)

        ToPlane = ToPlane + Result
    end

    return ToPlane/self:GetFocalLength()
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