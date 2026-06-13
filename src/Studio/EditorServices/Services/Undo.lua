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

function UndoService.RegisterUndo(undoFunction)
    while #UndosSavedUp > UndoCurrent do
        table.remove(UndosSavedUp)
    end

    table.insert(UndosSavedUp, undoFunction)
    UndoCurrent = UndoCurrent+1
end

function UndoService.Clear()
    table.clear(UndosSavedUp)
    UndoCurrent = 0
end

return UndoService