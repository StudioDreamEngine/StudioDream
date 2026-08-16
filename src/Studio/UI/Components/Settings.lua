local Things = Runtime.Things

-- Container object with a list of settings, controled by PropertyValues
return { new = function(Info, Window)
    local Settings = {}
    local Tabs = {}

    function Settings.CreateChoices(Choices, Parent)
        local Scroll = Studio.Components.CreateStyle("ScrollContainer", {
            Size = Pivot2D.FromScale(1,1),
            Parent = Parent,
            BackgroundTransparency = 1,
        })

        Studio.Components.CreateStyle("ListLayout", {
            Parent = Scroll,
        })

        local PropertyList = Studio.Components.PropertyList(Pivot2D.new(1,0,0,30), Scroll)

        for _, Choice in pairs(Choices) do
            Studio.Components.PropertyValue(PropertyList, Choice)
        end

        return Scroll
    end

    function Settings.ToggleOption(Name)
        for _,Obj in pairs(Tabs) do Obj.Container:SetVisible(false) end

        if Name then Tabs[Name].Container:SetVisible(true) end
    end

    function Settings.CreateOption(Parent,Name)
        return Studio.Components.CreateStyle("TextButton", {
            Size = Pivot2D.FromScale(0.95,0.05),
            Parent = Parent,
            CornerRadius = 5,
            Clicked = function()
                Settings.ToggleOption(Name)
            end,
            BackgroundColor = "Outline",
            ForegroundColor = "Text",
            Text = Name
        })
    end

    function Settings.CreateWindow()
        local Options = Studio.Components.CreateStyle("ScrollContainer", {
            Size = Pivot2D.FromScale(0.3,0.95),
            Parent = Window.Container,
            Pivot = Vector2.new(0,0),
            BackgroundColor = "Primary",
            CornerRadius = 5,
            Position = Pivot2D.FromScale(0,0),
        })

        Studio.Components.CreateStyle("ListLayout", {
            Parent = Options,
            Alignment = Enum.Alignment.Center,
            Padding = 10,
        })

        local RenderOption = Studio.Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(0.65,1),
            Parent = Window.Container,
            CornerRadius = 5,
            Pivot = Vector2.new(1,0),
            Position = Pivot2D.FromScale(1,0),
            BackgroundColor = "Primary",
        })

        return Options, RenderOption
    end

    function Settings.Init()
        Studio.Components.RegisterToTheme(Window.Container, "BackgroundColor", "Outline")

        local TabMenu, RenderContainer = Settings.CreateWindow()
        
        for Name,Choices in pairs(Info) do
            local OptionContainer = Things.Create("Square") {
                Parent = RenderContainer,
                Size = Pivot2D.FromScale(1,1),
                BackgroundTransparency = 1
            }

            local OptionObject = {
                Button = Settings.CreateOption(TabMenu, Name),
                PropertyValue = Settings.CreateChoices(Choices, OptionContainer),
                Container = OptionContainer
            }

            Tabs[Name] = OptionObject
        end

        Settings.ToggleOption()
    end

    Settings.Init()
    return Settings
end }