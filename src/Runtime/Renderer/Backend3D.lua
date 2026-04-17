local Backend3D = {}

function Backend3D.Init()
    ---@diagnostic disable-next-line: missing-parameter
    Dream:init()

    Dream:setSky(love.graphics.newCubeImage("Assets/sky.png"))
end

return Backend3D