local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
---@class Camera
local Camera = Things.Extend("Thing")

function Camera:new()
    Camera.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "Camera"
    }
    Camera.Position = Vector3.new(0, 0, 0)
    Camera.Orientation = Vector3.new(0, 0, 0)

    Camera.FieldOfView = 70 -- FOV
end

function Camera:Update(dt)
    local _Camera = Dream.camera

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
    _Camera:rotateX(Camera.Orientation.X)
    _Camera:rotateY(Camera.Orientation.Y)
    _Camera:rotateZ(Camera.Orientation.Z)
end

return Camera