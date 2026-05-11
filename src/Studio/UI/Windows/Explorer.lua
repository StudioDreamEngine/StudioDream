local Things = Runtime.Things
local Explorer = {}

Explorer.Tree = {}

local Order = 0
local Window

function Explorer.CreateNode(Object, Depth)
    -- Temporary

    local Node = Things.Create("Square") { 
        Size = Pivot2D.FromScale(1,0.05),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.WindowColor,
        Layer = 3,
        Parent = Window,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.OutlineColor
    }

    local NodeInner = Things.Create("Square") {
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Size = Pivot2D.new(-Depth*20,1,0,1),
        BackgroundTransparency = 1,
        Parent = Node
    }

    local NodeText = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = Object.Name,
        Name = "NodeText",
        Parent = NodeInner,
        BackgroundTransparency = 1,
        ForegroundColor = Color.new(1,1,1)
    }
    local NodeIcon = Things.Create("Image2D") {
        Size = Pivot2D.new(0,0.1,0,1),
        SquareAxis = Enum.SquareAxis.Y,
        Pivot = Vector2.new(1,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Image = ("Assets/EditorIcons/" .. Object.Explorer.Icon .. ".png") or "Assets/EditorIcons/Icon_Not_Found.png",
        Parent = NodeInner
    }
    
    return Node
end

function Explorer.CreateTree(Object, Depth)
    Order = Order + 1

    local Node = Explorer.CreateNode(Object, Depth)
    Node.ListOrder = Order
    Node:SetParent(Window)

    for _, Child in pairs(Object:GetChildren()) do
        if Child.TruelySerializable then
            Explorer.CreateTree(Child, Depth + 1)
        end
    end
end

--[[
    My idea for this is 
]]

function Explorer.Init(WindowContainer)
    Window = WindowContainer

    Explorer.CreateTree(Things.Root, 0)

    Things.Create("ListLayout") {
        Parent = Window
    }
end

return Explorer