local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'

local Camera = Things.Extend("Thing")

function Camera:new()
    Camera.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "camera"
    }
end

function Camera:Update(dt)

end

return Camera