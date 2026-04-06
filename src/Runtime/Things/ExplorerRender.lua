local Things = Runtime.Things

local RowHeight = 24
local IndentSize = 16
local IconsSize = 16 -- i will change this when we actually start making icons frfr

local function RenderIcon(IconName, VectorPos, TreeStarter)
    local ImageThing = Things.New("Image2D")
    ImageThing.Position = Pivot2D.FromOffset(VectorPos)
    ImageThing.ImageFile = "Assets/EditorIcons/16/" .. IconName .. ".png"
    ImageThing:SetParent(TreeStarter)
end

local function RenderTextLabel(Text, VectorPos, TreeStarter)
    local TextThing = Things.New("Text")
    TextThing.Position = Pivot2D.FromOffset(VectorPos)
    TextThing.Text = Text
    TextThing.Size = Pivot2D.FromOffset(Vector2.new(200, 20))
    TextThing.TextColor = Color.new(1)
    TextThing.BGTransparency = 1
    TextThing.AlignX = Enum.AlignmentX.Left
    TextThing:SetParent(TreeStarter)
end

local function RenderNode(UIDD, currentY, depth, TreeStarter)
    local Thingy = Things.Get(UIDD)

    if not Thingy or not Thingy.Explorer.Visible then
        return currentY
    end
    
    local xOffset = depth * IndentSize
    local iconPos  = Vector2.new(xOffset, currentY)
    local labelPos = Vector2.new(xOffset + IconsSize + 4, currentY)

    local icon = Thingy.Explorer.Icon or "cancel"
    RenderIcon(icon, iconPos, TreeStarter)
    RenderTextLabel(Thingy.Name, labelPos, TreeStarter)

    currentY = currentY + RowHeight

    if Thingy.Children then
        for childUID, _ in pairs(Thingy.Children) do
            currentY = RenderNode(childUID, currentY, depth + 1, TreeStarter)
        end
    end
    
    return currentY
end

return function()
    local TreeStarter = Things.Root.Viewport
    
    local rootIcon = TreeStarter.Explorer.Icon or "cancel"
    RenderIcon(rootIcon, Vector2.new(0, 0), TreeStarter)
    RenderTextLabel(TreeStarter.Name, Vector2.new(IconsSize + 4, 0), TreeStarter)

    local currentY = RowHeight

    for UIDD, _ in pairs(table.clone(TreeStarter.Children)) do
        currentY = RenderNode(UIDD, currentY, 1, TreeStarter)
    end
end