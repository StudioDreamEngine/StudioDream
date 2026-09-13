local Things = Runtime.Things
local Components = Studio.Components

return function(ColorPicked)
    function ColorPicked.Init()
        ColorPicked.MainColor = Studio.Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(0.7,0.7),
            Pivot = Vector2.new(0.5,0.5),
            Position = Pivot2D.FromScale(0.4,0.4),
            Parent = ColorPicked.Container,
            BackgroundTransparency = 0,
            BackgroundColor = Color.new(1,0,0,1),
            SquareAxis = Enum.SquareAxis.Y,
            OutlineSize = 5,
            OutlineColor = "Outline",
        })

        Studio.Components.CreateStyle("Image2D", {
            Size = Pivot2D.FromScale(1,1),
            Pivot = Vector2.new(0.5,0.5),
            Position = Pivot2D.FromScale(0.5,0.5),
            Parent = ColorPicked.MainColor,
            BackgroundTransparency = 1,
            Resource = "Internal/ColorStuff/ColorBlackAnWhite.png",
        })

        ColorPicked.Rainbow = Studio.Components.CreateStyle("ImageButton", {
            Size = Pivot2D.FromScale(0.2,1),
            Pivot = Vector2.new(1,0.5),
            Position = Pivot2D.FromScale(1.5,0.5),
            Parent = ColorPicked.MainColor,
            BackgroundTransparency = 1,
            OutlineSize = 5,
            OutlineColor = "Outline",
            Resource = "Internal/ColorStuff/Colored.png",
        })

        ColorPicked.RainbowSlider = Studio.Components.CreateStyle("SlideBar",{
            Size = Pivot2D.FromScale(1,.015),
            Pivot = Vector2.new(0.5,0.5),
            Position = Pivot2D.FromScale(0.5,0),
            Parent = ColorPicked.Rainbow,
            BackgroundColor = Color.new(0),
            BackgroundTransparency = 0,
            Active = Active,
            SinkHovering = true,
            SlideAxis = Enum.SlideAxis.Y,
        })

        ColorPicked.Rainbow.Clicked:Connect(function()
            ColorPicked.RainbowSlider:HandleDrag(Runtime.Backend2D.GetMousePosition())
            ColorPicked.RainbowSlider.Holding = true
        end)

        ColorPicked.RainbowSlider.ChangedPercentage:Connect(function()
            print(Color.FromHSV(ColorPicked.RainbowSlider.Percentage,1,1))
            ColorPicked.MainColor.BackgroundColor = Color.FromHSV(ColorPicked.RainbowSlider.Percentage,1,1)
        end)
    end

    function ColorPicked.Update(dt)
        
    end

    return ColorPicked
end