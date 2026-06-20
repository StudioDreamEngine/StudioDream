local Notify = {}
local Things = Runtime.Things
local ToTransparency = {
    ["Text"] = {ForegroundTransparency = 1},
    ["Image2D"] = {ForegroundTransparency = 1},
}
local Tween = Runtime.Services.Service("TweenService")
function Notify.Notify(Message,Type)
    local Window = Things.Create("Square") { 
        Size = Pivot2D.FromScale(1,0.07),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        --Parent = Notify.Container,
        CornerRadius = 5,
    }
    local NotifyImage = Things.Create("Image2D") {
        Size = Pivot2D.FromScale(.35,.35),
        Layer = 2,
        Pivot = Vector2.new(0,.5),
        Resource = "Internal/Icons/Engine/Notify/"..Type..".png",
        Position = Pivot2D.FromScale(.5,.5),
        SquareAxis = Enum.SquareAxis.Y,
        Parent = Window
    }
    local Text = Things.Create("Text") {
        Size = Pivot2D.FromScale(0.3,0.5),
        Layer = 2,
        Pivot = Vector2.new(0,.5),
        Position = Pivot2D.FromScale(.6,.5),
        Text = Message,
        Parent = Window,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text2
    }
    Utils.DebrisThing(Window,5)
    Scheduler.DelayTask(4.5,function()
        Tween.Create(Window, {BackgroundTransparency = 1,CornerRadius = 0}, Enum.EasingStyle.Linear, .2).Play()
        for i,v in pairs(Window:GetChildren()) do
            Tween.Create(v, ToTransparency[v.ClassName], Enum.EasingStyle.Linear, .2).Play()
        end
    end)
    Window:SetParent(Notify.Container)
end

function Notify.Init()
    Notify.FullContainer.BackgroundTransparency = 1
    Notify.FullContainer.OutlineSize = 0
    Notify.Container.BackgroundTransparency = 1
    Things.Create("ListLayout") {
        Parent = Notify.Container,
        Alignment = Vector2.new(0,1),
        Padding = 5
    } 
    Notify.Notify("Studio Loaded.","Info")
end

return Notify