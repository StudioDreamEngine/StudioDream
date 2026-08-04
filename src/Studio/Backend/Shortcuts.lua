local Shortcuts = {}
local Input = Runtime.Services.Service("InputService")

local HandleThis = {
    ["Example"] = {
        Settings = {
            Inputs = {{Key = Enum.InputCode.LeftCtrl, Mod = true},{Key = Enum.InputCode.F}} -- For now will only suport as the first key the hold, and second as the presser one, sorrey!!
        },
        Function = function()
            print("Hello")
        end,
    },
    ["Undo"] = {
        Settings = {
            Inputs = {{Key = Enum.InputCode.LeftCtrl, Mod = true},{Key = Enum.InputCode.Z}}
        },
        Function = function()
            Studio.History.Undo()
        end,
    },
    ["Doit"] = {
        Settings = {
            Inputs = {{Key = Enum.InputCode.LeftCtrl, Mod = true},{Key = Enum.InputCode.Y}}
        },
        Function = function()
            Studio.History.DoIt()
        end,
    }
}

local function BuildKeyTable(Inputs)
    local TableToBuild = {
        Modifiers = {},
        Normal = nil
    }
    for _,Key in pairs(Inputs) do
        if Key.Mod then
            table.insert(TableToBuild.Modifiers,Key.Key)
        else
            TableToBuild.Normal = Key.Key
        end
    end
    return TableToBuild
end

function Shortcuts.Init()
    for Name,ShortcutObj in pairs(HandleThis) do
        Input.KeyEvent:Connect(function(DidItBegan,Key)
            if DidItBegan then
                local BuildedTable = BuildKeyTable(ShortcutObj.Settings.Inputs)
                local Is = {ModifiersOn = false, NormalOn = false}

                -- God this is probably the worse handle thing but okay

                for Key,_ in pairs(BuildedTable.Modifiers) do
                    Key = Input:KeyDown(Key)
                end

                for i, KeyPress in pairs(BuildedTable.Modifiers) do
                    if not KeyPress then
                        Is.ModifiersOn = false
                        return
                    else
                        Is.ModifiersOn = true
                    end
                end
                
                if Is.ModifiersOn and Key == BuildedTable.Normal then
                    ShortcutObj.Function()
                end
            end
        end)
    end
end

return Shortcuts