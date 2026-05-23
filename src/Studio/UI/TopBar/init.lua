local TopBar = {}
local Components = Studio.Components
local Things = Runtime.Things

local TabsList = require("Studio.UI.TopBar.Tabs") -- God this indexing is killing me
local ButtonList = require("Studio.UI.TopBar.TopButtons")
local RequiredButtons = {}
local Tabs = {}

function TopBar.ChangeTab(TabName)
    for _, Tab in pairs(Tabs) do
        Tab.Visible = false
    end

    Tabs[TabName].Visible = true
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
        local Component = Item.Component
        local Tool = TopBar.GetTool(Component)(Item.Arguments)

        Tool.ListOrder = Order
        Tool:SetParent(SingleTab)
    end

    Tabs[TabName] = SingleTab
end

function TopBar.CreateButton(Table)
    if not RequiredButtons[Table.Component] then
        local ButtonsOnTopThing = require("Studio.UI.TopBar.ButtonsOnTop."..Table.Component)
        print(ButtonsOnTopThing)
        RequiredButtons[Table.Component] = ButtonsOnTopThing
    end
    local Button = RequiredButtons[Table.Component](Table.Arguments)
    Button:SetParent(TopBar.TopperBarContainer)
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

    TopBar.TopperBarContainer = Components.CreateStyle("Square", {
        Position = Pivot2D.FromScale(0.5,0),
        Size = Pivot2D.FromScale(1,0.41),
        Pivot = Vector2.new(0.5,1),
        BackgroundTransparency = 1,
        Parent = WindowContainer
    })

    Things.Create("ListLayout") {
        Alignment = Enum.AlignmentX.Left,
        Direction = Enum.LayoutDirection.Horizontal,
        Parent = TopBar.TopperBarContainer,
        Padding = 10,
    }

    for i,Tab in pairs(ButtonList) do
        TopBar.CreateButton(Tab)
    end

    for TabName, Tab in pairs(TabsList) do
        TopBar.CreateTab(TabName, Tab)
    end
end

return TopBar