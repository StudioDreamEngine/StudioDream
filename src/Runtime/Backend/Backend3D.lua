local Backend3D = {}

local light

-- basic temporary camera for now
local TestCamera = require("Runtime.Backend.cameraController")


function Backend3D.Init()
    ---@diagnostic disable-next-line: missing-parameter
    Dream:init()

    Dream:setSky(love.graphics.newCubeImage("Assets/SkyTest.png"))

    light = Dream:newLight("sun", Dream.vec3(10000, 10000, 10000), Dream.vec3(1.0, 0.75, 0.5), 1.0)
end

function Backend3D.Render()
    TestCamera:setCamera(Dream.camera)
end

function Backend3D.Update(dt)
    Dream:update(dt)

    TestCamera:update(dt, 100)
end

return Backend3D