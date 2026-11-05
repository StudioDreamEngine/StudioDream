local Things = Runtime.Things
local SkyRenderer

---@class Sky: Thing
local Sky = Things.Extend("Thing")

function Sky:new()
    Sky.super.new(self) 

    self.Sun = nil
    self.Moon = nil

    self.Celestials = {
        Sun = nil,
        Moon = nil,
    }

    self.Time = 7
    self.Latitude = math.pi/3

    self.DefaultSky = Runtime.Resources.GetIdentifierFromID("Internal/Sky/sky.png")
    self.DefaultMoon = Runtime.Resources.GetIdentifierFromID("Internal/Sky/moon.png")
    self.DefaultSun = Runtime.Resources.GetIdentifierFromID("Internal/Sky/sun.png")

    SkyRenderer = Runtime.Backend3D.SkyRenderer

    self:SetMoon(self.DefaultMoon)
    self:SetSun(self.DefaultSun)
    self:SetSky(self.DefaultSky)
end

function Sky:DefineAPI()
    Sky.super.DefineAPI(self)

    self.Proxy.SetCategory("Lighting")

    self.Proxy.Property("Resource Sky","Resource Sun","Resource Moon","number Time","number Latitude")
    self.Proxy.Group("Resources","Sky","Sun","Moon")
    self.Proxy.Group("Time","Time","Latitude")
    self.Proxy.Icon("Sky")
    self.Proxy.MakeCreatable()
end

function Sky:UpdateValues()
    SkyRenderer.Time = self.Time
    SkyRenderer.Latitude = self.Latitude
end

function Sky:SetTime(NewTime)
    self.Time = NewTime
    self:UpdateValues()
end

function Sky:SetLatitude(NewLatitude)
    self.Latitude = NewLatitude
    self:UpdateValues()
end

function Sky:OnRemove()
    print("Cannot remove skybox (for now)")
end

function Sky:SetCelestial(Celestial,Identifier)
    self.Celestials[Celestial], self[Celestial] = Runtime.Resources.LoadResourceFromIdentifier(Identifier)
    --print(self[Celestial])

    --self.Celestials[Celestial] = love.graphics.readbackTexture(self.Celestials[Celestial])
    SkyRenderer.SetCelestials(Celestial,self.Celestials[Celestial])
end

function Sky:SetMoon(Identifier)
    self:SetCelestial("Moon",Identifier)
end

function Sky:SetSun(Identifier)
    self:SetCelestial("Sun",Identifier)
end

function Sky:SetSky(NewSky)
    local ResourceSource
    _, self.Sky, ResourceSource = Runtime.Resources.LoadResourceFromIdentifier(NewSky)

    SkyRenderer.SetSky(ResourceSource)
end

return Sky