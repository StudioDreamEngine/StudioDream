local Things = Runtime.Things

local ExplorerContainer
local ExplorerContainer1
local TreeStarter

local RowHeight = 24
local IndentSize = 16
local IconsSize = 16 -- i will change this when we actually start making icons frfr

local NodeColor = Color.new(0.314, 0.294, 0.502)
local WindowColor = Color.new(0.106, 0.09, 0.188)
local BackWindowColor = Color.new(0.149, 0.129, 0.333)

local function RenderTextLabel(Text, VectorPos, Container,Pivoter)
    local TextThing = Things.Create("Text") {
        Text = Text,
        FontFile = "Assets/Fonts/Arimo-Bold.ttf",
        Position = VectorPos,
        Size = Pivot2D.FromScale(0.2,1),
        ForegroundColor = Color.new(1),
        BackgroundTransparency = 1,
        AlignX = Enum.AlignmentX.Center,
        Pivot = Vector2.new(0,0.5),
        AlingY = Enum.AlignmentY.Center,
        Layer = 9,
        Parent = Container
    }
end

return function(TreeStarter)
    ExplorerContainer = Things.Create "SquarePrimative" { 
       Size = Pivot2D.FromScale(1,0.05),
       Pivot = Vector2.new(0.5,1),
       Position = Pivot2D.FromScale(0.5,0.05),
       Explorer = {
        Visible = false,
       },
       BackgroundColor = WindowColor,
       Name = "Explorer",
       Layer = 1
    }
    ExplorerContainer:SetParent(TreeStarter)

    RenderTextLabel("Projects",Pivot2D.FromScale(0.05,0.5),ExplorerContainer) -- Make this button soon
end