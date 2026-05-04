local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Mesh: Drawable3D
local Mesh = Things.Extend("Drawable3D")

function Mesh:new()
    Mesh.super.new(self)

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "MeshPart"
    }

    self.TextureFile = nil -- Maybe make this a table so we can put normals, and that super cool and realist stuff???
    self.Anchored = true

    self:LoadObject()
end

function Mesh:OnRemove()
    Mesh.super.OnRemove(self)
    Runtime.Backend3D.RemoveObject(self)
end

function Mesh:Update(dt)
    Mesh.super.Update(self, dt)
    
    self.Transform.SetPosition(Vector3.new(0, math.sin(GlobalTick * 4) / 2, -5))
end

return Mesh