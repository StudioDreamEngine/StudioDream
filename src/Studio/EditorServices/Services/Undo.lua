local UndoService = {}

local UndosSavedUp = {}
local UndoCurrent = 0

function UndoService.Undo()
    if UndoCurrent <= 0 then
        return
    end

    local UndoFunction = UndosSavedUp[UndoCurrent]
    UndoCurrent = UndoCurrent-1

    if UndoFunction then
        UndoFunction()
    end
end

function UndoService.DoIt()
    if UndoCurrent <= 0 then
        return
    end

    local UndoFunction = UndosSavedUp[UndoCurrent]
    UndoCurrent = UndoCurrent+1

    if UndoFunction then
        UndoFunction()
    end
end

function UndoService.Init()
    local Input = Runtime.Services.Service("InputService")
    Input.KeyEvent:Connect(function(DidItBegan,Key)
        if DidItBegan then
            if Key == Enum.InputCode.Z and Input:KeyDownNumber(Enum.InputCode.LeftCtrl) then
                --print("hi")
                UndoService.Undo()
            end
        end
    end)
end

function UndoService.RegisterUndo(Obj,Property,Val)
    while #UndosSavedUp > UndoCurrent do
        table.remove(UndosSavedUp)
    end
    local undoFunction = function()
        Runtime.Things.SetProperty(Obj, Property, Val)
    end
    table.insert(UndosSavedUp, undoFunction)
    UndoCurrent = UndoCurrent+1

    print(UndoCurrent,UndosSavedUp)
end

function UndoService.Clear()
    table.clear(UndosSavedUp)
    UndoCurrent = 0
end

return UndoService