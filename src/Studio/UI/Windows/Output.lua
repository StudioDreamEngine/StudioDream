local Output = {}

local ScrollContainer

function Output.CreateOutput(Text,Type)
    local ColorToText = "Text"
    
    if Type and Type == "Error" then
        ColorToText = Studio.CurrentTheme.Error
    end

    Studio.Components.CreateStyle("Text", {
        Parent = ScrollContainer,
        BackgroundTransparency = 1,
        ForegroundColor = ColorToText,
        Text = Text,
        Size = Pivot2D.new(1,0,0,15)
    })
end

function Output.Init()
    ScrollContainer = Studio.Components.CreateStyle("ScrollContainer",{
        CanvasSize = Pivot2D.FromScale(1,4),
        Size = Pivot2D.FromScale(1,1),
        Name = "OutputContainer",
        Parent = Output.Container
    })

    local Context = Studio.Components.CreateStyle("Contextulizer",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        --BackgroundTransparency = 1,
        Layer = 999,
        Parent = Output.Container,
        Serializable = false,
    })

    Context:SetChoices({
        {
            Type = "Button",
            Text = "Clear Output",
            Image = "Internal/Studio/ContextMenu/Delete.png",
            Function = function(Menu)
                ScrollContainer:ClearAllChildren({"ListLayout"})
                Menu.Remove()
            end,
        },
    })

    Studio.Components.RegisterToTheme(Output.Container, "BackgroundColor", "Outline")
    Studio.Components.CreateStyle("ListLayout",{
        Parent = ScrollContainer,
        Reverse = true
    })

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