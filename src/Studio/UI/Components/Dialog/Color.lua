return function(Options)
    local Object = {}

    Object.FinalProject = Signal:New("ReturnedThing")

    function Object.CreateDialog()
        Runtime.Things.Create("Text") {
            Size = Pivot2D.FromScale(1,0.1),
            Position = Pivot2D.FromScale(0.5,0.01),
            Pivot = Vector2.new(0.5,0),
            Parent = Object.Container,
            Text = Options.Text,
            BackgroundTransparency = 1,
            ForegroundColor = Studio.Theme.CurrentTheme.Text,
            Alignment = Vector2.new(0.5,0.5)
        }

        Runtime.Things.Create("Text") {
            Size = Pivot2D.FromScale(0.8,0.2),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            Parent = Object.Container,
            Text = "Hello color picker still to be made so use the erm thign here!!!",
            BackgroundColor = Studio.Theme.CurrentTheme.TextInverse,
            ForegroundColor = Studio.Theme.CurrentTheme.Text,
            Alignment = Vector2.new(0.5,0.5),
            CornerRadius = 5,
        }

        Object.InputerRGB = Runtime.Things.Create("TextInput") {
            Size = Pivot2D.FromScale(0.95,0.1) ,
            BackgroundColor = Studio.Theme.CurrentTheme.Secondary,
            ForegroundColor = Studio.Theme.CurrentTheme.Text,
            Name = "BackWindow",
            Alignment = Vector2.new(0.5,0.5),
            Layer = 2,
            Text = "",
            Position = Pivot2D.FromScale(0.5,0.9),
            Pivot = Vector2.new(0.5,0.5),
            BackgroundTransparency = 0,
            CornerRadius = 2.5,
            OutlineSize = 2,
            OutlineColor = Studio.Theme.CurrentTheme.Outline,
            Parent = Object.Container
        }
        Runtime.Things.Create("Text") {
            Size = Pivot2D.FromScale(1,0.8),
            Position = Pivot2D.FromScale(0.5,-0.5),
            Pivot = Vector2.new(0.5,0.5),
            Parent = Object.InputerRGB,
            Text = "From RGB",
            BackgroundTransparency = 1,
            ForegroundColor = Studio.Theme.CurrentTheme.Text,
            Alignment = Vector2.new(0.5,0.5)
        }

        Object.InputerHEX = Runtime.Things.Create("TextInput") {
            Size = Pivot2D.FromScale(0.95,0.1) ,
            BackgroundColor = Studio.Theme.CurrentTheme.Secondary,
            ForegroundColor = Studio.Theme.CurrentTheme.Text,
            Name = "BackWindow",
            Alignment = Vector2.new(0.5,0.5),
            Layer = 2,
            Text = "",
            Position = Pivot2D.FromScale(0.5,0.7),
            Pivot = Vector2.new(0.5,0.5),
            BackgroundTransparency = 0,
            CornerRadius = 2.5,
            OutlineSize = 2,
            OutlineColor = Studio.Theme.CurrentTheme.Outline,
            Parent = Object.Container
        }
        Runtime.Things.Create("Text") {
            Size = Pivot2D.FromScale(1,0.8),
            Position = Pivot2D.FromScale(0.5,-0.5),
            Pivot = Vector2.new(0.5,0.5),
            Parent = Object.InputerHEX,
            Text = "From HEX",
            BackgroundTransparency = 1,
            ForegroundColor = Studio.Theme.CurrentTheme.Text,
            Alignment = Vector2.new(0.5,0.5)
        }

        Object.InputerHEX.FocusEnd:Connect(function()
            Object.FinalProject.Invoke("HEX",Color.FromHex(Object.InputerHEX.Text))
            Studio.Components.HideFade()
            Object.Window:Destroy()
        end)

        Object.InputerRGB.FocusEnd:Connect(function()
            Object.FinalProject.Invoke("RBG",Color.new(Object.InputerRGB.Text))
            Studio.Components.HideFade()
            Object.Window:Destroy()
        end)
    end

    function Object.Update()
        
    end

    return Object
end