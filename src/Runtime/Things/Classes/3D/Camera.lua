local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
---@class Camera
local Camera = Things.Extend("Thing")

function Camera:new()
    Camera.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "camera"
    }
    Camera.Position = Vector3.new(0, 0, 0)
    Camera.Orientation = Vector3.new(0, 0, 0)

    Camera.FieldOfView = 70 -- FOV
end

function Camera:Update(dt)
    local _Camera = Dream.Camera
    
    _Camera:resetTransform()
    _Camera:translate(self.Position.X, self.Position.Y, self.Position.Z)
    _Camera:rotateX(Camera.Orientation.X)
    _Camera:rotateY(Camera.Orientation.Y)
    _Camera:rotateZ(Camera.Orientation.Z)
end

return Camera