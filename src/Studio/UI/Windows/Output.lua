local Output = {}

local ScrollContainer

function Output.CreateOutput(Text,Type)
    local ColorToText = Studio.Theme.CurrentTheme.Text2
    
    if Type and Type == "Error" then
        ColorToText = Studio.Theme.CurrentTheme.Error
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

    local Context = Runtime.Things.Create("Contextulizer") { 
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        --BackgroundTransparency = 1,
        Layer = 999,
        Parent = Output.Container,
        Serializable = false,
    }

    Context:SetChoices({
        {Type = "Separator"},
        {
            Type = "Button",
            Text = "Clear Output",
            Function = function(Menu)
                ScrollContainer:ClearAllChildren({"ListLayout"})
                Menu.Remove()
            end,
        },
        {Type = "Separator"},
    })

    Output.Container.BackgroundColor = Studio.Theme.CurrentTheme.Outline
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