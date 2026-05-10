local Things = Runtime.Things

---@class Drawable3D: Base3D
local Drawable3D = Things.Extend("Base3D")

local StencilMaterial = Dream:newMaterial()
StencilMaterial.stencil = true

function Drawable3D:new()
    Drawable3D.super.new(self)

    self.Drawable = nil ---@class DreamObject
    self.Outline = false
    self.Scale= Vector3.new(1, 1, 1)
    self.Proxy.Property("Scale")
end

function Drawable3D:OnRemove()
    Drawable3D.super.OnRemove(self)
    Runtime.Backend3D.RemoveObject(self)
end

function Drawable3D:SetOutline(Toggle)
    self.Outline = Toggle
end

function Drawable3D:LoadObject(Path)
    if (not Path) then
        Path = "Scripty"
    end

    self.MeshPath = Path
    self.Drawable = Runtime.Backend3D.LoadObject("Assets/DefaultMeshes/"..Path, self)
end

function Drawable3D:Update(dt)
    Drawable3D.super.Update(self, dt)
    self.Drawable:scaleWorld(self.Scale.ToDream())

    self.Size = self.Scale * self.Drawable:getBoundingSphere().size

    for _, Mesh in pairs(self.Drawable:getAllMeshes()) do
        Mesh[1].material.stencil = self.Outline
    end
end

return Drawable3D