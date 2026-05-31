return function(SoundBytes)
    local Data = love.filesystem.newFileData(SoundBytes, "SoundFile")

    return love.audio.newSource(Data, "static")
end