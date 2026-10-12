return {
    Load = function(FontBytes)
        local Data = love.filesystem.newFileData(FontBytes, "FontFile")

        return love.graphics.newFont(Data,32)
    end,
    Unload = function(Resource)
        Resource:dispose()
    end
}