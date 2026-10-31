local Things = Runtime.Things

---@class Sky: Thing
local Sky = Things.Extend("Thing")

function Sky:new()
    Sky.super.new(self) 

    self.Resource = nil
    self.Sky = nil

    self.DefaultSky = Runtime.Resources.GetIdentifierFromID("Internal/sky.png")
    self:SetResource(self.DefaultSky)
end

function Sky:DefineAPI()
    Sky.super.DefineAPI(self)

    self.Proxy.Property("Resource Resource")
    self.Proxy.Group("Settings","Resource")
    self.Proxy.Icon("Sky")
    self.Proxy.MakeCreatable()
end

function Sky:OnRemove()
    Dream:setSky()
end

function Sky:SetResource(NewSky)
    if not NewSky or type(NewSky) == "boolean" then return end
    print(NewSky)
    self.Sky, self.Resource = Runtime.Resources.LoadResourceFromIdentifier(NewSky)
    self.Sky = love.graphics.readbackTexture(self.Sky)
    Dream:setSky(love.graphics.newCubeImage(self.Sky))
end

function Sky:SetSky(NewSky)
    self:SetResource(NewSky)
end

return Sky