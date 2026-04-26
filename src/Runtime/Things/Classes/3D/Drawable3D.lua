local Things = Runtime.Things

---@class Drawable3D: Base3D
local Drawable3D = Things.Extend("Base3D")

function Drawable3D:new()
    Drawable3D.super.new(self)
end

function Drawable3D:OnRemove()
    Drawable3D.super.OnRemove(self)
    Runtime.Backend3D.RemoveObject(self)
end

function Drawable3D:LoadObject(Path)
    if (not Path) then
        Path = "Scripty"
    end

    self.MeshPath = Path
    self.Drawable = Runtime.Backend3D.LoadObject(self, "Assets/DefaultMeshes/"..Path)
end

return Drawable3D