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
    self.Proxy.Property("boolean PlayButton")

    self.Proxy.Group("Audio","Resource","Duration","TimePosition","Volume","DoesLoop","PlayButton")
    self.Proxy.Icon("Audio")

    self.Proxy.Attribute("PlayButton","RenderType","AudioPlayer")
    self.Proxy.Attribute("TimePosition", "RenderType","Timer")

    self.Proxy.Attribute("Resource", "SupportedType", "Audio")

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
    self.SoundObject, self.Resource = Resources.LoadResourceFromIdentifier(Identifier, self.UUID, "Sound")
    if (not self.SoundObject) then return end
end

function Audio:SetVolume(NewVol)
    self.Volume = NewVol
    if self.SoundObject then
        self.SoundObject:setVolume(NewVol/100)
    end
end

function Audio:SetLoop(DoesIt)
    self.DoesLoop = DoesIt
    if self.SoundObject then
        self.SoundObject:setLooping(DoesIt)
    end
end

function Audio:SetTimePosition(NewTime)
    self.TimePosition = NewTime
    if self.SoundObject then 
        self.SoundObject:seek(NewTime)
    end
end

function Audio:Update(dt)
    Audio.super.Update(dt)

    if self.SoundObject then
        self:SetLoop()

        local Playing = self.SoundObject:isPlaying()

        if (not Playing) and self.Playing then
            print("Stopped")
            self.StoppedPlaying.Invoke()
        end

        self.Playing = Playing

        self.Duration = self.SoundObject:getDuration()

        self:SetTimePosition(self.SoundObject:tell())
    end
end

return Audio