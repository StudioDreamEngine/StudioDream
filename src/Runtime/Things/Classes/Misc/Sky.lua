local Things = Runtime.Things

---@class Sky: Thing
local Sky = Things.Extend("Thing")

function Sky:new()
    Sky.super.new(self) 

    self.Resource = nil

    self.Sun = nil
    self.Moon = nil

    self.Celestials = {
        Sun = nil,
        Moon = nil,
    }

    self.Sky = nil
    
    self.Time = 7

    self.DefaultSky = Runtime.Resources.GetIdentifierFromID("Internal/sky.png")
    self.DefaultMoon = Runtime.Resources.GetIdentifierFromID("Internal/Sky/moon.png")
    self.DefaultSun = Runtime.Resources.GetIdentifierFromID("Internal/Sky/sun.png")
    self:SetMoon(self.DefaultMoon)
    self:SetSun(self.DefaultSun)
    self:SetResource(self.DefaultSky)
end

function Sky:DefineAPI()
    Sky.super.DefineAPI(self)

    self.Proxy.SetCategory("Lighting")

    self.Proxy.Property("Resource Resource","Resource Sun","Resource Moon","number Time")
    self.Proxy.Group("Settings","Resource","Sun","Moon","Time")
    self.Proxy.Icon("Sky")
    self.Proxy.MakeCreatable()
end

function Sky:SetTime(NewTime)
    self.Time = NewTime

    Runtime.Backend3D.SkyRenderer.Time = self.Time
end

function Sky:OnRemove()
    Dream:setSky()
end

function Sky:SetCelestial(Celestial,Identifier)
    self.Celestials[Celestial], self[Celestial] = Runtime.Resources.LoadResourceFromIdentifier(Identifier)
    print(self[Celestial])
    --self.Celestials[Celestial] = love.graphics.readbackTexture(self.Celestials[Celestial])
    Runtime.Backend3D.SkyRenderer.SetCelestials(Celestial,self.Celestials[Celestial])
end

function Sky:SetMoon(Identifier)
    self:SetCelestial("Moon",Identifier)
end

function Sky:SetSun(Identifier)
    self:SetCelestial("Sun",Identifier)
end

function Sky:SetResource(NewSky)
    if not NewSky or type(NewSky) == "boolean" then return end
    self.Sky, self.Resource = Runtime.Resources.LoadResourceFromIdentifier(NewSky)
    self.Sky = love.graphics.readbackTexture(self.Sky)
    Dream:setSky(love.graphics.newCubeImage(self.Sky))
end

function Sky:SetSky(NewSky)
    self:SetResource(NewSky)
end

return Sky