return function(Notify)
    local Times = {
        Warn = 8,
        Error = 12,
        Info = 5
    }

    local Tween = Runtime.Services.Service("TweenService")
    
    function Notify.Notify(Message,Type)

        local Window = Studio.Components.CreateStyle("Viewport2D",{
            Size = Pivot2D.FromScale(1,0.07),
            Pivot = Vector2.new(0,0.5),
            Position = Pivot2D.FromScale(0.5,0.5),
            BackgroundColor = "Outline",
            BackgroundTransparency = 0,
            CornerRadius = 5,
        })

        Tween.Create(Window, {}, Enum.EasingStyle.QuintOut, .5).Play()

        Studio.Components.CreateStyle("Image2D",{
            Size = Pivot2D.FromScale(.2,.2),
            Layer = 2,
            Pivot = Vector2.new(0,.5),
            Resource = "Internal/Studio/Notify/"..Type..".png",
            Position = Pivot2D.FromScale(.05,.5),
            SquareAxis = Enum.SquareAxis.X,
            Parent = Window
        })

        Studio.Components.CreateStyle("Text",{
            Size = Pivot2D.FromScale(0.65,0.5),
            Layer = 2,
            Pivot = Vector2.new(1,.5),
            Position = Pivot2D.FromScale(.95,.5),
            Text = Message,
            Parent = Window,
            BackgroundTransparency = 1,
            ForegroundColor = "Text"
        })

        local Time = Times[Type]

        Scheduler.DelayTask(Time - .5,function()
            Tween.Create(Window, {ForegroundTransparency = 1, BackgroundTransparency = 1, Scale = 0.75}, Enum.EasingStyle.QuintOut, .5).Play()
            Scheduler.Yield(.5)
            Window:Destroy()
        end)

        Window:SetParent(Notify.Container)
    end

    function Notify.Init()
        Notify.FullContainer.BackgroundTransparency = 1
        Notify.FullContainer.OutlineSize = 0
        Notify.Container.BackgroundTransparency = 1
        Studio.Components.CreateStyle("ListLayout",{
            Parent = Notify.Container,
            Alignment = Vector2.new(0,1),
            Padding = 5
        })
        
        Notify.Notify("Studio Loaded, Open a project or make a new one!","Info")

        if Runtime.Backend2D.UnsupportedHardware then
            Notify.Notify("StudioDream is running on unsupported hardware, we've found workarounds, but things might be broken!", "Info")
        end
    end

    return Notify 
end