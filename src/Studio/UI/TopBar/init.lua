local TopBar = {}
local Components = Studio.Components
local Things = Runtime.Things

local TabsList = require("Studio.UI.TopBar.Tabs") -- God this indexing is killing me
local Tabs = {}

function TopBar.ChangeTab(TabName)

end

function TopBar.CreateTab(TabName, Tab)
    -- Adds to tab list - This is sorta temporary unless we plan to not allow for customization
    Studio.Components.CreateButton(TabName, {
        Parent = TopBar.TabsMenu,
        Size = Pivot2D.FromScale(0.1,0.8),
        Clicked = function()
            TopBar.ChangeTab(TabName)
        end
    })

    Tabs[TabName] = {}

    local TabContainer = Things.Create("Square") {
        Size = Pivot2D.FromScale(1,1),
        BackgroundTransparency = 1
    }

    for _, Item in pairs(Tab) do
        local Component = Item.Component

        
    end
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

    TopBar.TabContainer = Components.CreateStyle("Square", {
        Position = Pivot2D.FromScale(0,0.3),
        Size = Pivot2D.FromScale(1,0.7),
        BackgroundTransparency = 1,
        Parent = WindowContainer
    })

    for TabName, Tab in pairs(TabsList) do
        TopBar.CreateTab(TabName, Tab)
    end
end

return TopBar