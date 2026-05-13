local TopBar = {}
local Components = Studio.Components
local Things = Runtime.Things

local Tabs = require("Studio.UI.TopBar.Tabs") -- God this indexing is killing me

function TopBar.ChangeTab(TabName)
    
end

function TopBar.Init(WindowContainer)
    TopBar.TabsMenu = Components.CreateStyle("Square", {
        Position = Pivot2D.FromScale(0,0),
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,0.3),
        Parent = WindowContainer
    })

    Things.Create("ListLayout") {
        Alignment = Enum.AlignmentX.Center,
        Direction = Enum.LayoutDirection.Horizontal,
        Parent = TopBar.TabsMenu
    }

    Studio.Components.CreateButton("Test", function()
        
    end, {
        Parent = TopBar.TabsMenu,
        Size = Pivot2D.FromScale(0.1,0.8)
    })


    TopBar.TabContainer = Components.CreateStyle("Square", {
        Position = Pivot2D.FromScale(0,0.3),
        Size = Pivot2D.FromScale(1,0.7),
        BackgroundTransparency = 1,
        Parent = WindowContainer
    })
end

return TopBar