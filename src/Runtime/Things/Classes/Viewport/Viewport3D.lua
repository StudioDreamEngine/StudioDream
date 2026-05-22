local Things = Runtime.Things

---@class Viewport3D: Viewport
local Viewport3D = Things.Extend("Viewport")

function Viewport3D:new()
    Viewport3D.super.new(self)
    self.Explorer = {
        Visible = true,
        
        Icon = "Viewport_3D"
    }
end

function Viewport3D:SetAbsoluteSize(New)
    Viewport3D.super.SetAbsoluteSize(self, New)
    Dream:resize(New.X, New.Y)
end

function Viewport3D:SetRenderFolder(NewRenderFolder)
    NewRenderFolder.Viewport = self
    self.RenderFolder = NewRenderFolder
end

-- Pain
function Viewport3D:GetCamera()
    return self:GetTarget().Camera
end

function Viewport3D:SubmitContainerChildren(Container)
    for _, Child in pairs(Container:GetChildren()) do
        if Child:IsA("Base3D") then
            self:SendChild(Child.Drawable)
        end
    end
end

function Viewport3D:Update(dt)
    Viewport3D.super.Update(self,dt)

    self.DisplayList = {}
    self:SubmitContainerChildren(self:GetTarget())
end

return Viewport3D