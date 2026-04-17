local Things = Runtime.Things

local ExplorerContainer
local ExplorerContainer1
local TreeStarter

local RowHeight = 21
local IndentSize = 16
local IconsSize = 20 -- no you wont

local NodeColor = Color.new(0.314, 0.294, 0.502)
local WindowColor = Color.new(0.106, 0.09, 0.188)
local BackWindowColor = Color.new(0.149, 0.129, 0.333)

local function RenderIcon(IconName, VectorPos, Container, UseNewIcon)
    local ImageThing = Things.Create("Image2D") {
        Size = Pivot2D.FromOffset(IconsSize,IconsSize), -- used to be 16,16
        Image = UseNewIcon and ("Assets/EditorIcons/32/" .. IconName .. ".png" or "Assets/EditorIcons/32/Icon_Not_Found.png") or "Assets/EditorIcons/32/File_With_Problem.png",
        Pivot = Vector2.new(1,0.5),
        Position = Pivot2D.FromScale(0,0.5),
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
        AlignX = Enum.AlignmentX.Left,
        TextScaled = true,
        Pivot = Vector2.new(0,0.5),
        AlingY = Enum.AlignmentY.Top,
        Layer = 9,
        Parent = Container
    }
end

function RenderTextLabelNew(Container,Text,Position,Size)
    local TextThing = Things.Create("Text") {
        Size = Size,
        Position = Position,
        Text = Text,
        Layer = 3,
        Parent = Container,
        BackgroundTransparency = 1,
        ForegroundColor = Color.new(1,1,1),
        AlignX = Enum.AlignmentX.Center
    }
end

local function LoopWhileHold(HoldVerify,Viewport)
    if HoldVerify.Holding then
        HoldVerify.Position = Pivot2D.FromOffset(Viewport.MousePosition.X,Viewport.MousePosition.Y)
    end
end

local function RenderNode(Thing, currentY, depth ,XPos, View)
    if (not Thing.Explorer.Visible) then
        return currentY
    end
    
    local xOffset = XPos + depth * IndentSize
    local iconPos  = Vector2.new(xOffset, currentY)
    local labelPos = Vector2.new(xOffset + IconsSize + 4, currentY)

    local NodeContainer = Things.Create "TextButton" {
       Size = Pivot2D.FromScale(1,0.05),--Pivot2D.FromOffset(Vector2.new(200, 20)),
       Pivot = Vector2.new(0,0.5),
       Position = Pivot2D.FromOffset(xOffset+IconsSize,currentY),
       Explorer = {
        Visible = false,
       },
       BackgroundColor = NodeColor,
       Layer = 1,
       ForegroundColor = Color.new(1,1,1),
       Text = Thing.Name,
       BackgroundTransparency = 0.5
    }
    NodeContainer:SetParent(ExplorerContainer)

    NodeContainer.Clicked:Connect(function()
        -- One click selects the thing
        -- Hold makes u edit their parent
        -- Two clicks makes an special action (Open script, ect ect)
    end)
    
    local icon = Thing.Explorer.Icon or "Icon_Not_Found"
    RenderIcon(icon, iconPos, NodeContainer, Thing.Explorer.UseNewIcon)
    currentY = currentY + RowHeight

    for _, Child in pairs(Thing:GetChildren()) do
        currentY = RenderNode(Child, currentY, depth + 1, XPos, View)
    end
    
    return currentY
end

return function(TreeStarter, View)
    local Window = Runtime.InterfaceManager.CreateWindow(Pivot2D.FromScale(1,0.5),Pivot2D.FromScale(0,0.31),View)
    ExplorerContainer1 = Window.Container
    ExplorerContainer = Window.BackWindow
    RenderTextLabelNew(ExplorerContainer1,"Explorer",Pivot2D.FromScale(0,0),Pivot2D.FromScale(1,0.05))
    RenderNode(TreeStarter, 10, 0, 0, View)
end