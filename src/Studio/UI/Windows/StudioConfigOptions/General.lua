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
                Studio.Theme.BeforeChange.Invoke()
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
            Main.Option:SetText(Name)

            Studio.Theme.ThemeChanged:Connect(function()
                local Name,Info = Studio.Theme.GetCurrentThemeInfo()
                Main.Option:SetText(Name)
            end)

            local TableBuild = GenList(Studio.Theme.GetThemes())
            print(TableBuild)
            --print(Studio.Theme.GetThemes())
            local Dropdown = Studio.Components.DropdownPlus.new(TableBuild,Main.Option)
            Dropdown.Toggle(false)
            SavedStuff.DropdownTheme = Dropdown
            
            Main.Option.Clicked:Connect(function()
                Dropdown.Toggle(not Dropdown.MajorParent.Visible)
            end)
        end,
    },
    
}


function GenConfig.Create(Parent)
    local CreateObject = {}

    print("BLEHBELH")

    Runtime.Project.LoadedProject:Connect(function()
        --print("PROJECT LOADED DUMB FUCK")
    end)

    function CreateObject.CreatePartBlock(Name,TypeOfOption,ParentS)
        local PartObj = {}

        PartObj.Base = Studio.Components.CreateStyle("Square",{
            Size = Pivot2D.FromScale(1,0.1),
            Parent =  CreateObject.Scroll,
            BackgroundTransparency = 1,
            --BackgroundColor = Studio.CurrentTheme.Outline,
            CornerRadius = 2,
        })

        PartObj.Text = Studio.Components.CreateStyle("Text", {
            Size = Pivot2D.FromScale(1,.5),
            Position = Pivot2D.FromScale(1,.5),
            Pivot = Vector2.new(1,.5),
            Parent = PartObj.Base,
            BackgroundTransparency = 1,
            ForegroundColor = "Text",
            Text = Name
        })

        PartObj.Option = Studio.Components.CreateStyle("Text"..(TypeOfOption or ""), {
            Size = Pivot2D.FromScale(0.49,.8),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0,0.5),
            BackgroundColor = "Outline",
            ForegroundColor = "Text",
            Layer = 3,
            CornerRadius = 6,
            Parent = PartObj.Base,
        })

        return PartObj
    end

    function CreateObject.CreateOptions()
        for _,Option in pairs(ProjectOptions) do
            Option.FunctionWhenCreate(CreateObject.CreatePartBlock(Option.Name,Option.OptionType,CreateObject.Scroll))
        end
    end

    function CreateObject.Create()
        CreateObject.Scroll = Studio.Components.CreateStyle("ScrollContainer",{
            Size = Pivot2D.FromScale(1,1),
            Parent = Parent,
            BackgroundTransparency = 1,
        })

        Studio.Components.CreateStyle("ListLayout",{
            Parent = CreateObject.Scroll,
        })

        CreateObject.CreateOptions()
        print(CreateObject.Scroll.Visible,CreateObject.Scroll.TruelyVisible)
    end

    CreateObject.Create()

    function CreateObject.Toggle(Visibly)
        CreateObject.Scroll:SetVisible(Visibly)
    end

    return CreateObject
end

return GenConfig