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
    
end

function UndoService.RegisterUndo(Type,Info)
    local RegisterObject = {}

    for i,v in pairs(SavedUndoActions) do
        if i > CurrentUndo then
            SavedUndoActions[i] = nil
        end
    end

    local SavedUpFunction

    if Type == "Property" then
        SavedUpFunction = function()
            Runtime.Things.SetProperty(Info.Obj, Info.Property, Info.Val)
        end
    elseif Type == "LotsOfObjects" then
        SavedUpFunction = function()
            for i,v in pairs(Info.ObjectsToChange) do
                Runtime.Things.SetProperty(v.Obj, v.Property, v.Val)
            end
            if Info.SpecialFunction then Info.SpecialFunction() end
        end
    end
    
    CurrentUndo = CurrentUndo+1
   
    table.insert(SavedUndoActions,SavedUpFunction)

    printVerbose(CurrentUndo,SavedUndoActions)

    function RegisterObject:Cancel()
        table.remove(SavedUndoActions,table.find(SavedUndoActions,SavedUpFunction))
        CurrentUndo = CurrentUndo-1
    end

    return RegisterObject
end

function UndoService.Clear()
    table.clear(SavedUndoActions)
    CurrentUndo = 0
end

return UndoService