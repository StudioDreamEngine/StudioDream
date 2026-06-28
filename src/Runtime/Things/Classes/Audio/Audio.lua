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
    self.DoesLoop = false
    self.Volume = 100
    self.Duration = 0
    self.TimePosition = 0
    self.StoppedPlaying = Signal:New("AudioStopplaying")
end

function Audio:DefineAPI()
    Audio.super.DefineAPI(self)

    self.Proxy.Property("Resource Resource")
    self.Proxy.Property("number Duration", "number TimePosition")
    self.Proxy.Property("number Volume")
    self.Proxy.Property("boolean DoesLoop")

    self.Proxy.Group("Audio","Resource","Duration","TimePosition","Volume","DoesLoop")
    self.Proxy.Icon("Audio")

    self.Proxy.Attribute("Resource","AudioPlayer")
    self.Proxy.Attribute("TimePosition", "Timer")
    self.Proxy.MakeCreatable()
end

function Audio:Play()
    if self.SoundObject then
        self.SoundObject:play()
    end
end

function Audio:Rewind()
    if self.SoundObject then
        self.SoundObject:seek(0)
    end
end

function Audio:Stop()
    if self.SoundObject then
        self.SoundObject:stop()
    end
end

function Audio:Pause()
    if self.SoundObject then
        self.SoundObject:pause()
    end
end

function Audio:SetResource(Identifier)
    self.SoundObject, self.Resource = Resources.LoadResourceFromIdentifier(Identifier, self.UUID)
end

function Audio:SetLoop()
    self.SoundObject:setVolume(self.Volume/100)
    self.Duration = self.SoundObject:getDuration()
    self.TimePosition = self.SoundObject:tell() -- this is a problem that will happend soon!!!!! i need to fix this now!!! like rn!! wow!
    if self.TimePosition >= self.Duration then
        self.StoppedPlaying.Invoke()
    end
    self.SoundObject:setLooping(self.DoesLoop)
end

function Audio:Update(dt)
    Audio.super.Update(dt)

    if self.SoundObject then
        self:SetLoop()
        self.Playing = self.SoundObject:isPlaying()
    end
end

return Audio