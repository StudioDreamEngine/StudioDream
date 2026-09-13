local Things = Runtime.Things
local Components = Studio.Components

return function(ColorPicked)
    
    ColorPicked.ReturnForRequest = nil

    ColorPicked.CurrentColor = Color.FromHSV(1,1,1)
    ColorPicked.ColorInfo = {
        Hue = 1,
        Saturation = 1,
        Value = 1
    }
    function ColorPicked.SetByColor(Color)
        local FromHsv = Color.ToHVS()
        ColorPicked.ColorInfo = {Hue = FromHsv.H,Saturation = FromHsv.S,Value = FromHsv.V}
        ColorPicked.RainbowSlider:SetPercentage(ColorPicked.ColorInfo.Hue)
        ColorPicked.RainbowDragger:SetPercentage(Vector2.new(FromHsv.S,FromHsv.V))
    end

    function ColorPicked.SetCurrentColor(H,S,V)
        ColorPicked.ColorInfo = {Hue = H,Saturation = S,Value = V}
        ColorPicked.CurrentColor = Color.FromHSV(H,S,V)
        ColorPicked.ColorDisplay.BackgroundColor = ColorPicked.CurrentColor
        ColorPicked.RainbowDragger.BackgroundColor = ColorPicked.CurrentColor
        ColorPicked.RainbowDragger.OutlineColor = ColorPicked.CurrentColor.Invert()
        ColorPicked.PropertyRGB.ChangeFromOutside(ColorPicked.CurrentColor.ToRGB())
        ColorPicked.PropertyHex.ChangeFromOutside(ColorPicked.CurrentColor.ToHex())
        ColorPicked.PropertyHVS.ChangeFromOutside(ColorPicked.CurrentColor.ToHVS())
    end

    function ColorPicked.CreateColor(Type)
        local CreateCorObj = {}
        local PlaceholderType

        if Type == "RGB" or Type == "HVS" then
            PlaceholderType = "0,0,0"
        elseif Type == "Hex" then
            PlaceholderType = "#00000"
        end

        CreateCorObj.Container = Studio.Components.CreateStyle("TextButton", {
            BackgroundTransparency = 0,
            Text = Type,
            Size = Pivot2D.FromScale(0.25,0.08),
            ForegroundColor = "Text",
            Name = "Container",
            CornerRadius = 5,
            Alignment = Vector2.new(0.05,0.5),
            Parent = ColorPicked.Container
        })

        CreateCorObj.Inputer = Studio.Components.CreateStyle("TextInput", {
            Position = Pivot2D.FromScale(1,0.5),
            Pivot = Vector2.new(1,0.5),
            Alignment = Enum.Alignment.MiddleLeft,
            Size = Pivot2D.FromScale(0.5,0.85),
            ForegroundColor = "Text",
            Placeholder = PlaceholderType,
            BackgroundColor = "Outline",
            BackgroundTransparency = 0,
            Parent = CreateCorObj.Container,
        })

        CreateCorObj.ChangeFromOutside = function(Value)
            if Type == "RGB" then
                CreateCorObj.Inputer:SetText(tostring(math.dotround(Value.R))..","..math.dotround(tostring(Value.G))..","..math.dotround(tostring(Value.B)))
            elseif Type == "HVS" then
                CreateCorObj.Inputer:SetText(tostring(math.dotround(Value.H))..","..math.dotround(tostring(Value.S))..","..math.dotround(tostring(Value.V)))
            elseif Type == "Hex" then
                CreateCorObj.Inputer:SetText(Value)
            end 
        end

        CreateCorObj.Inputer.FocusEnd:Connect(function()
            print("wow")
            local ColorTyped = CreateCorObj.Inputer.Text
            if Type == "RGB" then
                ColorPicked.SetByColor(Color.FromRGB(Color.RGBFromString(ColorTyped)))
            elseif Type == "HVS" then
                local FromString = Color.HVSFromString(ColorTyped)
                ColorPicked.SetByColor(Color.FromHSV(FromString.H,FromString.S,FromString.V))
            elseif Type == "Hex" then
                ColorPicked.SetByColor(Color.FromHex(ColorTyped))
            end
        end)

        return CreateCorObj
    end

    function ColorPicked.Toggle(Visible)
        ColorPicked.Container:SetVisible(Visible)
    end

    function ColorPicked.RequestApply()
        ColorPicked.ReturnForRequest = nil
        ColorPicked.Toggle(true)

        repeat Scheduler.Yield() until ColorPicked.ReturnForRequest or ColorPicked.ReturnForRequest == false

        -- False if the user cancels the request!

        ColorPicked.Toggle(false)

        if ColorPicked.ReturnForRequest == false then
            ColorPicked.ReturnForRequest = nil
        end

        return ColorPicked.ReturnForRequest
    end

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

        ColorPicked.ColorDisplay = Studio.Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(0.1,0.1),
            Pivot = Vector2.new(0.5,0.5),
            Position = Pivot2D.FromScale(0.4,0.9),
            Parent = ColorPicked.Container,
            BackgroundTransparency = 0,
            BackgroundColor = Color.new(1,0,0,1),
            SquareAxis = Enum.SquareAxis.Y,
            OutlineSize = 5,
            OutlineColor = "Outline",
        })

        ColorPicked.ColorHVS = Studio.Components.CreateStyle("ImageButton", {
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

        ColorPicked.PropertyRGB = ColorPicked.CreateColor("RGB")
        ColorPicked.PropertyHex = ColorPicked.CreateColor("Hex")
        ColorPicked.PropertyHVS = ColorPicked.CreateColor("HVS")

        ColorPicked.PropertyRGB.Container:SetPosition(Pivot2D.FromScale(0,0.76))
        ColorPicked.PropertyHex.Container:SetPosition(Pivot2D.FromScale(0,0.84))
        ColorPicked.PropertyHVS.Container:SetPosition(Pivot2D.FromScale(0,0.92))

        ColorPicked.RainbowDragger = Studio.Components.CreateStyle("DragPoint", {
            Size = Pivot2D.FromScale(0.05,0.05),
            Pivot = Vector2.new(0.5,0.5),
            Position = Pivot2D.FromScale(0.9,0.9),
            Parent = ColorPicked.MainColor,
            BackgroundTransparency = 0,
            CornerRadius = 100,
            BackgroundColor = ColorPicked.CurrentColor,
            SquareAxis = Enum.SquareAxis.Y,
            OutlineSize = 2,
            OutlineColor = "Outline",
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

        ColorPicked.ApplyButton = Studio.Components.CreateButtonStyle({
            Position = Pivot2D.FromScale(0.8,0.9),
            Size = Pivot2D.FromScale(0.2,.1),
            Parent = ColorPicked.Container,
            Text = "Apply"
        })

        ColorPicked.CancelButton = Studio.Components.CreateButtonStyle({
            Position = Pivot2D.FromScale(0.57,0.9),
            Size = Pivot2D.FromScale(0.2,.1),
            Parent = ColorPicked.Container,
            Text = "Cancel"
        })

        ColorPicked.ColorHVS.Clicked:Connect(function()
            print("hi")
            ColorPicked.RainbowDragger.Holding = true
            ColorPicked.RainbowDragger:HandleDrag(Runtime.Backend2D.GetMousePosition())
        end)

        ColorPicked.ApplyButton.Clicked:Connect(function()
            ColorPicked.ReturnForRequest = ColorPicked.CurrentColor
        end)
        
        ColorPicked.Rainbow.Clicked:Connect(function()
            ColorPicked.RainbowSlider.Holding = true
            ColorPicked.RainbowSlider:HandleDrag(Runtime.Backend2D.GetMousePosition())
        end)

        ColorPicked.RainbowSlider.ChangedPercentage:Connect(function()
            ColorPicked.SetCurrentColor(ColorPicked.RainbowSlider.Percentage,ColorPicked.ColorInfo.Saturation,ColorPicked.ColorInfo.Value)
            ColorPicked.MainColor.BackgroundColor = Color.FromHSV(ColorPicked.RainbowSlider.Percentage,1,1)
        end)
        
        ColorPicked.RainbowDragger.ChangedPercentage:Connect(function()
            ColorPicked.SetCurrentColor(ColorPicked.ColorInfo.Hue,ColorPicked.RainbowDragger.Percentage.X,ColorPicked.RainbowDragger.Percentage.Y)
            --ColorPicked.ColorDisplay2.BackgroundColor = Color.FromHSV(ColorPicked.CurrentColor.ToHVS()[1],ColorPicked.CurrentColor.ToHVS()[2],ColorPicked.CurrentColor.ToHVS()[3])
        end)
    end

    function ColorPicked.Update(dt)
        
    end

    return ColorPicked
end