local Things = Runtime.Things

---@class Sky: Thing
local Sky = Things.Extend("Thing")

function Sky:new()
    Sky.super.new(self) 

    self.Resource = nil
    self.Sky = nil

    self:SetResource("Internal/sky.png")
end

function Sky:DefineAPI()
    Sky.super.DefineAPI(self)

    self.Proxy.MakeCreatable()
end

function Sky:OnRemove()
    Dream:setSky()
end

function Sky:SetResource(NewSky)
    local _
    _, self.Resource, self.Sky = Runtime.Resources.LoadResourceFromIdentifier(NewSky)

    Dream:setSky(love.graphics.newCubeImage(self.Sky))
end

return Sky