return function(TitleBar)
    local Components = Studio.Components
    local Things = Runtime.Things

    function TitleBar.Init()
        TitleBar.TopBarContainer = Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(0.4,1),
            BackgroundTransparency = 1,
            Parent = TitleBar.Container,
        })

        TitleBar.Container = Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(0.6,1),
            Position = Pivot2D.FromScale(0.4,0),
            BackgroundTransparency = 1,
            Parent = TitleBar.Container,
        })

        local Visbility = Components.ExpandButton(TitleBar.Container)
        local MenuVisible = true

        Visbility.Clicked:Connect(function()
            MenuVisible = not MenuVisible

            Visbility.Toggle(MenuVisible)
            Studio.Layout.ToggleMenubar(MenuVisible)
        end)

        --[[local Title = Studio.Components.CreateStyle("Text",{
            BackgroundTransparency = 1,
            Text = love.window.getTitle(),
            Parent = TitleBar.Container,
            Alignment = Enum.Alignment.Center,
            Size = Pivot2D.FromScale(0.5,1),
            Position = Pivot2D.FromScale(-0.1,0),
            ForegroundColor = "Text",

            TextScaled = false,
            Font = "FontBold"
        })

        Runtime.Project.Config.OnChange:Connect(function()
            Title:SetText(love.window.getTitle())
        end)]]

        local TopBar = require("Studio.UI.TitleBar.TopBar")(TitleBar.TopBarContainer)
        TopBar.Init()
    end

    return TitleBar
end