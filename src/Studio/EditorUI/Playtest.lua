local Playtest = {}
local Tween = Runtime.Services.Service("TweenService")

local PlayLine
function Playtest.Init()
    print("Cooooooooooooooooooooooooool")
    PlayLine = Studio.Components.CreateStyle("Square", {
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Parent = Runtime.Things.RenderRoot,
        Layer = 999,
        BackgroundTransparency = 1,
        OutlineColor = "Selecting",
        OutlineSize = 0
    })
end

function Playtest.StartPlayline()
    Tween.Create(PlayLine, {OutlineSize = 10}, Enum.EasingStyle.SineIn, .2).Play()
end

function Playtest.EndPlayline()
    Tween.Create(PlayLine, {OutlineSize = 0}, Enum.EasingStyle.SineOut, .2).Play()
end

return Playtest