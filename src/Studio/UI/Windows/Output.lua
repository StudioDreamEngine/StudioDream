local Output = {}

local ScrollContainer
local Log = {}

function Output.Init()
    ScrollContainer = Studio.Components.CreateStyle("ScrollContainer",{
        CanvasSize = Pivot2D.FromScale(1,4),
        Size = Pivot2D.FromScale(1,1),
        Name = "OutputContainer",
        Parent = Output.Container,
        BarColor = "Primary",
        UseCanvasSize = true
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

    local OutputText = Studio.Components.CreateStyle("Text", {
        Parent = ScrollContainer,
        BackgroundTransparency = 1,
        TextScaled = false,
        Text = "",
        Alignment = Enum.Alignment.TopLeft,
        ForegroundColor = "Text",
        Size = Pivot2D.FromScale(1,1)
    })

    Context:SetChoices({
        {
            Type = "Button",
            Text = "Clear Output",
            Image = "Internal/Studio/ContextMenu/Delete.png",
            Function = function(Menu)
                table.clear(Log)
                Menu.Remove()
            end,
        },
    })

    Studio.Components.RegisterToTheme(Output.Container, "BackgroundColor", "Outline")

    --[[if FLAGS.ExternalOutput then
        Scheduler.OnRecoverableError = function(Text)
            local List = string.split(Text, "\n")

            for i = #List,1,-1 do
                Output.CreateOutput(List[i],"Error")
            end
        end
    end]]

    PrintCallback = function(Text)
        table.insert(Log, Text)

        OutputText:SetText(table.concat(table.reverse(Log), "\n"))
    end

    print("Output window ready")
end

return Output