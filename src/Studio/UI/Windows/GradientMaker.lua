local Things = Runtime.Things
local Components = Studio.Components

local GradientButton
local Sequence = GradientSequence.NewSequence({}, 0)

return function(GradientMaker)

    GradientMaker.CurrentColor = Color.new(1,0,0)
    
    GradientMaker.KeysAdded = {}

    function GradientMaker.ClearKeys()
        table.clear(GradientMaker.KeysAdded)
        Sequence = GradientSequence.NewSequence({}, 0)
        GradientButton:SetGradient(Sequence)
    end

    function GradientMaker.LoadPreset(NewSequence)
        GradientMaker.ClearKeys()
        for i,v in pairs(NewSequence) do
            GradientMaker.AddKey(v[1],v[2])
        end
    end

    function GradientMaker.AddKey(InicialTime,ColorAdded,Active)
        local KeyObject = {}

        if Active == true or Active == false then
        else
            Active = true
        end

        KeyObject.KeyID = Sequence.AddKey(GradientSequence.NewKey(InicialTime,ColorAdded))

        KeyObject.Slider = Studio.Components.CreateStyle("SlideBar",{
            Size = Pivot2D.FromScale(.03,.15),
            Pivot = Vector2.new(0.5,0),
            Position = Pivot2D.FromScale(0,1),
            Parent = GradientButton,
            BackgroundColor = Color.new(0),
            BackgroundTransparency = 0.9,
            Active = Active,
            SinkHovering = true,
            --SlideAxis = Enum.SlideAxis.Y,
        })

        Studio.Components.CreateStyle("Image2D",{
            Size = Pivot2D.FromScale(1,1),
            Pivot = Vector2.new(0.5,1),
            Position = Pivot2D.FromScale(0.5,1),
            Parent = KeyObject.Slider,
            ForegroundColor = ColorAdded,
            BackgroundTransparency = 1,
            Resource = "Internal/Studio/GradientChooser.png",
            --SlideAxis = Enum.SlideAxis.Y,
        })

        KeyObject.Slider.ChangedPercentage:Connect(function()
            Sequence.GetKeyByID(KeyObject.KeyID)[1] = KeyObject.Slider.Percentage
            Sequence.ProcessUniforms()

            GradientButton:SetGradient(Sequence)
        end)

        KeyObject.Slider:SetPercentage(InicialTime)
        GradientButton:SetGradient(Sequence)

        table.insert(GradientMaker.KeysAdded,KeyObject)

        return KeyObject
    end

    function GradientMaker.StartGradientColorHandle()
        GradientMaker.AddKey(1,Color.new(1),false)
        GradientMaker.AddKey(0,Color.new(1),false)

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
        local PropertyVal = Studio.Components.PropertyValue(PropertyList, {
            Title = "Color",
            Type = "Input",
            Translate = "Color",
            --StyleSelect = true,
            UserChange = function(InfoGiven)
                GradientMaker.CurrentColor = InfoGiven
            end,
           ReturnDisplay = function(Object, Same)
             --SquareColor.BackgroundColor = Same and Object[Info.Name] or Color.new(1)
            
               return GradientMaker.CurrentColor
            end
        },{
            ValueContainer = "Outline",
            Container = "Secondary"
        })
        PropertyVal.UI.Container:SetPosition(Pivot2D.FromScale(0.5,1))
        PropertyVal.UI.Container:SetPivot(Vector2.new(0.5,1))
        GradientMaker.StartGradientColorHandle()
    end

    function GradientMaker.Update(dt)
    
    end
    return GradientMaker
end