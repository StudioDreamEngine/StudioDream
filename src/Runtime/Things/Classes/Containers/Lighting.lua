local Things = Runtime.Things

---@class Lighting: Thing
local Lighting = Things.Extend("Thing")

function Lighting:new()
    Lighting.super.new(self)

    self.FogDensity = 1
    self.FogScatter = 1
    self.FogHeightMin = 1
    self.FogHeightMax = -1
    self.FogColor = Color.new(1)
    self.BloomQuality = 1
    self.BloomResolution = 0.5
	self.BloomSize = 0.1
	self.BloomStrength = 1.0
    self.AmbOccQuality = 32
    self.AmbOccResolution = 0.75
    self.AmbOccBlur = false
    self.ShadowIntensity = 1
    self.Gamma = 1
    self.GodRaysQuality = 0
end

function Lighting:DefineAPI()
    Lighting.super.DefineAPI(self)

    self.Proxy.Property("number FogScatter","number FogDensity","number FogHeightMin","number FogHeightMax","Color FogColor")
    self.Proxy.Property("number BloomQuality","number BloomResolution","number BloomSize","number BloomStrength")
    self.Proxy.Property("number ShadowIntensity")
    self.Proxy.Property("number Gamma","number GodRaysQuality")
    self.Proxy.Property("number AmbOccQuality","number AmbOccResolution","boolean AmbOccBlur")
    self.Proxy.Group("Fog","FogScatter","FogDensity","FogHeightMin","FogHeightMax","FogColor")
    self.Proxy.Group("Ambient Occlusion","AmbOccQuality","AmbOccResolution","AmbOccBlur")
    self.Proxy.Group("Bloom","BloomQuality","BloomResolution","BloomSize","BloomStrength")
    self.Proxy.Group("Misc","ShadowIntensity","Gamma","GodRaysQuality")
    self.Proxy.Icon("Lighting")
    self.Proxy.MakeNonDuplicatable()
end

function Lighting:UpdateFogDREAM()
    --[[Dream:setFog(self.FogDensity,self.FogColor,self.FogScatter)
    Dream:setFogHeight(self.FogHeightMin,self.FogHeightMax)]]
end

function Lighting:UpdateBloomDREAM()
    Dream:setBloom(self.BloomQuality,self.BloomResolution,self.BloomSize,self.BloomStrength)
end

function Lighting:UpdateAbmOccDREAM()
    Dream:setAO(self.AmbOccQuality,self.AmbOccResolution,self.AmbOccBlur)
end

function Lighting:SetAmbOccQuality(Number)
    self.AmbOccQuality = Number
    self:UpdateAbmOccDREAM()
end

function Lighting:SetAmbOccResolution(Number)
    self.AmbOccResolution = Number
    self:UpdateAbmOccDREAM()
end

function Lighting:SetAmbOccBlur(Boolean)
    self.AmbOccBlur = Boolean
    self:UpdateAbmOccDREAM()
end

function Lighting:SetShadowIntensity(Number)
    self.ShadowIntensity = Number
    Dream:setShadowIntensity(Number)
end

function Lighting:SetAmbientOcclusion()

end

function Lighting:SetGodRaysQuality(Number)
    self.GodRaysQuality = Number
    Dream:setGodrays(Number)
end

function Lighting:SetGamma(Number)
    self.Gamma = Number
    Dream:setGamma(Number)
end

function Lighting:SetBloomQuality(Number)
    self.BloomQuality = Number
    self:UpdateBloomDREAM()
end

function Lighting:SetBloomResolution(Number)
    self.BloomResolution = Number
    self:UpdateBloomDREAM()
end

function Lighting:SetBloomSize(Number)
    self.BloomSize = Number
    self:UpdateBloomDREAM()
end

function Lighting:SetBloomStrength(Number)
    self.BloomStrength = Number
    self:UpdateBloomDREAM()
end

function Lighting:SetFogHeightMin(Number)
    self.FogHeightMin = Number
    self:UpdateFogDREAM()
end

function Lighting:SetFogHeightMax(Number)
    self.FogHeightMax = Number
    self:UpdateFogDREAM()
end

function Lighting:SetFogMin(Number)
    self.FogMin = Number
    self:UpdateFogDREAM()
end

function Lighting:SetFogMax(Number)
    self.FogMax = Number
    self:UpdateFogDREAM()
end

function Lighting:SetFogColor(Number)
    self.FogColor = Number
    self:UpdateFogDREAM()
end

return Lighting