local GenConfig = {}

GenConfig.DisplayName = "General Configs"

local SavedStuff = {}

local function GenList(TableGot)
    local Choices = {}
    for i,v in pairs(TableGot) do
        table.insert(Choices, {
            Text = i,
            Type = "Button",
            Function = function()
                Studio.CurrentTheme = v
                Studio.Theme.CurrentTheme = v
                Runtime.SettingsManager.ChangeSetting("UsingTheme",i)
                Studio.Theme.ThemeChanged.Invoke()
                SavedStuff.DropdownTheme.Toggle(false)
            end
        })
    end
    return Choices
end

local ProjectOptions = {
    [1] = {
        Name = "Current Theme",
        OptionType = "Button",
        FunctionWhenCreate = function(Main)
            local Name,Info = Studio.Theme.GetCurrentThemeInfo()
            -- Create the dropdown, when choose, make everything load again maybe? :think:
            printVerbose("Theme Set", Runtime.SettingsManager.GetSetting("UsingTheme"))
            printVerbose("Theme Found", Name)
            Main.Option:SetText(Name)

            Studio.Theme.ThemeChanged:Connect(function()
                local Name,Info = Studio.Theme.GetCurrentThemeInfo()
                printVerbose("Changing Theme to", Name)
                Main.Option:SetText(Name)
            end)

            local TableBuild = GenList(Studio.Theme.GetThemes())
            --print(Studio.Theme.GetThemes())
            local Dropdown = Studio.Components.DropdownPlus.new(TableBuild,Main.Option)
            Dropdown.Toggle(false)
            SavedStuff.DropdownTheme = Dropdown
            
            Main.Option.Clicked:Connect(function()
                Dropdown.Toggle(not Dropdown.Container.Visible)
            end)
        end,
    },
    
}


function GenConfig.Create(Parent)
    local Settings = Studio.Components.Settings.new({
        {
            Title = "Theme",
            Type = "Dropdown",
            Update = function() -- Called each time the updator is called, return a text-friendly version of `Value`
                return Studio.Theme.CurrentName
            end,
            UserChange = function(Text) -- Called every time the user changes the value, its your job to take `Text` and update the corresponding `Value`
                Studio.Theme.ChangeTheme(Text)
            end,
            Choices = Studio.Theme.GetNames()
        }
    }, Parent)
end

return GenConfig