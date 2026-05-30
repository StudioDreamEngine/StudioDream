local CurrentWindow = nil

return function(Text,Options)
    local Windows = {}
    if CurrentWindow then CurrentWindow:Destroy() end

    Windows.Container = Runtime.Things.Create("Square") { 
        Size = Pivot2D.FromScale(0.4,0.3),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Studio.Theme.Secondary,
        Name = "WindowContainer",
        Layer = 999,
        Parent = Runtime.Things.Root.RootViewport,
        CornerRadius = 5,
        OutlineSize = 5,
        OutlineColor = Studio.Theme.Outline
    }
    
    Windows.BackWindow = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.99,0.99) ,
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Studio.Theme.Primary,
        Name = "BackWindow",
        Layer = 2,
        Parent = Windows.Container,
        CornerRadius = 2.5,
    }

    --[[Windows.Text = Runtime.Things.Create("Text") {
        Size = Pivot2D.FromScale(1,0.5),
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text,
        Text = Text,
        Layer = 3,
        Parent = Windows.BackWindow,
    }]]

    Windows.Options = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(1,0.5) ,
        Position = Pivot2D.FromScale(0.5,1),
        Pivot = Vector2.new(0.5,1),
       -- BackgroundColor = Studio.Theme.Primary,
        Name = "BackWindow",
        Layer = 2,
        Parent = Windows.BackWindow,
        BackgroundTransparency = 1,
        CornerRadius = 2.5,
        Serializable = false
    }
    Runtime.Things.Create("ListLayout") {
        Parent = Windows.Options,
        Alignment = Vector2.new(0.5,0.5),
        Direction = Enum.LayoutDirection.Horizontal,
        Padding = 10,
    }
    for i,v in pairs(Options) do
        local ThisButton = Runtime.Things.Create("TextButton") {
            Size = Pivot2D.FromScale(0.4,0.4) ,
           -- Position = Pivot2D.FromScale(0.5,1),
           -- Pivot = Vector2.new(0.5,1),
            BackgroundColor = Studio.Theme.Secondary,
            ForegroundColor = Studio.Theme.Text,
            Name = "BackWindow",
            Alignment = Vector2.new(0.5,0.5),
            Layer = 2,
            Text = v.Text,
            Parent = Windows.Options,
            BackgroundTransparency = 0,
            CornerRadius = 2.5,
            Serializable = false,
            OutlineSize = 2,
            OutlineColor = Studio.Theme.Outline
        }

        ThisButton.Clicked:ConnectOnce(function()
            if v.OnClick then
                v.OnClick()
            end
            Windows.Container:Destroy()
        end)
    end

    CurrentWindow = Windows.Container
end