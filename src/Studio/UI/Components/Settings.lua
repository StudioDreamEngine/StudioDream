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

    local PropertyList = Studio.Components.PropertyList(Pivot2D.new(1,0,0,30), Scroll)

    for _, Choice in pairs(Choices) do
        local PropertyValue = Studio.Components.PropertyValue(PropertyList, Choice)
    end

    return Scroll
end

return Settings