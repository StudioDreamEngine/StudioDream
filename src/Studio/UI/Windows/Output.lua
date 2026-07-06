local Output = {}

local ScrollContainer

function Output.CreateOutput(Text,Type)
    local ColorToText = Studio.Theme.GetCurrentTheme().Text
    if Type and Type == "Error" then
        ColorToText = Studio.Theme.GetCurrentTheme().Error
    end
    Runtime.Things.Create("Text") {
        Parent = ScrollContainer,
        BackgroundTransparency = 1,
        ForegroundColor = ColorToText,
        Text = Text,
        Size = Pivot2D.new(0,1,15,0)
    }
end

function Output.Init()
    ScrollContainer = Runtime.Things.Create("ScrollContainer") {
        CanvasSize = Pivot2D.FromScale(1,4),
        Size = Pivot2D.FromScale(1,1),
        Parent = Output.Container
    }

    Runtime.Things.Create("ListLayout") {
        Parent = ScrollContainer,
        Reverse = true
    }

    Scheduler.OnRecoverableError = function(Text)
        local List = string.split(Text, "\n")

        for i = #List,1,-1 do
            Output.CreateOutput(List[i],"Error")
        end
    end

    PrintCallback = function(Text)
        local List = string.split(Text, "\n")

        for i = #List,1,-1 do
            Output.CreateOutput(List[i])
        end
    end
end

return Output