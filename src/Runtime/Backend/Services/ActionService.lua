-- More accessible input system
local ActionService = {}

local ActionsOnService = {}

function ActionService.Init()
    for i,v in ipairs(ActionsOnService) do
        -- Erm!!! add to inputservice joystick signals, idk how that would work but meh :innocent:
    end
end

function ActionService:CreateAction(ActionName,ActionType)
    local self = {}

    function self:Connect(Func)
        table.insert(ActionsOnService,{Name = ActionName,Type = ActionType, Function = Func})
    end

    return self
end

return ActionService