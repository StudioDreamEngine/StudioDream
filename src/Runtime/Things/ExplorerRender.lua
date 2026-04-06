local Things = Runtime.Things

local ExplorerContainer
local TreeStarter

local RowHeight = 24
local IndentSize = 16
local IconsSize = 16 -- i will change this when we actually start making icons frfr

local function RenderIcon(IconName, VectorPos, Container)
    local ImageThing = Things.New("Image2D")
    ImageThing.ImageFile = "Assets/EditorIcons/16/" .. IconName .. ".png"
    ImageThing:SetParent(Container)
end

local function RenderTextLabel(Text, VectorPos, Container)
    local TextThing = Things.New("Text")
    TextThing.Text = Text
    TextThing.Position = Pivot2D.FromOffset(IconsSize+4,0)
    TextThing.Size = Pivot2D.FromOffset(Vector2.new(200, 20))
    TextThing.ForegroundColor = Color.new(1)
    TextThing.BackgroundTransparency = 1
    TextThing.AlignX = Enum.AlignmentX.Left
    TextThing.Layer = 9
    TextThing:SetParent(Container)
end

local function RenderNode(Thing, currentY, depth)
    if (not Thing.Explorer.Visible) then
        return currentY
    end
    
    local xOffset = depth * IndentSize
    local iconPos  = Vector2.new(xOffset, currentY)
    local labelPos = Vector2.new(xOffset + IconsSize + 4, currentY)

    local NodeContainer = Things.New("SquarePrimative")
    NodeContainer.Size = Pivot2D.FromOffset(Vector2.new(200, 20))
    NodeContainer.Position = Pivot2D.FromOffset(xOffset,currentY)
    NodeContainer.Explorer.Visible = false
    NodeContainer.BackgroundColor = Color.new(.5)
    NodeContainer.Layer = 1
    NodeContainer:SetParent(ExplorerContainer)

    local icon = Thing.Explorer.Icon or "cancel"
    RenderIcon(icon, iconPos, NodeContainer)
    RenderTextLabel(Thing.Name, labelPos, NodeContainer)
    currentY = currentY + RowHeight

    for _, Child in pairs(Thing:GetChildren()) do
        currentY = RenderNode(Child, currentY, depth + 1)
    end
    
    return currentY
end

return function()
    local TreeStarter = Things.Root.Viewport

    ---@module 'SquarePrimative'
    ExplorerContainer = Things.New("SquarePrimative")
    ExplorerContainer.BackgroundColor = Color.new(.2)
    ExplorerContainer.Size = Pivot2D.FromOffset(Vector2.new(200,500))
    ExplorerContainer.Explorer.Visible = false
    ExplorerContainer.Name = "Explorer"
    ExplorerContainer:SetParent(TreeStarter)

    RenderNode(TreeStarter, 0, 0)
end