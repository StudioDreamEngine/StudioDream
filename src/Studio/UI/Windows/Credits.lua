local Things = Runtime.Things
local Components = Studio.Components

local Credits = {}

Credits.Container = nil ---@class Square

local CreditsDisplay = {
    ["- General -"] = {
        "Bloctans - Basically made everything possible",
        "Mikl - UI, And other stuff",
    },
    ["- Scripting -"] = {
        "Bloctans - Basically made everything possible",
        "Mikl - UI, And other stuff",
    },
    ["- Launcher -"] = {
        "SonicKirb - Made the whole launcher",
        "Mikl - Added Windows zip export",
    }
}

function Credits.CreateName(Name,Parent)
    Studio.Components.CreateStyle("Text", {
        Size = Pivot2D.new(1,0,0.08,0),
        BackgroundTransparency = 1,
        Parent = Credits.Container,
        Text = Name,
        Alignment = Enum.Alignment.Center,
        ForegroundColor = "Text",
    })
end

function Credits.CreateCategory(Name,MyTable)
    local Text=Studio.Components.CreateStyle("Text", {
        Size = Pivot2D.FromScale(1, 0.1),
        BackgroundTransparency = 1,
        Parent = Credits.Container,
        Text = Name,
        Alignment = Enum.Alignment.Center,
        ForegroundColor = "Text",
    })
    for i,v in pairs(MyTable) do
        Credits.CreateName(v,Auto)
    end
end

function Credits.Init()
    Studio.Components.CreateStyle("ListLayout", {
            Parent = Credits.Container,
            Alignment = Enum.Alignment.Center,
            Padding = 10,
        })
    for i,v in pairs(CreditsDisplay) do
        Credits.CreateCategory(i,v)
    end
end

function Credits.Update(dt)
    
end

return Credits