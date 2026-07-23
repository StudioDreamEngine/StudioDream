local UndoService = {}

local SavedUndoActions = {}
local CurrentUndo = 0

function UndoService.Undo()
    if CurrentUndo <= 0 then return end

    local UndoFunction = SavedUndoActions[CurrentUndo]
    CurrentUndo = CurrentUndo-1

    if UndoFunction then
        UndoFunction()
    end
end

function UndoService.DoIt()
    if CurrentUndo >= #SavedUndoActions then return end

    CurrentUndo = CurrentUndo+1
    local UndoFunction = SavedUndoActions[CurrentUndo]

    if UndoFunction then
        UndoFunction()
    end
end

function UndoService.Init()
    local Input = Runtime.Services.Service("InputService")
    Input.KeyEvent:Connect(function(DidItBegan,Key)
        if DidItBegan and Input:KeyDownNumber(Enum.InputCode.LeftCtrl) then
            if Key == Enum.InputCode.Z then
                UndoService.Undo()
            elseif Key == Enum.InputCode.Y then
                UndoService.DoIt()
            end
        end
    end)
end

function UndoService.RegisterUndo(Obj,Property,Val)
    for i,v in pairs(SavedUndoActions) do
        if i > CurrentUndo then
            SavedUndoActions[i] = nil
        end
    end

    table.insert(SavedUndoActions, function()
        Runtime.Things.SetProperty(Obj, Property, Val)
    end)
    
    CurrentUndo = CurrentUndo+1
   
    print(CurrentUndo,SavedUndoActions)
end

function UndoService.Clear()
    table.clear(SavedUndoActions)
    CurrentUndo = 0
end

return UndoService