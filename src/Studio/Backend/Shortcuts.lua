local Shortcuts = {}
local Input = Runtime.Services.Service("InputService")

local InputsSaved = {
    ["Undo"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.Z,
    },
    --[[["Example"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.F,
    },]]
    ["SnapToPart"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.F,
    },
    ["Doit"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.Y,
    },
    ["Move"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.One,
    },
    ["Scale"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.Two,
    },
    ["Rotate"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.Three,
    },
    ["Duplicate"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.D,
    },
    ["Group"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.G,
    },
    ["UnGroup"] = {
        First = Enum.InputCode.LeftCtrl,
        Second = Enum.InputCode.U,
    },
    ["Delete"] = {
        First = Enum.InputCode.Delete,
    },
}

local HandleThis = {
    --[[["Example"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.Example.First, Mod = true},{Key = InputsSaved.Example.Second}} -- For now will only suport as the first key the hold, and second as the presser one, sorrey!!
        },
        Function = function()
            print("Hello")
        end,
    },]]
    ["SnapToPart"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.SnapToPart.First, Mod = true},{Key = InputsSaved.SnapToPart.Second}}
        },
        Function = function()
            Studio.Editor3D.ZoomTo()
        end,
    },
    ["Undo"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.Undo.First, Mod = true},{Key = InputsSaved.Undo.Second}}
        },
        Function = function()
            Studio.History.Undo()
        end,
    },
    ["Doit"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.Doit.First, Mod = true},{Key = InputsSaved.Doit.Second}}
        },
        Function = function()
            Studio.History.DoIt()
        end,
    },
    ["Move"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.Move.First, Mod = true},{Key = InputsSaved.Move.Second}}
        },
        Function = function()
            Studio.Layout.CallHandle("Toolbar", "SelectTool", "Move")
        end
    },
    ["Scale"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.Scale.First, Mod = true},{Key = InputsSaved.Scale.Second}}
        },
        Function = function()
            Studio.Layout.CallHandle("Toolbar", "SelectTool", "Scale")
        end
    },
    ["Rotate"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.Rotate.First, Mod = true},{Key = InputsSaved.Undo.Second}}
        },
        Function = function()
            Studio.Layout.CallHandle("Toolbar", "SelectTool", "Rotate")
        end
    },
    ["Duplicate"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.Duplicate.First, Mod = true},{Key = InputsSaved.Duplicate.Second}}
        },
        Function = function()
            Studio.Editor3D.SelectionManager.DuplicateAll()
            --Studio.Layout.CallHandle("Explorer", "Redraw")
        end,
    },
    ["Delete"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.Delete.First}}
        },
        Function = function()
            Studio.Editor3D.SelectionManager.DeleteAll()
            --Studio.Layout.CallHandle("Explorer", "Redraw")
        end,
    },
    ["Group"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.Group.First, Mod = true},{Key = InputsSaved.Group.Second}}
        },
        Function = function()
            Studio.Editor3D.SelectionManager.GroupAll()
            --Studio.Layout.CallHandle("Explorer", "Redraw")
        end,
    },
    ["UnGroup"] = {
        Settings = {
            Inputs = {{Key = InputsSaved.UnGroup.First, Mod = true},{Key = InputsSaved.UnGroup.Second}}
        },
        Function = function()
            Studio.Editor3D.SelectionManager.UngroupAll()
            --Studio.Layout.CallHandle("Explorer", "Redraw")
        end,
    },
}

local function BuildKeyTable(Inputs)
    local TableToBuild = {
        Modifiers = {},
        Normal = nil
    }

    for _,Key in pairs(Inputs) do
        if Key.Mod then
            TableToBuild.Modifiers[Key.Key] = false
        else
            TableToBuild.Normal = Key.Key
        end
    end
    
    return TableToBuild
end

function Shortcuts.GetKeys()
    return HandleThis
end

function Shortcuts.SetInput(Name,WhatOrder,NewBind)
    InputsSaved[Name][WhatOrder] = NewBind
    Shortcuts.Save()
end

function Shortcuts.GetInput(Name)
    return InputsSaved[Name]
end

function Shortcuts.GetInputs()
    return InputsSaved
end

function Shortcuts.Save()
    Runtime.SettingsManager.ChangeSetting("ShortcutsTable",InputsSaved)
end

function Shortcuts.BuildFromSavedTable()
    if Runtime.SettingsManager.GetSetting("ShortcutsTable") then
        local NewTable = Runtime.SettingsManager.GetSetting("ShortcutsTable")

        for Name,Inputs in pairs(InputsSaved) do
            if (not NewTable[Name]) then
                NewTable[Name] = Inputs
            end
        end

        Runtime.SettingsManager.ChangeSetting("ShortcutsTable",NewTable)
    else
        return InputsSaved
    end
end

function Shortcuts.Init()
    Shortcuts.BuildFromSavedTable()

    InputsSaved = Runtime.SettingsManager.GetSetting("ShortcutsTable") or InputsSaved

    for Name,ShortcutObj in pairs(HandleThis) do
        Input.KeyEvent:Connect(function(DidItBegan,Key)
            if DidItBegan then
                local BuildedTable = BuildKeyTable(ShortcutObj.Settings.Inputs)
                local Is = {ModifiersOn = false, NormalOn = false}

                -- God this is probably the worse handle thing but okay
                for Key,_ in pairs(BuildedTable.Modifiers) do
                    BuildedTable.Modifiers[Key] = Input.KeyDown(Key)
                end

                for i, KeyPress in pairs(BuildedTable.Modifiers) do
                    if not KeyPress then
                        Is.ModifiersOn = false
                        return
                    else
                        Is.ModifiersOn = true
                    end
                end
                
                if Is.ModifiersOn == true and Key == BuildedTable.Normal then
                    ShortcutObj.Function()
                end
            end
        end)
    end
end

-- why are there 2 functions that do the same thing... BUDDY!!!
function Shortcuts.ChangeKeybind(Name,Key,Number)

end

return Shortcuts