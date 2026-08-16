-- Container object with a list of settings, controled by PropertyValues
local Settings = {}

function Settings.new(Choices, Parent)
    local Scroll = Studio.Components.CreateStyle("ScrollContainer",{
        Size = Pivot2D.FromScale(1,1),
        Parent = Parent,
        BackgroundTransparency = 1,
    })

    Studio.Components.CreateStyle("ListLayout",{
        Parent = Scroll,
    })

    Runtime.Things.Create("Text") {
        Text = ":3",
        Parent = Scroll
    }

    return Scroll
end

return Settings