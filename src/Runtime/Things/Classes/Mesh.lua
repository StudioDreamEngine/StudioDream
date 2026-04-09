local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'

local Mesh = Things.Extend("Viewport3D")
local MeshLoaded

function Mesh:new()
    Mesh.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "brick"
    }
    self.MeshFile = nil
    self.Anchored = true
end

function Mesh:Init()
    Mesh.super.Init(self)

    print("Hi i loaded")
    MeshLoaded = Dream:loadObject(self.MeshFile or "Assets/Scripty")
end

function Mesh:Draw()
    --MeshLoaded:translate(0, 0, -3)
end

return Mesh