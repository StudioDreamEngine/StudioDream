local Things = Runtime.Things
local Components = Studio.Components

local Credits = {}

Credits.Container = nil ---@class Square

local CreditsDisplay = {
    {
        Name = "StudioDream",
        Content = {
            "Bloctans - Basically made everything possible",
            "Mikl - Studio Interface, Graphics, General Support, Mascot Desing and Modelling",
            "Sonickirb - General Support"
        }
    },
    {
        Name = "Launcher",
        Content = {
            "Sonickirb - Creator",
            "Mikl - Windows zip export",
        }
    },
    {
        Name = "Special Thanks",
        Content = {
            "Luawiz, Emk530 - Reused code (Improved object creation, utf8sub)",
            "Sasha + LOVE server members - Misc. Support",
            "trusti - Physics engine support (bullet3)",
            "wyteroze - Suggesting I use binary search for TextScaled fitting",
            "Alecstey - NetworkService"
        }
    },
    { 
        Name = "Packages",
        Content = {
            "bakpakin/binser (Github), Licensed under MIT",
            "rxi/classic (Github), Licensed under MIT",
            "Bloctans/LuauPolyfill (Github), Licensed under MIT",
            "meepen/Lua-5.1-UTF-8 (Github), Licensed under MIT",
            "3dreamengine/3DreamEngine (Github), Licensed under MIT",
            "EngineerSmith/nativefs (Github), Licensed under MIT",
            "SwadicalRag/bullet3-lua (Github), Licensed under Zlib",
            "kikito/tween.lua (Github), Code used (Tween functions) Licensed under MIT",
            "pfirsich/lua-discordRPC (Github), Licensed under MIT",
        }
    }
}

local Scroll

function Credits.CreateName(Name)
    Studio.Components.CreateStyle("Text", {
        Size = Pivot2D.new(0.8,0,0,25),
        BackgroundTransparency = 1,
        Parent = Scroll,
        Text = Name,
        Alignment = Enum.Alignment.MiddleLeft,
        ForegroundColor = "Text",
    })
end

function Credits.CreateCategory(Name,MyTable)
    local Text=Studio.Components.CreateStyle("Text", {
        Size = Pivot2D.new(1,0,0,50),
        BackgroundTransparency = 1,
        Parent = Scroll,
        Text = Name,
        Alignment = Enum.Alignment.MiddleLeft,
        ForegroundColor = "Text",
    })

    for i,v in pairs(MyTable) do
        Credits.CreateName(v)
    end
end

function Credits.Init()
    Scroll = Things.Create("ScrollContainer") {
        Size = Pivot2D.FromScale(1,1),
        Parent = Credits.Container,
        Name = "Credits",
        CanvasSize = Pivot2D.new(1,0,0,400)
    }

    Studio.Components.CreateStyle("ListLayout", {
        Parent = Scroll,
    })

    for i,v in pairs(CreditsDisplay) do
        Credits.CreateCategory(v.Name,v.Content)
    end
end

function Credits.Update(dt)
    
end

return Credits