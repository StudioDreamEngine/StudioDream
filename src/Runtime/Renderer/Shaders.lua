

local ShaderFolder = "Assets/Shaders/"

return {
    Interface = love.graphics.newShader(ShaderFolder.."Interface.glsl"),
    Final = function()
        return love.graphics.newShader(ShaderFolder.."Final.glsl")
    end,
    --Hack = love.graphics.newShader(ShaderFolder.."Hack.glsl")
}