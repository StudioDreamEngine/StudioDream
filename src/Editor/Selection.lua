local SelectionThing = {}
local Selecting = {}

function SelectionThing:Init()
    local Services = Runtime.Services

    Services.InputService.InputBegan:Connect(function(Key)
        local MouseHit = Runtime.MouseHit
        if Key == "MouseLeftClick" and Services.InputService:IsKeyDown("LeftCtrl") then
            if MouseHit.Target and not Selecting[MouseHit.Target] then
                Selecting[MouseHit.Target] = true
            elseif Selecting[MouseHit.Target] then
                Selecting[MouseHit.Target] = nil
            end
            print(Selecting)
            print(MouseHit.Target)
        elseif Key == "MouseLeftClick" and not Services.InputService:IsKeyDown("LeftCtrl") then
            Selecting = {}

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