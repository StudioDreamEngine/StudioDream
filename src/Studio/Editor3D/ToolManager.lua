local ToolManager = {}

local CurrentTool
local Selection = Runtime.Things.New("Transformable3D") ---@class Transformable3D
local Selecting = {}

function ToolManager.Init()
    ToolManager.Move = require("Studio.Editor3D.Tools.Move")

    Studio.Editor3D.OnSelect:Connect(function(Thing)
        ToolManager.Select(Thing)
    end)
end

function ToolManager.Deselect()
    if CurrentTool then 
        CurrentTool.Destroy()
        CurrentTool = nil
    end
end

function ToolManager.GetCenter(Objects)
    local VectorAverage = Vector3.zero

    ---@param Selection Drawable3D
    for _, Selection in pairs(Objects) do
        VectorAverage = VectorAverage + Selection.Object.Position
    end

   return VectorAverage / table.length(Objects)
end

function ToolManager.SetupSelection()
    Selecting = {}

    for _, Select in pairs(Studio.Editor3D.Selecting) do
        table.insert(Selecting, { Object = Select, Difference = nil })
    end

    local Center = ToolManager.GetCenter(Selecting)

    for _, Select in pairs(Selecting) do
        Select.Difference = Select.Object.Position - Center
    end

    Selection:SetTransform(Transform3D.FromPosition(Center))
end

function ToolManager.ChangeTransform(NewTransform)
    for _, Select in pairs(Selecting) do
        Select.Object:SetTransform(NewTransform * Transform3D.FromPosition(Select.Difference))
    end

    Selection:SetTransform(Transform3D.FromPosition(ToolManager.GetCenter(Selecting)))
end

function ToolManager.Select(NewSelection)
    ToolManager.SetupSelection()
    ToolManager.Deselect()

    CurrentTool = ToolManager.Move
    CurrentTool.Selection = Selection

    CurrentTool.SetupSelection = ToolManager.SetupSelection
    CurrentTool.ChangeTransform = ToolManager.ChangeTransform
    
    if NewSelection:IsA("Drawable3D") then
        CurrentTool.Init()
    end
end

function ToolManager.Update(dt)
    
end

return ToolManager