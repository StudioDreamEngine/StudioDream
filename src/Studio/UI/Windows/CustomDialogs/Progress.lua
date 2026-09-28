local Progess = {}

function Progess.Init(Parented,Info,Window)
    local DialogObject = {}

    function DialogObject:Create()
        self.Objects.ProgressContainer = Studio.Components.CreateStyle("Square",{
            Size = Pivot2D.FromScale(0.8,0.2),
            Position = Pivot2D.FromScale(.5,.5),
            Pivot = Vector2.new(.5,0),
            BackgroundColor = "Text",
            OutlineSize = 3,
            Layer = 4,
            Parent = Object.Container,
        })

        self.Objects.ProgressBar = Studio.Components.CreateStyle("Square",{
            Size = Pivot2D.FromScale(1,1),
            Position = Pivot2D.FromScale(0,0),
            BackgroundColor = "Secondary",
            Parent = self.Objects.ProgressContainer,
        })

        self.Objects.Title = Studio.Components.CreateStyle("Text", {
            Size =  Pivot2D.FromScale(1,0.35),
            Position = Pivot2D.FromScale(0.5,0),
            Pivot = Vector2.new(0.5,0),
            Text = self.Title,
            Parent = Parented,
            ForegroundColor = "Text",
            Alignment = Enum.Alignment.TopCenter
        })
    end
    
    function DialogObject:UpdateText()
        local Percentage = (self.Stage/self.MaxStages) + (self.SubStage/self.MaxSubStages/self.MaxStages)
        self.Objects.ProgressBar:SetSize(Pivot2D.FromScale(self.Percentage, 1))

        self.Objects.Title:SetText(self.Title.." ("..self.SubStage.."/"..self.MaxSubStages..")")
        Scheduler.Yield()
    end

    function DialogObject:SetStages(InStages)
        self.Stage = 0
        self.SubStage = 0

        self.MaxStages = InStages
        DialogObject:UpdateText()
    end

    function DialogObject:SetSubStages(InStages)
        self.MaxSubStages = InStages
    end

    function DialogObject:NextStage(NewTitle) 
        self.Stage = self.Stage + 1
        self.SubStage = 0
        self.Title = NewTitle
        DialogObject:UpdateText()
    end

    function DialogObject:NextSubstage()
        self.SubStage = self.SubStage + 1
        DialogObject:UpdateText()
    end

    function DialogObject:Init()
        self.Objects = {}

        self.Stage = 0
        self.SubStage = 0

        self.MaxStages = Info.MaxStages or 1
        self.MaxSubStages = Info.MaxSubStages or 1
        
        self.Title = "Please wait..."

        self:Create()
    end

    function DialogObject:Destroy()
        for i,v in pairs(self.Objects) do
            v:Destroy()
        end

        table.clear(self.Objects)
        table.clear(DialogObject)
    end

    return DialogObject
end

return Progess