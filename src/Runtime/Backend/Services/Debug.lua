local Debug = {}
local Services = Runtime.Services
local Viewport
local Scripty

function Debug:SetViewportDefaultOnService(View)
    Viewport = View
end

function Debug:AssingScripty(Thing)
    Scripty = Thing
end

function Debug:Init()
    Services.InputService:InputBegan():Connect(function(Key)
        if Key == "F" then
            local MousePos = Viewport.MousePosition

            local MouseOrigin = Viewport.Camera.position
            local MouseDirection = Viewport:ToWorldSpaceVector(MousePos)

            local hit = Services.RaycastService:Raycast(Scripty.Drawable, MouseOrigin, MouseDirection)

            if hit then
                local MouseHit = hit.position
                local MouseTarget = hit.mesh

                print(MouseHit, MouseTarget)
            end
        end
    end)
end

return Debug