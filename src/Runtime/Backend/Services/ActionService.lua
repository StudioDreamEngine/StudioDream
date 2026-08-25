-- More accessible input system
local ActionService = {}

local ActionsOnService = {}

--[[
    API Idea:
        MyAction = ActionService:CreateAction("ActionName", Enum.ActionType.Direction)

        MyAction:AddBinding(Enum.InputPlatform.Controller, Enum.InputCode.JoystickLeft)
        MyAction:AddBinding(Enum.InputPlatform.Keyboard, { -- Throws an error if a direction action isnt provided a table here
            Enum.InputCode.W, -- up
            Enum.InputCode.A, -- left
            Enum.InputCode.S, -- down
            Enum.InputCode.D, -- right
        })


        MyAction.Began -- Event that checks when the action has started input
        MyAction.Value -- The value of the current action, if this is a direction it will be a vector2 and shows what direction your currently holding


        -- By default, shortcuts use ctrl
        MyCopyShortcut = ActionService:CreateShortcut("Name", Enum.KeyCode.C, Enum.Modifier.Primary) 
    
        
        -- Primary - Ctrl
        -- Secondary - Alt
        -- Meta - Window or command
        we are not adding shift key support
]]

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