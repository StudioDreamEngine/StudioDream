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

    self.Time = 9
    self.Latitude = math.pi/3

    self.SunColor = Color.new(1.0, 0.75, 0.5)
    self.MoonColor = Color.new(0.753, 0.863, 1)
    self.MoonBrightness = 1
    self.SunBrightness = 5

    self.DefaultSky = Runtime.Resources.GetIdentifierFromID("Internal/Sky/sky.png")
    self.DefaultMoon = Runtime.Resources.GetIdentifierFromID("Internal/Sky/moon.png")
    self.DefaultSun = Runtime.Resources.GetIdentifierFromID("Internal/Sky/sun.png")

    self.Sky = nil
    self.SkyBlockCube = nil

    SkyRenderer = Runtime.Backend3D.SkyRenderer

    self:SetMoon(self.DefaultMoon)
    self:SetSun(self.DefaultSun)
    self:SetSky(self.DefaultSky)
    self:SetTime(self.Time)
end

function Sky:DefineAPI()
    Sky.super.DefineAPI(self)

    self.Proxy.SetCategory("Lighting")

    self.Proxy.Property("Resource Sky","Resource Sun","Resource Moon","number Time","number Latitude","Color SunColor","Color MoonColor","number MoonBrightness",
    "number SunBrightness")
    self.Proxy.Group("Resources","Sky","Sun","Moon","SunColor","MoonColor")
    self.Proxy.Group("Bright","MoonBrightness","SunBrightness")
    self.Proxy.Group("Time","Time","Latitude")
    self.Proxy.Icon("Sky")
    self.Proxy.MakeCreatable()
end

function Sky:SetSunColor(NewColor)
    self.SunColor = NewColor
    self:UpdateValues()
end

function Sky:SetMoonColor(NewColor)
    self.MoonColor = NewColor
    self:UpdateValues()
end

function Sky:SetMoonBrightness(Number)
    self.MoonBrightness = Number
    self:UpdateValues()
end

function Sky:SetSunBrightness(Number)
    self.SunBrightness = Number
    self:UpdateValues()
end

function Sky:UpdateValues()
    if self.Parent:IsA("Lighting") then
        SkyRenderer.Time = self.Time
        SkyRenderer.Latitude = self.Latitude
        SkyRenderer.MoonBrightness = self.MoonBrightness
        SkyRenderer.SunBrightness = self.SunBrightness
        Runtime.Backend3D.MoonLight:setColor(self.MoonColor.R,self.MoonColor.G,self.MoonColor.B)
        Runtime.Backend3D.SunLight:setColor(self.SunColor.R,self.SunColor.G,self.SunColor.B)
        SkyRenderer.SetCelestials("Sun",self.Celestials.Sun)
        SkyRenderer.SetCelestials("Moon",self.Celestials.Moon)
        SkyRenderer.SetSky(self.SkyBlockCube)
    end
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
    --print("Cannot remove skybox (for now)")
    SkyRenderer.Reset()
end

function Sky:SetCelestial(Celestial,Identifier)
    self.Celestials[Celestial], self[Celestial] = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self, {
        Property = Celestial,
        Type = "Image"
    })

    self:UpdateValues()
    --self.Celestials[Celestial] = love.graphics.readbackTexture(self.Celestials[Celestial])
end

function Sky:SetMoon(Identifier)
    self:SetCelestial("Moon",Identifier)
end

function Sky:SetSun(Identifier)
    self:SetCelestial("Sun",Identifier)
end

function Sky:SetSky(NewSky)
    local ResourceSource
    _, self.Sky, ResourceSource = Runtime.Resources.LoadResourceFromIdentifier(NewSky, self, {
        Property = "Sky",
        Type = "Image"
    })

    self.SkyBlockCube = ResourceSource

    self:UpdateValues()
end

return Sky