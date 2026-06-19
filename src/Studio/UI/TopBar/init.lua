local TopBar = {}
local Components = Studio.Components
local Things = Runtime.Things

local TabsList = require("Studio.UI.TopBar.Tabs") -- God this indexing is killing me
local Tabs = {}

function TopBar.ChangeTab(TabName)
    for _, Tab in pairs(Tabs) do
        Tab:SetVisible(false)
    end

    Tabs[TabName]:SetVisible(true)
end

function TopBar.GetTool(Tool)
    return require("Studio.UI.TopBar.Tools."..Tool)
end

function TopBar.CreateTab(TabName, Tab)
    -- Adds to tab list - This is sorta temporary unless we plan to not allow for customization (Still deciding on this, probably not 🔥)
    Studio.Components.CreateButton(TabName, {
        Parent = TopBar.TabsMenu,
        Size = Pivot2D.FromScale(0.1,0.8),
        Clicked = function()
            TopBar.ChangeTab(TabName)
        end
    })

    local SingleTab = Things.Create("Square") {
        Size = Pivot2D.new(-12,1,-12,1),
        Pivot = Vector2.one * .5,
        Position = Pivot2D.FromScale(.5,.5),
        BackgroundTransparency = 1,
        Parent = TopBar.TabContainer
    }

    Things.Create("ListLayout") {
        Direction = Enum.LayoutDirection.Horizontal,
        Parent = SingleTab,
        Padding = 5
    }

    for Order, Item in pairs(Tab) do
        if type(Item) == "table" then
            local Component = Item.Component
            local Tool = TopBar.GetTool(Component)(Item.Arguments)

            Tool.ListOrder = Order
            Tool:SetParent(SingleTab)
        end
    end

    Tabs[TabName] = SingleTab
end

function TopBar.Init()
    TopBar.TabsMenu = Components.CreateStyle("Square", {
        Position = Pivot2D.FromScale(0,0),
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,0.3),
        Parent = TopBar.Container
    })

    Things.Create("ListLayout") {
        Alignment = Enum.Alignment.Center,
        Direction = Enum.LayoutDirection.Horizontal,
        Parent = TopBar.TabsMenu
    }

    TopBar.TabContainer = Components.CreateStyle("Square", {
        Position = Pivot2D.FromScale(0,0.3),
        Size = Pivot2D.FromScale(1,0.7),
        BackgroundTransparency = 1,
        Parent = TopBar.Container
    })
    
    for i = 1, Utils.CountTable(TabsList) do
        for TabName, Tab in pairs(TabsList) do
            if Tab.Order == i then
                TopBar.CreateTab(TabName, Tab)
            end
        end
    end
    for i, Tab in pairs(Tabs) do
        if i ~= "General" then Tab:SetVisible(false) end
    end
end

return TopBar