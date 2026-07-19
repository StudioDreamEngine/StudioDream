local Things = Runtime.Things

---@class Material: Thing
local Material = Things.Extend("Thing")

function Material:new()
    Material.super.new(self)

    self.Color = Color.new(1,1,1,1)
    self.Emission = Color.new(0,0,0)
    self.EmissionFactor = Color.new(1, 1, 1)
    self.Roughness = 1
    self.Metallic = 0 -- 1
    self.Alpha = false
    self.Stencil = false
    self.Simple = false
    self.Cutout = false
    self.Particle = false
    self.AlphaCutoff = 0.5
    self.IOR = 1.0
    self.Translucency = 0.9
    self.CullMode = "back"

    -- General textures
    --self.AmbientOcclusionTexture = nil -- unused
    self.NormalTexture = nil
    self.EmissionTexture = nil -- Emission map texture
    self.MaterialTexture = nil -- Combination of the metalic, roughness and AO textures, in the future, when any of those are set, set this as the actual texture, and use dream:combineTextures(metallic, roughness, AO).
    self.AlbedoTexture = nil --love.graphics.newImage("Assets/DefaultMeshes/Luz_old.png") -- Color texture
    self.Reflective = false

    -- Mutli texture
    self.MultiTextureBlendScale = 3.7
    self.BlendTexture = nil
end

function Material:DefineAPI()
    Material.super.DefineAPI(self)

    self.Proxy.Property("Color Color","Color Emission","Color EmissionFactor","number Roughness","number Metallic","boolean Alpha","boolean Stencil","boolean Cutout","boolean Particle"
    ,"number AlphaCutoff","number IOR","number Translucency","Enum.CullMode CullMode","number MultiTextureBlendScale","boolean Reflective","boolean Simple")
    self.Proxy.Group("Colors","Color","Emission","EmissionFactor")
    self.Proxy.Group("Fell","Roughness","Metallic","Reflective")
    self.Proxy.Group("Shader","Alpha","AlphaCutoff","Stencil","Cutout","Particle","IOR","Translucency","CullMode", "Simple")
    self.Proxy.Property("Resource AlbedoTexture")
    self.Proxy.Group("Texture","AlbedoTexture","MultiTextureBlendScale")
    self.Proxy.Icon("Material")

    self.Proxy.MakeCreatable()
end

function Material:SetAlbedoTexture(Value)
    local ImageFile, Identifier = Runtime.Resources.LoadResourceFromIdentifier(Value, self.UUID)

    self.AlbedoTexture = Identifier
end

return Material