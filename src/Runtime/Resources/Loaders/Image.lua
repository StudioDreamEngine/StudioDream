return function(ImageBytes)
    local Data = love.filesystem.newFileData(ImageBytes, "ImageFile")

    return Runtime.Backend2D.NewImage(Data)
end