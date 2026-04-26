local Debug = {}
local Services = Runtime.Services
local Things = Runtime.Things

function Debug:Init()
    print("Start debugservice")
    Services.InputService.InputBegan:Connect(function(Key)
        local Environment = Things.GetRoot("Environment")

        if Key == "F" then
            print("Viewport")
            local MousePos = Environment.Viewport.MousePosition
            
            ---@class Camera
            local Camera = Environment.Camera

            local MouseOrigin = Camera.Position
            local MouseDirection = Camera:VectorToWorldSpace(MousePos)*20

            local hit = Environment:Raycast(MouseOrigin, MouseDirection)

            if hit then
                local MouseHit = hit.position
                local MouseTarget = hit.mesh
                print("Hitted something wow!")
                print(MouseHit, MouseTarget)
            end
        end
    end)
end

return Debug