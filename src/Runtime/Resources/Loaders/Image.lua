return function(ImageBytes)
    local Data = love.filesystem.newFileData(ImageBytes, "ImageFile")

    return love.graphics.newImage(Data)
end