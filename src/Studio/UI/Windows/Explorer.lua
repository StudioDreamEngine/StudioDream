local Things = Runtime.Things
local SelectionManager = Studio.Editor3D.SelectionManager

local Explorer = {}

Explorer.Tree = {}

local Order = 0
local Window

function Explorer.CreateNode(Object, Depth)
    local Node = Things.Create("Square") { 
        Size = Pivot2D.FromScale(1,0.05),
        Pivot = Vector2.new(0,0),
        BackgroundTransparency = 1,
        Layer = 3,
        Parent = Window,
    }

    local Line = Things.Create("Square") { 
        Size = Pivot2D.FromScale(1,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.Secondary,
        Layer = 2,
        BackgroundTransparency = 0.5,
        Parent = Node,
    }

    local NodeInner = Things.Create("TextButton") {
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Size = Pivot2D.new(-Depth*20,1,0,1),
        BackgroundColor = Studio.Theme.Secondary,
        Text = "",
        Parent = Node,
        Layer = 3,
        Name = Object.Name,
        OutlineSize = 1,
        OutlineColor = Studio.Theme.Primary
    }

    local NodeText = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = Object.Name,
        Name = "NodeText",
        Parent = NodeInner,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text
    }
    
    local Icon = Utils.DoesFileExist("Assets/EditorIcons/" .. Object.Explorer.Icon .. ".png") and "Assets/EditorIcons/" .. Object.Explorer.Icon .. ".png" or "Assets/EditorIcons/File_Not_Found.png"
    
    local NodeIcon = Things.Create("Image2D") {
        Size = Pivot2D.new(0,0.1,0,1),
        SquareAxis = Enum.SquareAxis.Y,
        Pivot = Vector2.new(1,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Image = Icon,
        Parent = NodeInner
    }
    
    return Node, NodeInner
end

function Explorer.CreateTree(Object, Depth)
    Order = Order + 1

    local Node, NodeInner = Explorer.CreateNode(Object, Depth)
    Node.ListOrder = Order
    Node:SetParent(Window)

    Explorer.Tree[Object] = NodeInner

    for _, Child in pairs(Object:GetChildren()) do
        if Child.TruelySerializable then
            Explorer.CreateTree(Child, Depth + 1)
        end
    end
end

local InputService = Runtime.Services.Service("InputService") ---@class InputService
local Selecting
local Hovering

local function HandleDragStart()
    Selecting = Hovering
    Selecting.Node:SetMouseLocked(true)

    local Object = Selecting.Thing

    SelectionManager.SelectObject(Object)
    Explorer.Tree[Object] = nil
end

local function HandleDragEnd()
    Selecting.Node:SetMouseLocked(false)

    if Hovering then
        local CouldParent = Selecting.Thing:SetParent(Hovering.Thing)

        if CouldParent then Explorer.Redraw() end
    else
        Explorer.Tree[Selecting.Thing] = Selecting.Node
    end

    Selecting = nil
end

function Explorer.Init()
    Window = Explorer.Container

    Explorer.CreateTree(Things.Root, 0)

    Things.Create("ListLayout") {
        Parent = Window
    }

    InputService.MouseEvent:Connect(function(IsDown)
        if IsDown and Hovering then -- Drag Start
            HandleDragStart()
            return
        end

        -- Drag End
        if Selecting then
            HandleDragEnd()
        end
    end, Enum.MouseButton.LeftClick)
end

function Explorer.Redraw()
    Window:ClearAllChildren()
    Explorer.Init(Window)
end

function Explorer.Update(dt)
    Hovering = nil

    for Thing, Object in pairs(Explorer.Tree) do
        if Object.Hovering then 
            Hovering = {
                Node = Object,
                Thing = Thing
            }
        end

        if Thing == Studio.Editor3D.Selecting then
            Object.BackgroundColor = Studio.Theme.Selecting
        else
            Object.BackgroundColor = Studio.Theme.Secondary
        end
    end
end

return Explorer