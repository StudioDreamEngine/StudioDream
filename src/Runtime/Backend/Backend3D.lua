local Backend3D = {}

local light

-- basic temporary camera for now
local TestCamera = require("Runtime.Backend.cameraController")

local scripty

function Backend3D.Init()
    ---@diagnostic disable-next-line: missing-parameter
    Dream:init()

    Dream:setSky(love.graphics.newCubeImage("Assets/SkyTest.png"))

    light = Dream:newLight("sun", Dream.vec3(10000, 10000, 10000), Dream.vec3(1.0, 0.75, 0.5), 1.0)

    scripty = Dream:loadObject("Assets/Scripty")
end

function Backend3D.Render()
    Dream:prepare()

    Dream:addLight(light)

    TestCamera:setCamera(Dream.camera)

    scripty:resetTransform()
    scripty:translate(0, 0, -3)
    scripty:rotateY(love.timer.getTime())

    Dream:draw(scripty)
end

function Backend3D.Update(dt)
    Dream:update(dt)

    TestCamera:update(dt, 100)
end

return Backend3D