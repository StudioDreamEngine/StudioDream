local TopBar = {}
local Components = Studio.Components
local Things = Runtime.Things

local ButtonList = require("Studio.UI.MenuBar.TopButtons")
local RequiredButtons = {}

function TopBar.CreateButton(Table)
    if not RequiredButtons[Table.Component] then
        local ButtonsOnTopThing = require("Studio.UI.MenuBar.ButtonsOnTop."..Table.Component)
        RequiredButtons[Table.Component] = ButtonsOnTopThing
    end
    
    local Button = RequiredButtons[Table.Component](Table.Arguments)
    Button:SetParent(TopBar.TopperBarContainer)
end

function TopBar.Init()
    TopBar.TopperBarContainer = Components.CreateStyle("Square", {
        Size = Pivot2D.FromScale(1,1),
        BackgroundTransparency = 1,
        Parent = TopBar.Container
    })

    Things.Create("ListLayout") {
        Alignment = Enum.Alignment.MiddleLeft,
        Direction = Enum.LayoutDirection.Horizontal,
        Parent = TopBar.TopperBarContainer,
        Padding = 2,
    }

    for i,Tab in pairs(ButtonList) do
        TopBar.CreateButton(Tab)
    end
end

return TopBar