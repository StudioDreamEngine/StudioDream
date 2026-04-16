local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'

local Mesh = Things.Extend("Thing")

function Mesh:new()
    Mesh.super.new(self)

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "MeshPart"
    }
    self.MeshFile = nil
    self.Anchored = true

    self.Drawable = Dream:loadObject(self.MeshFile or "Assets/Scripty")
end

function Mesh:Update(dt)
    local Drawable = self.Drawable

    Drawable:resetTransform()
    Drawable:translate(0,math.sin(GlobalTick*4)/2,-5)
    Drawable:rotateY(GlobalTick*2)
end

return Mesh