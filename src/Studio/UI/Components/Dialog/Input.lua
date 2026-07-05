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
            ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
            Name = "WindowText",
            Alignment = Vector2.new(0.5,0.5)
        }
       Object.Inputer = Runtime.Things.Create("TextInput") {
            Size = Pivot2D.FromScale(0.95,0.2) ,
            BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
            ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
            Name = "BackWindow",
            Alignment = Vector2.new(0.5,0.5),
            Layer = 2,
            Text = "",
            Position = Pivot2D.FromScale(0.5,0.6),
            Pivot = Vector2.new(0.5,0.5),
            BackgroundTransparency = 0,
            CornerRadius = 2.5,
            OutlineSize = 2,
            OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
            Parent = Object.Container
        }

        Object.Apply = Runtime.Things.Create("TextButton") {
            Size = Pivot2D.FromScale(0.7,0.15) ,
            BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
            ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
            Name = "BackWindow",
            Alignment = Vector2.new(0.5,0.5),
            Layer = 2,
            Text = "Apply",
            Position = Pivot2D.FromScale(0.5,0.9),
            Pivot = Vector2.new(0.5,0.5),
            BackgroundTransparency = 0,
            CornerRadius = 2.5,
            OutlineSize = 2,
            OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
            Parent = Object.Container
        }

        local ClickedEvent

        ClickedEvent = Object.Apply.Clicked:Connect(function()
            print("Clicked apply")
            if Object.Inputer.Text and Object.Inputer.Text ~= ("" or " ") then
                Object.FinalProject.Invoke(Object.Inputer.Text)
                ClickedEvent:Disconnect()
                Object.Window:Destroy()
            end
        end)
    end

    function Object.Update()
        
    end

    return Object
end