-- Moveable axis control
local Things = Runtime.Things
local Resources = Runtime.Resources

---@class Audio: Thing
local Audio = Things.Extend("Thing")

function Audio:new()
    Audio.super.new(self)

    self.Resource = nil
end

function Audio:DefineAPI()
    Audio.super.DefineAPI(self)

    self.Proxy.Property("Resource Resource")
    self.Proxy.Icon("Audio")
end

function Audio:SetResource(Identifier)
    self.SoundObject, self.Resource = Resources.LoadFromIdentifier(Identifier, self.UUID)
end

return Audio