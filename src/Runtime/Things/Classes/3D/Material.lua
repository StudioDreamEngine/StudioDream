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
    self.DepthTest = true

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

    self.Dirty = 0 -- Dirty number for the material, updated every time the material properties are changed
    self.MaterialList = {} -- Processed table
end

function Material:OnReady()
    self:OnPropertyUpdate()
end

function Material:DefineAPI()
    Material.super.DefineAPI(self)

    self.Proxy.SetCategory("3D")
    
    self.Proxy.Property("Color Color","Color Emission","Color EmissionFactor","number Roughness","number Metallic","boolean Alpha","boolean Stencil","boolean Cutout","boolean Particle"
    ,"number AlphaCutoff","number IOR","number Translucency","Enum.CullMode CullMode","number MultiTextureBlendScale","boolean Reflective","boolean Simple","boolean DepthTest")
    self.Proxy.Group("Colors","Color","Emission","EmissionFactor")
    self.Proxy.Group("Fell","Roughness","Metallic","Reflective")
    self.Proxy.Group("Shader","Alpha","AlphaCutoff","Stencil","Cutout","Particle","IOR","Translucency","CullMode", "Simple", "DepthTest")
    self.Proxy.Property("Resource AlbedoTexture")
    self.Proxy.Group("Texture","AlbedoTexture","MultiTextureBlendScale")
    self.Proxy.Icon("Material")

    self.Proxy.MakeCreatable()
end

-- Create a list with overrides for drawables
function Material:CreateList(Overrides)
    local MaterialList = table.clone(self.MaterialList)

    for Name, Value in pairs(Overrides) do
        MaterialList[Name] = Value
    end

    return MaterialList
end

function Material:OnPropertyUpdate()
    local Proxy = self.Proxy

    for Name, _ in pairs(Proxy.Serializable) do
        local Value = self[Name]

        if Value and Proxy.Types[Name] == "Resource" then
            self.MaterialList[Name] = Runtime.Resources.LoadResourceFromIdentifier(Value)
        else
            self.MaterialList[Name] = Value
        end
    end

    self.Dirty = self.Dirty + 1 -- I'd add a modulo but theres no way someones making those many (like what, 2^256?)
end

function Material:SetAlbedoTexture(Value)
    local _, Identifier = Runtime.Resources.LoadResourceFromIdentifier(Value, self.UUID, {
        Type = "Image",
        Property = "AlbedoTexture"
    })

    self.AlbedoTexture = Identifier
end

return Material