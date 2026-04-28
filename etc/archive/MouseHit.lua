-- Temporary

local MouseAhh = {}
local Things = Runtime.Things
local Services = Runtime.Services
local Environment
local StartedThingWow = false

function MouseAhh:Init()
    MouseAhh.Hit = nil
    MouseAhh.Target = nil

    Services.InputService.InputBegan:Connect(function(Key)
        Environment = Things.GetRoot("Environment")
        if Key == "R" then
           StartedThingWow = true
        end
    end)
end

function MouseAhh:Update(dt)
    if StartedThingWow then
        local MousePos = Environment.Viewport.MousePosition
            
        ---@class Camera
        local Camera = Environment.Camera

        local MouseOrigin = Camera.Position
        local MouseDirection = Camera:VectorToWorldSpace(MousePos)*20

        local hit = Environment:Raycast(MouseOrigin, MouseDirection)

        if hit then
            local MouseHit = hit.position
            local MouseTarget = hit.mesh
            MouseAhh.Hit = MouseHit
            MouseAhh.Target = MouseTarget
        end
    end
end

return MouseAhh