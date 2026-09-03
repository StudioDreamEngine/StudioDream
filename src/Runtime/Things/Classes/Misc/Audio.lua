-- Moveable axis control
local Things = Runtime.Things
local Resources = Runtime.Resources

---@class Audio: Thing
local Audio = Things.Extend("Thing")

function Audio:new()
    Audio.super.new(self)

    self.Resource = nil
    self.SoundData = nil ---@class love.sound
    self.SoundObject = nil ---@class love.Source

    self.KeepReference = true

    self.Playing = false
    self.DoesLoop = false
    self.Volume = 100
    self.Velocity = 1
    self.Duration = 0
    self.TimePosition = 0
    self.IsSpaceRelative = false
    self.ChannelCount = 0
    self.FilterPass = Enum.FilterPass.LowPass
    self.Effects = {}

    self.Loudness = 0

    self._EffectsConnections = {}

    self.StoppedPlaying = Signal:New("AudioStopplaying")
end

function Audio:GetTranformParent()

    local function LoopThoughParents(Object)
        if Object.Parent:IsA("Transform3D") then
            return Object.Parent
        elseif Object.Parent:IsA("Folder") then
            LoopThoughParents(Object.Parent)
        else
            return nil
        end
    end

    return LoopThoughParents(self.Object)
end

function Audio:DefineAPI()
    Audio.super.DefineAPI(self)

    self.Proxy.SetCategory("Sound")

    self.Proxy.Property("Resource Resource")
    self.Proxy.Property("number Duration", "number TimePosition", "number Loudness")
    self.Proxy.Property("number Volume","number Velocity")
    self.Proxy.Property("boolean DoesLoop","boolean IsSpaceRelative")

    self.Proxy.Group("Audio","Resource","Duration","TimePosition","Volume","DoesLoop","Velocity","IsSpaceRelative","Loudness")
    self.Proxy.Icon("Audio")

    self.Proxy.Attribute("TimePosition", "RenderType","Timer")

    self.Proxy.Attribute("Resource", "RenderExtra", "Audio")

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

function Audio:SetFilterPass(FilterEnum)
    self.FilterPass = FilterEnum
    if self.SoundObject then
        self.SoundObject:setFilter({ type = FilterEnum})
    end
end

function Audio:RefreshEffects()
    for i,v in pairs(self.Effects) do
        Audio:SetEffect(v)
    end
end

function Audio:RefreshSource()
    if self.SoundObject then
        self.SoundObject:setVolume(self.Volume/100)
        self.SoundObject:setLooping(self.DoesLoop)
        self:SetTimePosition(0)
        self:UpdateChannelCount()
        self:SetIsSpaceRelative(self.IsSpaceRelative)
        self:SetFilterPass(self.FilterPass)
        self:RefreshEffects()
    end
end

function Audio:CalculateLoudness()
    if not self.Playing or self.SoundData then self.Loudness = 0 return end

    local SampleIndex = math.floor(self.TimePosition*self.SoundData:getSampleRate())
    SampleIndex = math.max(0,math.min(SampleIndex))
    local SampleValue = self.SoundData:getSample(SampleIndex)

    self.Loudness = math.abs(SampleValue)
end

function Audio:SetEffect(Effect)
    assert(Utils.TypeOf(Effect)=="Effect","Effect expected, got: "..Utils.TypeOf(Effect))
    self.Effects[Effect.Name] = Effect
    
    -- check if the effect is possible to be used

    if self.SoundObject then
        local ActualName = self.UUID..Effect.Name

        print(ActualName)

        love.audio.setEffect(ActualName,Effect.LOVE)
        
        self.SoundObject:setEffect(ActualName)
        self._EffectsConnections[ActualName] = Effect._UPDATED:Connect(function() -- Might cause some trouble, make old one get disconnected first if it causes
            if self.SoundObject then
                love.audio.setEffect(ActualName,Effect.LOVE)
                self.SoundObject:setEffect(ActualName)
            end
        end)
    end
end

function Audio:RemoveEffect(Effect)
    local EffectToRemove = type(Effect)=="string" and self.Effects[Effect.Name] or Effect.Name
    local ActualName = self.UUID..EffectToRemove.Name

    if self.SoundObject then
        self.SoundObject:setEffect(ActualName,false)
    end

    self._EffectsConnections[ActualName]:Disconnect()
    self._EffectsConnections[ActualName] = nil
    self.Effects[ActualName] = nil
end

function Audio:SetResource(Identifier)
    self.SoundObject, self.Resource, self.SoundData = Resources.LoadResourceFromIdentifier(Identifier, self.UUID, "Sound")
    if (not self.SoundObject) then return end
    self:RefreshSource()
end

function Audio:SetVolume(NewVol)
    self.Volume = NewVol
    self:RefreshSource()
end

function Audio:SetLoop(DoesIt)
    if NewVol == nil then return end
    self.DoesLoop = DoesIt
    self:RefreshSource()
end

function Audio:SetTimePosition(NewTime)
    self.TimePosition = NewTime

    if self.SoundObject then
        self.SoundObject:seek(self.TimePosition)
    end
end

function Audio:UpdateChannelCount() -- This is only for internal stuff
    if self.SoundObject then
        self.ChannelCount = self.SoundObject:getChannelCount()
    end
end

function Audio:HandleRelative()
    if self.SoundObject and self.SoundObject:getChannelCount()==1 and self.SoundObject:isRelative() then
        local TranformObject = self:GetTranformParent()
        if TranformObject then
            self.SoundObject:setPosition(TranformObject.Position.X,TranformObject.Position.Y,TranformObject.Position.Z)
        else
            self.SoundObject:setPosition(0,0,0)
        end
    end
end

function Audio:SetIsSpaceRelative(NewBoolean)
    self.IsSpaceRelative = NewBoolean
    if self.SoundObject and self.SoundObject:getChannelCount()==1 then
        self.SoundObject:setRelative(NewBoolean)
    elseif self.SoundObject and self.ChannelCount~=1 then
        assert("IsSpaceRelative Can only be used if the ChannelCount is one")
    end
end

function Audio:Update(dt)
    Audio.super.Update(dt)

    if self.SoundObject then
        self:SetLoop()

        local Playing = self.SoundObject:isPlaying()
        self.KeepReference = Playing

        if (not Playing) and self.Playing then
            print("Stopped")
            self.StoppedPlaying.Invoke()
        end

        self.Playing = Playing

        self.Duration = self.SoundObject:getDuration()

        self:HandleRelative()

        self:SetTimePosition(self.SoundObject:tell())

        self:CalculateLoudness()
    end
end

function Audio:OnRemove()
    Audio.super.OnRemove(self)

    if self.SoundObject then
        self:Stop()
        self.SoundObject = nil
    end
end

return Audio