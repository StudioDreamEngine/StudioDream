local Things = Runtime.Things

local NodeColor = Color.new(0.314, 0.294, 0.502)
local WindowColor = Color.new(0.106, 0.09, 0.188)
local BackWindowColor = Color.new(0.149, 0.129, 0.333)

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
    PropertiesContainer = Things.Create "SquarePrimative" { 
      Size = Pivot2D.FromScale(1,0.44),
       Explorer = {
        Visible = false,
       },
       Position = Pivot2D.FromScale(0,0.78),
       Pivot = Vector2.new(0,0.5),
       BackgroundColor = WindowColor,
       Name = "Properties",
       Layer = 1,
       Parent = View
    }
    
    local BackWindow = Things.Create "SquarePrimative" {
       Size = Pivot2D.FromScale(0.9,0.9),
       Position = Pivot2D.FromScale(0.5,0.5),
       Pivot = Vector2.new(0.5,0.5),
       Explorer = {
        Visible = false,
       },
       BackgroundColor = BackWindowColor,
       Name = "BackWindow",
       Layer = 2,
       Parent = PropertiesContainer
    }

    RenderTextLabel("Properties",Pivot2D.FromScale(0,0),Pivot2D.FromScale(1,0.05))
end