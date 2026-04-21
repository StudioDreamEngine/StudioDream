local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Base3D'
---@class Mesh
local Mesh = Things.Extend("Base3D")

function Mesh:new()
    Mesh.super.new(self)

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "MeshPart"
    }
    self.MeshFile = nil
    self.TextureFile = nil -- Maybe make this a table so we can put normals, and that super cool and realist stuff???
    self.Anchored = true

    self.Drawable = Dream:loadObject(self.MeshFile or "Assets/Scripty")
end

function Mesh:Update(dt)
    Mesh.super.Update(self, dt)
    
    self.Position = Vector3.new(0, math.sin(GlobalTick * 4) / 2, -5)
    self.Orientation = Vector3.new(0, GlobalTick * 2, 0)
end

return Mesh