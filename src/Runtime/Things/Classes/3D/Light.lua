local Things = Runtime.Things
local Renderer = Runtime.Renderer
local RuntimeService = Runtime.Services.Service("RuntimeService") ---@class RuntimeService

---@class Light: Transformable3D
local Light = Things.Extend("Transformable3D")

function Light:new()
    Light.super.new(self)

    
    self.Brightness = 1
    self.LightType = Enum.LightType.Point
    self.Color = Color.new(1,1,1,1)
    self.Range = 5
    self.HasShadow = false
    self.ShadowResolution = 1
    self.Shadow = nil
    self.Attenuation = 2.0
    self.Light = Dream:newLight(self.LightType, Dream.vec3(0, 0, 0), Dream.vec3(1.0, 1.0, 1.0), 1.0)

    local LightImage = Runtime.Resources.LoadResourceFromIdentifier("Internal/Light.png")
    self.Mesh, self.Drawable, self.BufferID = Renderer.Billboard.CreateBillboard(LightImage)

    RuntimeService.OnRunning:ConnectOnce(function() Runtime.Backend3D.UnregisterObject(self.UUID) end)
end

function Light:OnReady()
    -- Register billboard as an adorn object for now, fucks w/ other viewports but yea
    Runtime.Backend3D.RegisterObject(self.Drawable, self.UUID)
end

function Light:SetShadowResolution(Number)
    self.ShadowResolution = Number
    if self.Shadow then
        self.Shadow:setResolution(Number)
    end
end

function Light:SetHasShadow(Boolean)
    self.HasShadow = Boolean
    if Boolean then
        self.Shadow = self.Light:addNewShadow(self.ShadowResolution)
    else
        self.Shadow = nil
        self.Light:removeShadow() -- Only use to reset it
    end
end

function Light:SetAttenuation(Number)
    self.Attenuation = Number
    self.Light:setAttenuation(Number)
end

function Light:OnRemove()
    Light.super.OnRemove(self)
    Runtime.Backend3D.UnregisterObject(self.UUID)
end

function Light:DefineAPI()
    Light.super.DefineAPI(self)

    self.Proxy.SetCategory("3D")

    self.Proxy.Icon("Light")
    self.Proxy.Property("Transform3D Transform", "number Brightness","Enum.LightType LightType","Color Color","number Range")
    self.Proxy.Property("boolean HasShadow","number ShadowResolution","number Attenuation")
    self.Proxy.Group("Light Settings","Brightness","LightType","Color","Range","Attenuation")
    self.Proxy.Group("General","Transform")
    self.Proxy.Group("Shadow","HasShadow","ShadowResolution")
    self.Proxy.MakeCreatable()
end

function Light:SetTransform(NewTransform)
    Light.super.SetTransform(self,NewTransform)
    local Pos = NewTransform.Position

    self.Light:setPosition(Pos.X,Pos.Y,Pos.Z) -- im probably just doin some bs

    if self.LightType == Enum.LightType.Sun then
        self.Light:setDirection(NewTransform.Forward.X,NewTransform.Forward.Y,NewTransform.Forward.Z)
    end
end

function Light:SetColor(NewColor)
    self.Light:setColor(NewColor.R,NewColor.G,NewColor.B)
    self.Color = NewColor
end

function Light:Reload()
    self:SetRange(self.Range)
    self:SetBrightness(self.Brightness)
    self:SetColor(self.Color)
    self:SetTransform(self.Transform)
end

function Light:SetLightType(NewType)
    self.Light = Dream:newLight(NewType, Dream.vec3(0, 0, 0), Dream.vec3(1.0, 1.0, 1.0), 1.0)

    self:Reload()
end

function Light:SetRange(NewRange)
    self.Light:setSize(NewRange)
    self.Range = NewRange
end

function Light:SetParent(NewParent)
    Light.super.SetParent(self,NewParent)
    
    -- NEEDS ATTACHMENT FUNCTIONALITY

    --[[if self.Parent:IsA("Transformable3D") then
        self:SetTransform(self.Parent.Transform)
    end]]
end

function Light:SetBrightness(newBright)
    self.Light:setBrightness(newBright)
    self.Brightness = newBright
end

function Light:Update(dt)
    Light.super.Update(self, dt)

    Renderer.Billboard.UpdateTransform(self, self.Transform.Position, self:GetWorld())
end

return Light