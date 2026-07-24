local Things = Runtime.Things

---@class Light: Base3D
local Light = Things.Extend("Transformable3D")

function Light:new()
    Light.super.new(self)

    self.Drawable = Dream:newLight("sun", Dream.vec3(0, 0, 0), Dream.vec3(1.0, 1.0, 1.0), 1.0)
    self.Brightness = 1
    self.LightType = "point"
    self.Color = Color.new(1,1,1,1)
    self.Range = 5
end

function Light:DefineAPI()
    Light.super.DefineAPI(self)

    self.Proxy.Icon("Light")
    self.Proxy.Property("Transform3D Transform", "number Brightness","Enum.LightType LightType","Color Color","number Range")
    self.Proxy.Group("Light Settings","Brightness","LightType","Color","Range")
    self.Proxy.Group("General","Transform")
    self.Proxy.MakeCreatable()
end

function Light:SetTransform(NewTransform)
    Light.super.SetTransform(self,NewTransform)
    local Pos = NewTransform.Position

    self.Drawable:setPosition(Pos.X,Pos.Y,Pos.Z) -- im probably just doin some bs

    if self.LightType == Enum.LightType.Spot then
        self.Drawable:setDirection(NewTransform.Forward.X,NewTransform.Forward.Y,NewTransform.Forward.Z)
    end
end

function Light:SetColor(NewColor)
    self.Drawable:setColor(NewColor.R,NewColor.G,NewColor.B)
    self.Color = NewColor
end

function Light:SetRange(NewRange)
    self.Drawable:setSize(NewRange)
    self.Range = NewRange
end

function Light:SetBrightness(newBright)
    self.Drawable:setBrightness(newBright)
    self.Brightness = newBright
end

return Light