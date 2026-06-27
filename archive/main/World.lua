---@diagnostic disable: undefined-global, undefined-field
local World = {}

local light

--World.Collision = require("Engine.Core3D.Collision")

function World.Init()
    Dream:setBloom(3)

    LoveEvents.ResizeWindow:Connect(function()
        local NewSize = VisualUtils.GetWindowSize()
        Dream:resize(NewSize.X,NewSize.Y)
    end)

    ---@diagnostic disable-next-line: missing-parameter
    Dream:init()

    light = Dream:newLight("sun", Dream.vec3(10000, 10000, 10000), Dream.vec3(1.0, 0.75, 0.5), 1.0)
    light:addNewShadow()

    World.Instances = {}
    World.Camera = Dream.camera
end

function World.NewInstance(Type, ...)
    local Instance = require("Engine.Core3D.Objects."..Type).new(...)

    Instance.UUID = UUID()
    Instance.Init()

    World.Instances[Instance.UUID] = Instance

    return Instance
end

function World.LoadModel(Path, Name)
    return World3D.NewInstance("Mesh", Path, Name)
end

local cameraController = require("Packages.3DreamEngine.extensions.utils.cameraController")

function World.Render()
    Profiler.Start("World3D")
        Dream:prepare()

        --cameraController:setCamera(World.Camera)

        Dream:addLight(light)

        for _, Instance in pairs(World.Instances) do
            if Instance.Update then
                VisualUtils.AtOrigin(Instance.Update)
            end

            Instance.UpdateTransform()
        end

        VisualUtils.AtOrigin(function()
            Dream:present()
        end)
    Profiler.End()
end

function World.Step(dt)
    --cameraController:update(dt)
    Dream:update()
end

function World.Destroy()
    
end

return World