local Things = Runtime.Things

---@class Lighting: Thing
local Lighting = Things.Extend("Thing")

function Lighting:new()
    Lighting.super.new(self)

    self.GlobalShadows = true
    self.ScreenShader = nil

    self.Warning = nil
end

function Lighting:DefineAPI()
    Lighting.super.DefineAPI(self)
    self.Proxy.Property("boolean Warning")
    
    self.Proxy.Group("Root","Warning")
    self.Proxy.Attribute("Warning","RenderType","WIP")
    self.Proxy.Icon("Lighting")
end

return Lighting