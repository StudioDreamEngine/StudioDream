local ToolManager = {}

local CurrentTool

function ToolManager.Init()
    ToolManager.Move = require("Studio.Editor3D.Tools.Move")
end

function ToolManager.Deselect()
    if CurrentTool then 
        CurrentTool.Destroy()
        CurrentTool = nil
    end
end

function ToolManager.Select(NewSelection)
    ToolManager.Deselect()

    CurrentTool = ToolManager.Move
    CurrentTool.Selection = NewSelection
    
    if NewSelection.Transform and not NewSelection:IsA("Camera") then
        CurrentTool.Init()
    end
end

function ToolManager.Update(dt)
    
end

return ToolManager