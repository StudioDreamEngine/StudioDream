local Things = Runtime.Things

---@module "Viewport"
local Viewport3D = Things.Extend("Viewport")

function Viewport3D:new()
    Viewport3D.super.new(self)
    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "Viewport_3D"
    }
end

function Viewport3D:SetAbsoluteSize(New)
    Viewport3D.super.SetAbsoluteSize(self, New)
    Dream:resize(New.X, New.Y)
end

function Viewport3D:SubmitContainerChildren(Container)
    for _, Child in pairs(Container:GetChildren()) do
        if Child:IsA("Mesh") then
            self:SendChild(Child.Drawable)
        end
    end
end

function Viewport3D:Update(dt)
    Viewport3D.super.Update(self,dt)

    self.DisplayList = {}
    self:SubmitContainerChildren(self.RenderFolder or self)
end

return Viewport3D