return function(TitleBar)
    local Components = Studio.Components
    local Things = Runtime.Things

    function TitleBar.Init()
        TitleBar.TopBarContainer = Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(0.6,1),
            BackgroundTransparency = 1,
            Parent = TitleBar.Container
        })

        local TopBar = require("Studio.UI.TitleBar.TopBar")(TitleBar.TopBarContainer)

        TopBar.Init()
    end

    return TitleBar
end