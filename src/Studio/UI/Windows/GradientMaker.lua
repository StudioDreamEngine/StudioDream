local Things = Runtime.Things
local Components = Studio.Components

local GradientButton
local Sequence = GradientSequence.DefaultSequence()

return function(GradientMaker)

    GradientMaker.CurrentColor = Color.new(1,0,0)
    
    GradientMaker.KeysAdded = {}

    GradientMaker.LastKey = nil

    function GradientMaker.ClearKeys()
        GradientMaker.LastKey = nil

        for _,v in ipairs(GradientMaker.KeysAdded) do
            v.Slider:Destroy()
        end

        table.clear(GradientMaker.KeysAdded)

        Sequence = GradientSequence.DefaultSequence()
        GradientButton:SetGradient(Sequence)
    end

    function GradientMaker.LoadPreset(NewSequence)
        GradientMaker.ClearKeys()
        Sequence = NewSequence

        GradientMaker.RotationTime.Input:SetText(tostring(math.deg(NewSequence.Rotation)))

        for _, v in ipairs(NewSequence.GetKeys()) do
            GradientMaker.AddKey(v[1], v[2], v)
        end

        GradientButton:SetGradient(Sequence)
    end

    function GradientMaker.SetLastKey(Key)
        if GradientMaker.LastKey then
           GradientMaker.LastKey.Choose:SetVisible(false) 
           GradientMaker.LastKey.Slider:SetLayer(1)
        end
        GradientMaker.LastKey = Key
        GradientMaker.CurrentKeyColorShow.BackgroundColor = Key.ArrowChoose.ForegroundColor
        Key.Slider:SetLayer(2)
        Key.Choose:SetVisible(true)
    end
    
   function GradientMaker.AddKey(InicialTime, ColorAdded, LoadedPreset, Active)
        local RawKey
        local KeyID

        if LoadedPreset then
            RawKey = LoadedPreset
            KeyID = RawKey[3]
        else
            RawKey = GradientSequence.NewKey(InicialTime, ColorAdded)
            KeyID = Sequence.AddKey(RawKey)
        end

        if InicialTime == 1 or InicialTime == 0 then
            Active = false
        end

        if Active == true or Active == false then
        else
            Active = true
        end

        local KeyObject = {}

        KeyObject.KeyID = KeyID
        KeyObject.RawID = Sequence.GetKeyByID(KeyObject.KeyID)

        KeyObject.Slider = Studio.Components.CreateStyle("SlideBar",{
            Size = Pivot2D.FromScale(.03,.15),
            Pivot = Vector2.new(0.5,0),
            Position = Pivot2D.FromScale(0,1),
            Parent = GradientButton,
            BackgroundColor = Color.new(0),
            BackgroundTransparency = 0.9,
            CanMove = Active,
            SinkHovering = true,
            Layer = 1,
            --SlideAxis = Enum.SlideAxis.Y,
        })
        
        GradientMaker.CurrentKeyTime.Input:SetText(tostring(math.dotround(InicialTime)))

        KeyObject.ArrowChoose = Studio.Components.CreateStyle("Image2D",{
            Size = Pivot2D.FromScale(1.2,1.2),
            Pivot = Vector2.new(0.5,1),
            Position = Pivot2D.FromScale(0.5,1),
            Parent = KeyObject.Slider,
            ForegroundColor = ColorAdded,
            BackgroundTransparency = 1,
            Resource = "Internal/Studio/GradientChooser.png",
            --SlideAxis = Enum.SlideAxis.Y,
        })

        KeyObject.Choose = Studio.Components.CreateStyle("Image2D",{
            Size = Pivot2D.FromScale(1.2,1.2),
            Pivot = Vector2.new(0.5,1),
            Position = Pivot2D.FromScale(0.5,1),
            Parent = KeyObject.Slider,
            ForegroundColor = ColorAdded,
            BackgroundTransparency = 1,
            ForegroundColor = Color.new(0.2,0.2,0.2),
            Visible = false,
            Resource = "Internal/Studio/GradientChooser_Choosen.png",
            --SlideAxis = Enum.SlideAxis.Y,
        })

        function KeyObject.ChangeColor(NewColor)
            --Sequence.GetKeys()[KeyObject.RawID][2] = NewColor
            Sequence.ChangeColorOf(KeyObject.KeyID,NewColor)
            KeyObject.ArrowChoose.ForegroundColor = NewColor
            if GradientMaker.LastKey==KeyObject then
                GradientMaker.CurrentKeyColorShow.BackgroundColor = KeyObject.ArrowChoose.ForegroundColor
            end
        end

        function KeyObject.Destroy()
            if not Active then return end
            GradientMaker.CurrentKeyTime.Input:SetText(tostring(0))
            KeyObject.Slider:Destroy()
            table.remove(GradientMaker.KeysAdded,table.find(GradientMaker.KeysAdded,KeyObject))
            Sequence.RemoveKeyByID(KeyObject.KeyID)
            Sequence.ProcessUniforms()
        end

        function KeyObject.ChangeTime(NewTime)
            KeyObject.Slider:SetPercentage(NewTime)
            Sequence.GetKeyByID(KeyObject.KeyID)[1] = NewTime
            Sequence.ProcessUniforms()

            if GradientMaker.LastKey == KeyObject then
                GradientMaker.CurrentKeyTime.Input:SetText(tostring(math.dotround(KeyObject.Slider.Percentage)))
            end

            GradientButton:SetGradient(Sequence)
        end

        KeyObject.Slider.ChangedPercentage:Connect(function()

            Sequence.GetKeyByID(KeyObject.KeyID)[1] = KeyObject.Slider.Percentage
            Sequence.ProcessUniforms()

            if GradientMaker.LastKey == KeyObject then
                GradientMaker.CurrentKeyTime.Input:SetText(tostring(math.dotround(KeyObject.Slider.Percentage)))
            end

            GradientButton:SetGradient(Sequence)
        end)
        
        KeyObject.StartConnect = KeyObject.Slider.StartHolding:Connect(function()
            GradientMaker.SetLastKey(KeyObject)
        end)

        KeyObject.Slider:SetPercentage(InicialTime)
        GradientButton:SetGradient(Sequence)

        table.insert(GradientMaker.KeysAdded,KeyObject)

        GradientMaker.SetLastKey(KeyObject)

        if InicialTime == 1 or InicialTime == 0 then
            KeyObject.ChangeColor(ColorAdded)
        end

        return KeyObject
    end

    function GradientMaker.StartGradientColorHandle()
        --[[GradientMaker.AddKey(1,Color.new(1),false)
        GradientMaker.AddKey(0,Color.new(1),false)]]

        GradientButton.Clicked:Connect(function()
            local MousePos = Runtime.Backend2D.GetMousePosition().X
            --local Percentage = math.clamp(((MousePos-GradientButton.AbsolutePosition.X)/GradientButton.AbsoluteSize.X),0,1)
            local SidePosition = MousePos-GradientButton.AbsolutePosition.X/2
            local Percentage = math.clamp(SidePosition/GradientButton.AbsoluteSize.X,0,1)-0.03
            GradientMaker.AddKey(Percentage,GradientMaker.CurrentColor)
        end)
    end

    function GradientMaker.Init()
        GradientButton = Studio.Components.CreateStyle("TextButton",{
            Size = Pivot2D.FromScale(0.95,0.65),
            Pivot = Vector2.new(0.5,0),
            Position = Pivot2D.FromScale(0.5,0.05),
            Parent = GradientMaker.Container,
            BackgroundColor = Color.new(1),
            CornerRadius = 10,
            Text = "",
            SinkHovering = true,
            ClickingColorMultiplier = 1,
            HoverColorMultiplier = 1,
        })
        local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(0.4,0.2), GradientMaker.Container)
        
        GradientMaker.DeleteButton = Studio.Components.CreateButtonStyle({
            Position = Pivot2D.FromScale(0.41,0.9),
            Size = Pivot2D.FromScale(0.14,.1),
            Pivot = Vector2.new(0,0.5),
            Parent = GradientMaker.Container,
            Text = "Delete key"
        })

        GradientMaker.ColorButton = Studio.Components.CreateButtonStyle({
            Position = Pivot2D.FromScale(0.25,0.9),
            Size = Pivot2D.FromScale(0.14,.1),
            Parent = GradientMaker.Container,
            Pivot = Vector2.new(0,0.5),
            Text = "Color"
        })

        GradientMaker.ConfirmButton = Studio.Components.CreateButtonStyle({
            Position = Pivot2D.FromScale(0.95,0.9),
            Size = Pivot2D.FromScale(0.17,.11),
            Pivot = Vector2.new(1,0.5),
            Parent = GradientMaker.Container,
            Text = "Done"
        })

        GradientMaker.Cancel = Studio.Components.CreateButtonStyle({
            Position = Pivot2D.FromScale(0.77,0.9),
            Size = Pivot2D.FromScale(0.17,.11),
            Pivot = Vector2.new(1,0.5),
            Parent = GradientMaker.Container,
            Text = "Cancel"
        })

        GradientMaker.CurrentKeyColorShow = Studio.Components.CreateStyle("Square",{
            Size = Pivot2D.FromScale(1,1),
            Pivot = Vector2.new(0,0),
            Position = Pivot2D.FromScale(0,0),
            SquareAxis = Enum.SquareAxis.Y,
            BackgroundTransparency = 0,
            Layer = 2,
            BackgroundColor = Color.new(0.5,0.5,0.5),
            CornerRadius = 100,
            Parent = GradientMaker.ColorButton.Button,
        })

        GradientMaker.CurrentKeyTime = Studio.Components.StockVisuals:CreateTimerInput(GradientMaker.Container,{
            Position = Pivot2D.FromScale(0.08,0.9),
            Size = Pivot2D.FromScale(0.055,.11),
            Pivot = Vector2.new(0,0.5),
            Parent = GradientMaker.Container,
            ForegroundColor = "Text",
            BackgroundTransparency = 0,
            BackgroundColor = "Outline",
            CornerRadius = 5,
            Title = "Time:",
            Text = "0",
            Alignment = Enum.Alignment.TopCenter
        })

        GradientMaker.RotationTime = Studio.Components.StockVisuals:CreateTimerInput(GradientMaker.Container,{
            Position = Pivot2D.FromScale(0.19,0.9),
            Size = Pivot2D.FromScale(0.055,.11),
            Pivot = Vector2.new(0,0.5),
            Parent = GradientMaker.Container,
            ForegroundColor = "Text",
            BackgroundTransparency = 0,
            BackgroundColor = "Outline",
            CornerRadius = 5,
            Title = "Rot:",
            Text = tostring(Sequence.Rotation),
            Alignment = Enum.Alignment.TopCenter
        })
        
        GradientMaker.CurrentKeyTime.Input.FocusEnd:Connect(function()
            if GradientMaker.LastKey then
                local Number = tonumber(GradientMaker.CurrentKeyTime.Input.Text)
                if Number then
                    GradientMaker.LastKey.ChangeTime(Number)
                end
            end
        end)

        GradientMaker.DeleteButton.Clicked:Connect(function()
            if GradientMaker.LastKey then
                GradientMaker.LastKey.Destroy()
                GradientMaker.LastKey = nil
            end
        end)

        GradientMaker.RotationTime.Input.FocusEnd:Connect(function()
            local Numbered = tonumber(GradientMaker.RotationTime.Input.Text)
            if Numbered then
                Sequence.SetRotation(math.rad(Numbered))
            end
        end)

        GradientMaker.ColorButton.Clicked:Connect(function()
            if GradientMaker.LastKey then
                Studio.Layout.CallHandle("Windows.ColorPicked", "RequestApply", ColorOfThings, function(ReturnedColor)
                    GradientMaker.LastKey.ChangeColor(ReturnedColor)
                end)
            end
        end)

        GradientMaker.StartGradientColorHandle()
    end

    function GradientMaker.Hide()
        Studio.Layout.ToggleWindow(Studio.Layout.GetHandle("Windows.GradientMaker"),false)
    end

    function GradientMaker.Request(InicialSequence,Function)
        --print(InicialSequence,Function)
        print(InicialSequence.GetKeys())
        GradientMaker.LoadPreset(InicialSequence)
        Studio.Layout.ToggleWindow(Studio.Layout.GetHandle("Windows.GradientMaker"),true)
        GradientMaker.ConfirmButton.Clicked:Connect(function()
            GradientMaker.Hide()
            --print(Sequence.GetKeys())
            Function(Sequence)
        end)
    end

    function GradientMaker.Update(dt)
    
    end
    return GradientMaker
end