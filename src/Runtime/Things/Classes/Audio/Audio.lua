-- Moveable axis control
local Things = Runtime.Things

---@class Audio: Thing
local Audio = Things.Extend("Thing")

function Audio:new()
    Audio.super.new(self)

    self.AudioPath = "/Assets/DefaultSounds/Jingle.wav"
    self.AudioType = Enum.AudioType.Static

    self.Source = love.audio.newSource(self.AudioPath,self.AudioType)

    self.Proxy.Property("FilePath AudioPath","Enum AudioType")
    self.Proxy.Group("Configuration","AudioPath","AudioType")
end

function UpdateSource()
    self.Source = love.audio.newSource(self.AudioPath,self.AudioType)
end

function Audio:Play()
    love.audio.play(self.Source)  -- If the parent is a 3D type of parent it will play using 3Dream audio libary but idk how that works for now
end

function Audio:SetAudioPath(Path)
    self.AudioPath = Path
end

function Audio:SetAudioType(NewEnum)
    self.AudioType = NewEnum
end

return Audio