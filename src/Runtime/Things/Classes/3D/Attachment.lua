local Things = Runtime.Things
local Renderer = Runtime.Renderer
local RuntimeService = Runtime.Services.Service("RuntimeService") ---@class RuntimeService

---@class Attachment: Transformable3D
local Attachment = Things.Extend("Transformable3D")

function Attachment:new()
    Attachment.super.new(self)

    self.LocalTransform = Transform3D.FromPosition(0,0,0)

    local AttachImage = Runtime.Resources.LoadResourceFromIdentifier("Internal/Attachment.png")
    self.Mesh, self.Drawable = Renderer.Billboard.CreateBillboard(AttachImage)

    RuntimeService.OnRunning:ConnectOnce(function() Runtime.Backend3D.UnregisterObject(self.UUID) end)
end

function Attachment:OnReady()
    -- Register billboard as an adorn object for now, fucks w/ other viewports but yea
    Runtime.Backend3D.RegisterObject(self.Drawable, self.UUID)
end

function Attachment:OnRemove()
    Attachment.super.OnRemove(self)
    Runtime.Backend3D.UnregisterObject(self.UUID)
end

function Attachment:SetTransform(Transform)
    Attachment.super.SetTransform(self,Transform)

    self:SetLocalTransform(Transform)
end

function Attachment:SetLocalTransform(Transform)
    if Transform and self.Parent and not self.Parent:IsA("BaseGui") and self.Parent.Transform then
        print(Transform)
        print(self.Parent.Transform)
        self.LocalTransform = Transform*self.Parent.Transform:Inverse()
        self:SetTransform(Transform-Transform3D.FromPosition(0,0,0))
    end
end

function Attachment:DefineAPI()
    Attachment.super.DefineAPI(self)

    self.Proxy.Icon("Attachment")
    self.Proxy.Property("Transform3D Transform","Transform3D LocalTransform")
    self.Proxy.Group("General","Transform","LocalTransform")
    --self.Proxy.MakeCreatable()
end

function Attachment:Update(dt)
    Attachment.super.Update(self, dt)

    Renderer.Billboard.UpdateTransform(self, self.Transform.Position, self:GetWorld())
end

return Attachment