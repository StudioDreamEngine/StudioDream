return {
    Load = function(ImageBytes)
        local Data = love.image.newImageData(love.filesystem.newFileData(ImageBytes, "ImageFile"))

        return Runtime.Backend2D.NewImage(Data), Data
    end,
    Unload = function(Resource)
        Resource:release()
    end
}