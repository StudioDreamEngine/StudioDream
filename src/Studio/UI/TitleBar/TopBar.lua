return function(TopBar)
    local Components = Studio.Components
    local Things = Runtime.Things

    local ButtonList = require("Studio.UI.TitleBar.TopButtons")
    local RequiredButtons = {}

    function TopBar.CreateButton(Table)
        if not RequiredButtons[Table.Component] then
            local ButtonsOnTopThing = require("Studio.UI.TitleBar.ButtonsOnTop."..Table.Component)
            RequiredButtons[Table.Component] = ButtonsOnTopThing
        end
        
        local Button = RequiredButtons[Table.Component](Table.Arguments)
        Button:SetParent(TopBar)
    end

    function TopBar.Init()
        Things.Create("ListLayout") {
            Alignment = Enum.Alignment.MiddleLeft,
            Direction = Enum.LayoutDirection.Horizontal,
            Parent = TopBar,
            Padding = 2,
        }

        for i,Tab in pairs(ButtonList) do
            TopBar.CreateButton(Tab)
        end
    end

    return TopBar 
end