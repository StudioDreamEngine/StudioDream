local CurrentWindow = nil

return function(Options)
    local Object = {}

    if (not Options.Choices) then
        Options.Choices = {
            {
                Text = "Ok"
            }
        }
    end

    function Object.CreateDialog()
        Runtime.Things.Create("Text") {
            Size = Pivot2D.FromScale(1,0.1),
            Position = Pivot2D.FromScale(0.5,0.01),
            Pivot = Vector2.new(0.5,0),
            Parent = Object.Container,
            Text = Options.Text,
            BackgroundTransparency = 1,
            ForegroundColor = Studio.Theme.Text,
            Name = "WindowText",
            Alignment = Vector2.new(0.5,0.5)
        }

        local OptionsContainer = Runtime.Things.Create("Square") {
            Size = Pivot2D.FromScale(1,0.5) ,
            Position = Pivot2D.FromScale(0.5,1),
            Pivot = Vector2.new(0.5,1),
            Name = "BackWindow",
            Layer = 2,
            Parent = Object.Container,
            BackgroundTransparency = 1,
            CornerRadius = 2.5,
        }
        
        Runtime.Things.Create("ListLayout") {
            Parent = OptionsContainer,
            Alignment = Vector2.new(0.5,0.5),
            Direction = Enum.LayoutDirection.Horizontal,
            Padding = 10,
        }

        for i,v in pairs(Options.Choices) do
            local ThisButton = Runtime.Things.Create("TextButton") {
                Size = Pivot2D.FromScale(0.4,0.4) ,
                BackgroundColor = Studio.Theme.Secondary,
                ForegroundColor = Studio.Theme.Text,
                Name = "BackWindow",
                Alignment = Vector2.new(0.5,0.5),
                Layer = 2,
                Text = v.Text,
                Parent = OptionsContainer,
                BackgroundTransparency = 0,
                CornerRadius = 2.5,
                OutlineSize = 2,
                OutlineColor = Studio.Theme.Outline
            }

            ThisButton.Clicked:ConnectOnce(function()
                if v.OnClick then
                    v.OnClick()
                end

                Object.Close()
            end)
        end 
    end

    function Object.Update()
        
    end

    return Object
end