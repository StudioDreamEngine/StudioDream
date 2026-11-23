local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Mesh: Drawable3D
local Mesh = Things.Extend("Drawable3D")
local DefaultMesh = Runtime.Resources.GetIdentifierFromID("Internal/DefaultMeshes/ball.obj")

function Mesh:new()
    Mesh.super.new(self)
end

function Mesh:OnReady()
    self:SetResource(DefaultMesh)
end

function Mesh:DefineAPI()
    Mesh.super.DefineAPI(self)

    self.Proxy.Property("Resource Resource")

    self.Proxy.Group("Visuals", "Resource")

    self.Proxy.Icon("MeshPart")
    self.Proxy.MakeCreatable()
end

function Mesh:Update(dt)
    Mesh.super.Update(self, dt)
end

return Mesh