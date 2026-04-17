local PropertiesRender = {}
local Things = Runtime.Things
local PropertiesContainer

function RenderTextLabel(Text,Position,Size)
    local TextThing = Things.Create("Text") {
        Size = Size,
        Position = Position,
        Text = Text,
        Layer = 3,
        Parent = PropertiesContainer,
        BackgroundTransparency = 1,
        ForegroundColor = Color.new(1,1,1),
        AlignX = Enum.AlignmentX.Center
    }
end

function RenderProperty(Type,Val)
    -- This will be more complex, maybe have like, a window base, that would be just the frame of the property, then detect if the property is inside this script
    -- Then we just init the script, giving the frame as a info or something!!! ✌️✌️✌️
end

function PropertiesRender:LoadProperties(Thing) -- This will be handled properly with the addicion of Select table!!@(*!)
    for Type,Val in pairs(Thing) do -- Make a special table for editable/showable properties?
        RenderProperty(Type,Val)
    end
end

function PropertiesRender:Init(TreeStarter, View)
    local Window = Runtime.InterfaceManager.CreateWindow(Pivot2D.FromScale(1,0.44),Pivot2D.FromScale(0,0.78),View)
    PropertiesContainer = Window.Container
    BackWindow = Window.BackWindow
    RenderTextLabel("Properties",Pivot2D.FromScale(0,0),Pivot2D.FromScale(1,0.05))
end

return PropertiesRender