local SelectionThing = {}
local Selecting = {}

function SelectionThing:Init()
    local Services = Runtime.Services

    Services.InputService.InputBegan:Connect(function(Key)
        if Key == "MouseLeftClick" and Services.InputService:IsKeyDown("LeftCtrl") then
            local MouseHit = Runtime.MouseHit
            if MouseHit.Target and not Selecting[MouseHit.Target] then
                Selecting[MouseHit.Target] = true
            elseif Selecting[MouseHit.Target] then
                Selecting[MouseHit.Target] = nil
            end
            print(Selecting)
            print(MouseHit.Target)
        end
    end)
end

return SelectionThing