local Things = Runtime.Things

---@module "Viewport"
---@class Viewport3D
local Viewport3D = Things.Extend("Viewport")

function Viewport3D:new()
    Viewport3D.super.new(self)
    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "Viewport_3D"
    }
    self.Camera = Dream.camera
end

function Viewport3D:SetAbsoluteSize(New)
    Viewport3D.super.SetAbsoluteSize(self, New)
    Dream:resize(New.X, New.Y)
end

function Viewport3D:SubmitContainerChildren(Container)
    for _, Child in pairs(Container:GetChildren()) do
        if Child:IsA("Base3D") then
            self:SendChild(Child.Drawable)
        end
    end
end

function Viewport3D:ToWorldSpaceVector(vec2) -- Alot of reaserch :sob: i dont want any more math
    local ViewWidth = self.AbsoluteSize.X
    local ViewHeight = self.AbsoluteSize.Y

    local x = (2 * vec2.X / ViewWidth - 1)
    local y = (1 - 2 * vec2.Y / ViewHeight)

    local CamFov = self.Camera.fov
    local ViewAspect = ViewWidth / ViewHeight
    local TanFov = math.tan(CamFov / 2)

    local DirCamera = Vector3.new(x * ViewAspect * TanFov,y * TanFov,-1).Unit()
    local m = self.Camera.transform

    local dirWorld = Vector3.new(m[1] * DirCamera.X + m[2] * DirCamera.Y + m[3] * DirCamera.Z,
        m[5] * DirCamera.X + m[6] * DirCamera.Y + m[7] * DirCamera.Z,
        m[9] * DirCamera.X + m[10]* DirCamera.Y + m[11]* DirCamera.Z)
    return dirWorld.Unit()
end

function Viewport3D:Update(dt)
    Viewport3D.super.Update(self,dt)

    self.DisplayList = {}
    self:SubmitContainerChildren(self.RenderFolder or self)
end

return Viewport3D