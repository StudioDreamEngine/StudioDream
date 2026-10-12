return  {
    Load = function(SoundBytes)
        local Data = love.filesystem.newFileData(SoundBytes, "SoundFile")

        return love.audio.newSource(Data, "static"), love.sound.newSoundData(Data)
    end,
    Unload = function(Resource)
        Resource:dispose()
    end
}