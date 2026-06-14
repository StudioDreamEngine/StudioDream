return function(Options)
    local Object = {}

    local MaxStages, MaxSubStages = 1, 1
    local Stage, SubStage = 0, 0

    local Title = "Please Wait..."

    local TitleContainer, ProgressContainer
    local ProgressBar

    function Object.CreateDialog()
        TitleContainer = Runtime.Things.Create("Text") {
            Size = Pivot2D.FromScale(1,0.5),
            Alignment = Enum.Alignment.Center,
            BackgroundTransparency = 1,
            ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
            Layer = 3,
            Parent = Object.Container,
        }

        ProgressContainer = Runtime.Things.Create("Square") {
            Size = Pivot2D.FromScale(0.8,0.2),
            Position = Pivot2D.FromScale(.5,.5),
            Pivot = Vector2.new(.5,0),
            BackgroundColor = Studio.Theme.GetCurrentTheme().Tertiary,
            OutlineSize = 3,
            Layer = 4,
            Parent = Object.Container,
        }

        ProgressBar = Runtime.Things.Create("Square") {
            Size = Pivot2D.FromScale(1,1),
            Position = Pivot2D.FromScale(0,0),
            BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
            Parent = ProgressContainer,
        }

        Object.UpdateText()
    end

    function Object.SetStages(InStages, InSubStages)
        MaxStages = InStages
        MaxSubStages = InSubStages
    end

    function Object.UpdateText()
        local Percentage = (Stage/MaxStages) + (SubStage/MaxSubStages/MaxStages)
        ProgressBar:SetSize(Pivot2D.FromScale(Percentage, 1))

        TitleContainer:SetText(Title.." ("..SubStage.."/"..MaxSubStages..")")
    end

    function Object.NextStage(NewTitle) 
        Stage = Stage + 1
        Object.UpdateText()
        Title = NewTitle
    end

    function Object.SetSubstage(NewSubstage) 
        SubStage = NewSubstage
        Object.UpdateText()
    end

    function Object.Update()
        
    end

    return Object
end