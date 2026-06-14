local UndoService = {}

local UndosSavedUp = {}
local UndoCurrent = 0

function UndoService.Undo()
    if UndoCurrent <= 0 then
        return
    end
    UndoCurrent = UndoCurrent-1
    local UndoFunction = UndosSavedUp[UndoCurrent]

    if UndoFunction then
        UndoFunction()
    end
    Studio.Layout.GetHandle("Notification").Notify("Un-did it","Info")
    print(UndoCurrent,UndosSavedUp)
end

function UndoService.DoIt()
    if UndoCurrent >= #UndosSavedUp then
        return
    end
    UndoCurrent = UndoCurrent+1
    local UndoFunction = UndosSavedUp[UndoCurrent]

    if UndoFunction then
        UndoFunction()
    end
    print(UndoCurrent,UndosSavedUp)

end

function UndoService.Init()
    local Input = Runtime.Services.Service("InputService")
    Input.KeyEvent:Connect(function(DidItBegan,Key)
        if DidItBegan then
            if Key == Enum.InputCode.Z and Input:KeyDownNumber(Enum.InputCode.LeftCtrl) then
                --print("hi")
                UndoService.Undo()
            elseif Key == Enum.InputCode.Y and Input:KeyDownNumber(Enum.InputCode.LeftCtrl) then
                UndoService.DoIt()
            end
        end
    end)
end

function UndoService.RegisterUndo(Obj,Property,Val)
    for i,v in pairs(UndosSavedUp) do
        if i > UndoCurrent then
            UndosSavedUp[i] = nil
        end
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