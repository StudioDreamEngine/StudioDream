local ToolManager = {}

local CurrentTool, ChosenTool

local SelectionProxy = Runtime.Things.New("Transformable3D") ---@class Transformable3D
local Origin = Vector3.zero

local LatestSelection -- Used for scale currently

local GridSnap, RotationSnap = 0.1, 10

local Selecting = {}

function ToolManager.GetCenter(Objects)
    local VectorAverage = Vector3.zero

    ---@param Selection Transformable3D
    for _, Selection in pairs(Objects) do
        VectorAverage = VectorAverage + Selection.Object.Position
    end

   return VectorAverage / table.length(Objects)
end

-- Setup selection transform for multipile selections
function ToolManager.SetupSelection()
    Selecting = {}

    for _, Select in pairs(Studio.Editor3D.Selecting) do
        if Select:IsA("Transformable3D") then
            table.insert(Selecting, { Object = Select, Difference = nil })
        end
    end

    local Center = ToolManager.GetCenter(Selecting)

    for _, Select in pairs(Selecting) do
        Select.Difference = Select.Object.Position - Center
        Select.OriginalTransform = Select.Object.Transform
        Select.Rotation = Select.Object.Transform.Rotation
    end

    Origin = Center
    SelectionProxy:SetPosition(Center)
end

function ToolManager.ChangeTransform(NewTransform)
    SelectionProxy:SetTransform(Transform3D.FromPosition(Origin) * NewTransform)

    for _, Select in pairs(Selecting) do
        Select.Object:SetTransform(SelectionProxy.Transform * Transform3D.FromPosition(Select.Difference) * Select.Rotation)
    end
end

function ToolManager.RegisterUndo()
    for _, Select in pairs(Selecting) do
        Studio.History.RegisterUndo("Property",{Obj = Select.Object, Property = "Transform", Val = Select.OriginalTransform})
    end
end

function ToolManager.Init()
    ToolManager.Move = require("Studio.Editor3D.Tools.Move")
    ToolManager.Scale = require("Studio.Editor3D.Tools.Scale")
    ToolManager.Rotate = require("Studio.Editor3D.Tools.Rotate")

    ChosenTool = ToolManager.Move

    Studio.Editor3D.OnSelect:Connect(function(Thing)
        if Thing:IsA("Transformable3D") then
            ToolManager.Select(Thing)
        end
    end)

    Studio.Editor3D.OnDeselect:Connect(ToolManager.Deselect)
end

function ToolManager.ChangeTool(Tool)
    ChosenTool = ToolManager[Tool]

    if CurrentTool then -- HACK
        ToolManager.Select()
    end
end

function ToolManager.Deselect()
    if CurrentTool then 
        CurrentTool.Destroy()
        CurrentTool = nil
    end
end

function ToolManager.Select(NewSelection)
    if NewSelection then
        LatestSelection = NewSelection
    end

    ToolManager.Deselect()

    CurrentTool = ChosenTool

    if CurrentTool.SingleSelect then
        CurrentTool.Selection = LatestSelection
    else
        ToolManager.SetupSelection()
        CurrentTool.Selection = SelectionProxy
    end

    CurrentTool.SetupSelection = ToolManager.SetupSelection
    CurrentTool.ChangeTransform = ToolManager.ChangeTransform
    CurrentTool.RegisterUndo = ToolManager.RegisterUndo
    
    if CurrentTool.Selection:IsA("Transformable3D") then
        CurrentTool.Init(CurrentTool.IsRotate and Studio.Editor3D.RotationSnap or Studio.Editor3D.GridSnap)
    end
end

function ToolManager.Update(dt)
    
end

return ToolManager