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

local function RenderIcon(IconName, VectorPos, Container)
    local Icon = Utils.DoesFileExist("Assets/EditorIcons/16/" .. IconName .. ".png") and "Assets/EditorIcons/16/" .. IconName .. ".png" or "Assets/EditorIcons/16/File_Not_Found.png"local Icon = Utils.DoesFileExist("Assets/EditorIcons/16/" .. IconName .. ".png") and "Assets/EditorIcons/16/" .. IconName .. ".png" or "Assets/EditorIcons/16/File_Not_Found.png"
    local ImageThing = Things.Create("Image2D") {
        Size = Pivot2D.FromScale(Vector2.one * IconsSize),
        Image = "Assets/EditorIcons/16/" .. IconName .. ".png",
        Parent = Container
    }
end

local function RenderTextLabel(Text, VectorPos, Container,SpecialPos,SpecialSize,OriginalSize)
    local TextThing = Things.Create("Text") {
        Text = Text,
        Position = SpecialPos or Pivot2D.FromOffset(IconsSize+4/10,10),
        Size = OriginalSize or Pivot2D.FromScale(0.8,1),
        TextSize = SpecialSize or 12,
        ForegroundColor = Color.new(1),
        BackgroundTransparency = 1,
        TextScaled = true,
        Pivot = Vector2.new(0,0.5),
        Layer = 9,
        Parent = Container
    }
end

local function RenderNode(Thing, currentY, depth ,XPos)
    if (not Thing.Explorer.Visible) then
        return currentY
    end
    
    local xOffset = XPos + depth * IndentSize
    local iconPos  = Vector2.new(xOffset, currentY)
    local labelPos = Vector2.new(xOffset + IconsSize + 4, currentY)

    local NodeContainer = Things.Create "SquarePrimative" {
       Size = Pivot2D.FromScale(1,0.05),--Pivot2D.FromOffset(Vector2.new(200, 20)),
       Pivot = Vector2.new(0,0.5),
       Position = Pivot2D.FromOffset(xOffset,currentY),
       Explorer = {
        Visible = false,
       },
       BackgroundColor = NodeColor,
       Layer = 1,
       BackgroundTransparency = 0.5
    }
    NodeContainer:SetParent(ExplorerContainer)

    local icon = Thing.Explorer.Icon or "cancel"
    RenderIcon(icon, iconPos, NodeContainer)
    RenderTextLabel(Thing.Name, labelPos, NodeContainer)
    currentY = currentY + RowHeight

    for _, Child in pairs(Thing:GetChildren()) do
        currentY = RenderNode(Child, currentY, depth + 1, XPos)
    end
    
    return currentY
end

return function(TreeStarter, View)
    ExplorerContainer1 = Things.Create "SquarePrimative" {
       Size = Pivot2D.FromScale(1,1),
       Explorer = {
        Visible = false,
       },
       Position = Pivot2D.FromScale(0,0.064),
       BackgroundColor = WindowColor,
       Name = "Explorer",
       Layer = 1,
       Parent = View
    }

    RenderTextLabel("Explorer", Vector2.new(0,0), ExplorerContainer1,Pivot2D.FromScale(Vector2.new(5,5)),12,Pivot2D.FromOffset(200,20))

    ExplorerContainer = Things.Create "SquarePrimative" {
       Size = Pivot2D.FromScale(0.9,0.9),
       Position = Pivot2D.FromScale(0.5,0.5),
       Pivot = Vector2.new(0.5,0.5),
       Explorer = {
        Visible = false,
       },
       BackgroundColor = BackWindowColor,
       Name = "BackWindow",
       Layer = 2,
       Parent = ExplorerContainer1
    }

    RenderNode(TreeStarter, 10, 0, 0)
end