local Things = Runtime.Things

local ExplorerContainer
local TreeStarter

local RowHeight = 24
local IndentSize = 16
local IconsSize = 16 -- i will change this when we actually start making icons frfr

local function RenderIcon(IconName, VectorPos)
    local ImageThing = Things.New("Image2D")
    ImageThing.Position = Pivot2D.FromOffset(VectorPos)
    ImageThing.ImageFile = "Assets/EditorIcons/16/" .. IconName .. ".png"
    ImageThing:SetParent(ExplorerContainer)
end

local function RenderTextLabel(Text, VectorPos)
    local TextThing = Things.New("Text")
    TextThing.Position = Pivot2D.FromOffset(VectorPos)
    TextThing.Text = Text
    TextThing.Size = Pivot2D.FromOffset(Vector2.new(200, 20))
    TextThing.ForegroundColor = Color.new(1)
    TextThing.BackgroundTransparency = 1
    TextThing.AlignX = Enum.AlignmentX.Left
    TextThing:SetParent(ExplorerContainer)
end

local function RenderNode(Thing, currentY, depth)
    if (not Thing.Explorer.Visible) then
        return currentY
    end
    
    local xOffset = depth * IndentSize
    local iconPos  = Vector2.new(xOffset, currentY)
    local labelPos = Vector2.new(xOffset + IconsSize + 4, currentY)

    local icon = Thing.Explorer.Icon or "cancel"
    RenderIcon(icon, iconPos)
    RenderTextLabel(Thing.Name, labelPos)
    currentY = currentY + RowHeight

    ---@module 'SquarePrimative'
    ExplorerContainer = Things.New("SquarePrimative")
    ExplorerContainer.BackgroundColor = Color.new(.1)
    ExplorerContainer.Size = Pivot2D.FromOffset(Vector2.new(200,20))
    ExplorerContainer.Explorer.Visible = false
    ExplorerContainer.Name = "Explorer"
    ExplorerContainer.Position = Pivot2D.FromOffset(labelPos)
    ExplorerContainer:SetParent(Things.Root.Viewport)

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