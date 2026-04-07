local Things = Runtime.Things

local ExplorerContainer
local ExplorerContainer1
local TreeStarter

local RowHeight = 24
local IndentSize = 16
local IconsSize = 16 -- i will change this when we actually start making icons frfr

local function RenderIcon(IconName, VectorPos, Container)
    local ImageThing = Things.New("Image2D")
    ImageThing.ImageFile = "Assets/EditorIcons/16/" .. IconName .. ".png"
    ImageThing:SetParent(Container)
end

local function RenderTextLabel(Text, VectorPos, Container,SpecialPos,SpecialSize)
    local TextThing = Things.New("Text")
    TextThing.Text = Text
    TextThing.Position = SpecialPos or Pivot2D.FromOffset(IconsSize+4/10,5)
    TextThing.Size = Pivot2D.FromOffset(Vector2.new(200, 20))
    TextThing.TextSize = SpecialSize or 12
    TextThing.ForegroundColor = Color.new(1)
    TextThing.BackgroundTransparency = 1
    TextThing.AlignX = Enum.AlignmentX.Left
    TextThing.Pivot = Vector2.new(0,0.5)
    TextThing.AlingY = Enum.AlignmentY.Top
    TextThing.Layer = 9
    TextThing:SetParent(Container)
end

local function RenderNode(Thing, currentY, depth ,XPos)
    if (not Thing.Explorer.Visible) then
        return currentY
    end
    
    local xOffset = XPos + depth * IndentSize
    local iconPos  = Vector2.new(xOffset, currentY)
    local labelPos = Vector2.new(xOffset + IconsSize + 4, currentY)

    local NodeContainer = Things.New("SquarePrimative")
    NodeContainer.Size = Pivot2D.FromOffset(Vector2.new(200, 20))
    NodeContainer.Position = Pivot2D.FromOffset(xOffset,currentY)
    NodeContainer.Explorer.Visible = false
    NodeContainer.BackgroundColor = Color.new(0.137, 0.129, 0.2)
    NodeContainer.Layer = 1
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

return function()
    local TreeStarter = Things.Root.Viewport

     ---@module 'SquarePrimative'
    ExplorerContainer1 = Things.New("SquarePrimative")
    ExplorerContainer1.BackgroundColor = Color.new(0.376, 0.365, 0.443)
    ExplorerContainer1.Size = Pivot2D.FromOffset(Vector2.new(200,500))
    ExplorerContainer1.Explorer.Visible = false
    ExplorerContainer1.Name = "Explorer"
    ExplorerContainer1.Position = Pivot2D.FromOffset(Vector2.new(570,50))
    ExplorerContainer1:SetParent(TreeStarter)

    RenderTextLabel("~-Explorer-~", Vector2.new(0,0), ExplorerContainer1,Pivot2D.FromScale(Vector2.new(5,5)),12)

    ---@module 'SquarePrimative'
    ExplorerContainer = Things.New("SquarePrimative")
    ExplorerContainer.BackgroundColor = Color.new(0.196, 0.184, 0.29)
    ExplorerContainer.Size = Pivot2D.FromOffset(Vector2.new(190,250))
    ExplorerContainer.Explorer.Visible = false
    ExplorerContainer.Name = "Explorer"
    ExplorerContainer.Layer = 2
    ExplorerContainer.Position = Pivot2D.FromOffset(Vector2.new(5,20))
    ExplorerContainer:SetParent(ExplorerContainer1)

    RenderNode(TreeStarter, 0, 0, 0)
end