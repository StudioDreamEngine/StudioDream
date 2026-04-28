local SelectionThing = {}
local CurrentlySelecting

function SelectionThing.Init()
    local InputService = Runtime.Services.InputService

    InputService.InputBegan:Connect(function(Key)
        

        --[[if Key == "MouseLeftClick" and Services.InputService:IsKeyDown("LeftCtrl") then
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
        end]]


    end)
end

return SelectionThing