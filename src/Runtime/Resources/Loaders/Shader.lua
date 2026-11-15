return {
    Load = function(ShaderBytes)
        return love.graphics.newShader(ShaderBytes)
    end,
    Unload = function(Resource)
        Resource:release()
    end
}