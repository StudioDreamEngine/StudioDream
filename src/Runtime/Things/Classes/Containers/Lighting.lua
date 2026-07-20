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
    self.Proxy.Property("boolean GlobalShadows")
    self.Proxy.Property("Thing ScreenShader")

    self.Proxy.Group("General","Warning","GlobalShadows","ScreenShader")
    self.Proxy.Attribute("Warning","RenderType","WIP")
    self.Proxy.Icon("Lighting")
end

return Lighting