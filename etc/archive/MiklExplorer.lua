local Things = Runtime.Things
local Explorer = {}

local RowHeight = 21
local IndentSize = 16
local IconsSize = 20 -- no you wont

local NodeColor = Color.new(0.314, 0.294, 0.502)

local function RenderIcon(IconName, VectorPos, Container)
    local ImageThing = Things.Create("Image2D") {
        Size = Pivot2D.FromOffset(IconsSize,IconsSize), -- used to be 16,16
        Image = ("Assets/EditorIcons/32/" .. IconName .. ".png") or "Assets/EditorIcons/32/Icon_Not_Found.png",
        Pivot = Vector2.new(1,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Parent = Container
    }
end

local function RenderNode(Thing, currentY, depth ,XPos, View)
    if (not Thing.Explorer.Visible) then
        return currentY
    end
    
    local xOffset = XPos + depth * IndentSize
    local iconPos  = Vector2.new(xOffset, currentY)

    local NodeContainer = Things.Create "TextButton" {
       Size = Pivot2D.FromScale(1,0.05),
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
    RenderIcon(icon, iconPos, NodeContainer)
    currentY = currentY + RowHeight

    for _, Child in pairs(Thing:GetChildren()) do
        currentY = RenderNode(Child, currentY, depth + 1, XPos, View)
    end
    
    return currentY
end

local function RenderExplorer(TreeStarter)
    ExplorerContainer:ClearAllChildren()
    RenderNode(TreeStarter, 10, 0, 0, ExplorerContainer)
end

function Explorer.Init(WindowContainer)
    local TreeStarter = Things.Root
    ExplorerContainer = WindowContainer

    RenderExplorer(TreeStarter)

    Things.HierachyChanged:Connect(function()
        print("Re-render explorer")
        RenderExplorer(TreeStarter)
    end)
end

return Explorer