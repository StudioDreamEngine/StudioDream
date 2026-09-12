local Things = Runtime.Things
local Components = Studio.Components

local GradientButton
local Sequence = GradientSequence.NewSequence({}, 0)

return function(GradientMaker)
    
    GradientMaker.CurrentColor = Color.new(1,0,0)

    function GradientMaker.AddKey(InicialTime,Color)
        Sequence.AddKey(GradientSequence.NewKey(InicialTime,Color))
        local Slider = Studio.Components.CreateStyle("SlideBar",{
            Size = Pivot2D.FromScale(0.01,1),
            Pivot = Vector2.new(0.5,0),
            Position = Pivot2D.FromScale(0,0),
            Parent = GradientButton,
            BackgroundColor = Color,
            BackgroundTransparency = 0,
            CornerRadius = 10,
            OutlineSize = 1,
            Active = true,
            SinkHovering = false,
            --SlideAxis = Enum.SlideAxis.Y,
        })
        print(Color)
        print(InicialTime)
        Slider:SetPercentage(InicialTime)
        GradientButton:SetGradient(Sequence)
    end

    function GradientMaker.StartGradientColorHandle()
        GradientMaker.AddKey(1,Color.new(1))
        GradientMaker.AddKey(0,Color.new(1))

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
            Title = "wow",
            Type = "Input",
            Translate = "Color",
            StyleSelect = true,
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

        GradientMaker.StartGradientColorHandle()
    end

    function GradientMaker.Update(dt)
    
    end
    return GradientMaker
end