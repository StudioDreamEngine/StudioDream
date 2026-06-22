-- Moveable axis control
local Things = Runtime.Things
local Resources = Runtime.Resources

---@class Audio: Thing
local Audio = Things.Extend("Thing")

function Audio:new()
    Audio.super.new(self)

    self.Resource = nil
    self.SoundObject = nil ---@class love.Source

    self.Playing = false
    self.PlayButton = nil
end

function Audio:DefineAPI()
    Audio.super.DefineAPI(self)

    self.Proxy.Property("Resource Resource")
    self.Proxy.Property("Play_Button PlayButton")
    self.Proxy.Group("Audio","Resource","PlayButton")
    self.Proxy.Icon("Audio")
    self.Proxy.Attribute("PlayButton","AudioPlayer")
    self.Proxy.MakeCreatable()
end

function Audio:Play()
    if self.SoundObject then
        self.SoundObject:play()
    end
end

function Audio:SetResource(Identifier)
    self.SoundObject, self.Resource = Resources.LoadResourceFromIdentifier(Identifier, self.UUID)
end

return Audio