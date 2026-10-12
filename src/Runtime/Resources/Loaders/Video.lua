return {
    Load = function(VideoBytes,Identifier)
        return love.graphics.newVideo(Identifier.Data.FilePath, true)
    end,
    Unload = function(Resource)
        Resource:dispose()
    end
}