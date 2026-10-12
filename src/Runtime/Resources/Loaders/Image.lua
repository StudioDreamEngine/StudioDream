return {
    Load = function(ImageBytes)
        local Data = love.filesystem.newFileData(ImageBytes, "ImageFile")

        return Runtime.Backend2D.NewImage(Data), Data
    end,
    Unload = function(Resource)
        Resource:dispose()
    end
}