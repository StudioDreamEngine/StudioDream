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

function LoadProperties(Thing)

end

return function(TreeStarter, View)
    local Window = Runtime.InterfaceManager.CreateWindow(Pivot2D.FromScale(1,0.44),Pivot2D.FromScale(0,0.78),View)
    PropertiesContainer = Window.Container
    BackWindow = Window.BackWindow
    RenderTextLabel("Properties",Pivot2D.FromScale(0,0),Pivot2D.FromScale(1,0.05))
end