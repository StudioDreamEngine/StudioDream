local ToolManager = {}

local CurrentTool

function ToolManager.Init()
    ToolManager.Move = require("Studio.Editor3D.Tools.Move")
end

function ToolManager.Deselect()
    if CurrentTool then CurrentTool.Destroy() end
end

function ToolManager.Select(NewSelection)
    ToolManager.Deselect()

    CurrentTool = ToolManager.Move
    CurrentTool.Selection = NewSelection
    CurrentTool.Init()
end

function ToolManager.Update(dt)
    
end

return ToolManager