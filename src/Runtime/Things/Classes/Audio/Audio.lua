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

    self.Proxy.Icon("Audio")
end

function Audio:SetResource(IdentifierID)
    self.Resource = Resources.GetIdentifier(IdentifierID)
    print(self.Resource)

    ---@class love.Source
    self.SoundObject = Resources.GetResource(self.Resource)
    self.SoundObject:play()
end

return Audio