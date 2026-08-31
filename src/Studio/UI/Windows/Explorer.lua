local Things = Runtime.Things
local SelectionManager = Studio.Editor3D.SelectionManager

local Explorer = {}
Explorer.Tree = {}
Explorer.Nodes = {}

local AddButtonObject = Studio.Components.CreateStyle("ImageButton",{
    Resource = "Internal/Studio/AddThing.png",
    Size = Pivot2D.FromScale(1,1),
    Position = Pivot2D.FromScale(0.5,0),
    Pivot = Vector2.new(1,0.0001),
    SquareAxis = Enum.SquareAxis.Y,
})

local ScrollContainer

local AddButtonWow = {}

local Order = 0

local ExpandedState = {}

AddButtonWow = {
    Object = AddButtonObject,
    Connect = AddButtonObject.Clicked:Connect(function()
        printVerbose("Insert open")

        AddButtonWow.IsInsertOpen = true
        Studio.Editor3D.OpenInsertWindow(AddButtonWow.Object)
    end),
    IsInsertOpen = false
}

local function SetAllChildNodeVisible(NodeObj,Visiblity)
    for i,ChildNodeObj in pairs(NodeObj.ChildrenInNode) do
        ChildNodeObj.Node:SetVisible(Visiblity)
        SetAllChildNodeVisible(ChildNodeObj,Visiblity and ChildNodeObj.IsChildOpen)
    end
end

function Explorer.CreateNode(Object, Depth, IsLastChild)
    local NodeObj = {}

    NodeObj.ChildrenInNode = {}

    NodeObj.Node = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.new(1,0,0,15),
        Pivot = Vector2.new(0,0),
        BackgroundTransparency = 1,
        Layer = 3,
        Name = Object.Name,
        Parent = ScrollContainer,
        Serializable = false,
        CornerRadius = 5,
    })

    NodeObj.AlreadyCreatedChilButton = false

    NodeObj.NodeInner = Studio.Components.CreateIconObject(Object.Name, Object.Proxy.ExplorerIcon) -- Actually creates the visual part of the node
    NodeObj.NodeInner:SetSize(Pivot2D.new(1,-Depth*20,1,0))
    NodeObj.NodeInner:SetParent(NodeObj.Node)
    
    NodeObj.ParentLines = {}

    function NodeObj.CreateParentLine(LineDepth)
        LineDepth = LineDepth or Depth

        local ParentLine = Studio.Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(0.01, 1),
            Position = Pivot2D.FromScale(-0.025 * LineDepth, 0.5),
            Pivot = Vector2.new(0.5, 0.5),
            BackgroundColor = "Outline",
            BackgroundTransparency = 0,
            Layer = 1,
            Parent = NodeObj.NodeInner,
            Name = "ParentLine",
            Serializable = false,
            CornerRadius = 0,
            LimitCornerRadius = true,
        })

        Studio.Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(2.5, 0.25),
            Position = Pivot2D.FromScale(0,0.5),
            Pivot = Vector2.new(0, 0.5),
            BackgroundColor = "Outline",
            --Name = "ParentLineExtend",
            BackgroundTransparency = 0,
            Layer = 1,
            Parent = ParentLine,
            Serializable = false,
        })

        table.insert(NodeObj.ParentLines, ParentLine)
    end

    function NodeObj.CreateLastParentLine(LineDepth)
        LineDepth = LineDepth or Depth

        local ParentLine = Studio.Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(0.01, 0.5),
            Position = Pivot2D.FromScale(-0.025 * LineDepth, 0),
            Pivot = Vector2.new(0.5, 0),
            BackgroundColor = "Outline",
            BackgroundTransparency = 0,
            Name = "ParentLineLast",
            Layer = 1,
            Parent = NodeObj.NodeInner,
            Serializable = false,
            CornerRadius = 0,
            LimitCornerRadius = true,
        })

        Studio.Components.CreateStyle("Square", {
            Size = Pivot2D.FromScale(2.5, 0.5),
            Position = Pivot2D.FromScale(0,1),
            Pivot = Vector2.new(0, 1),
            BackgroundColor = "Outline",
            BackgroundTransparency = 0,
            Layer = 1,
            Parent = ParentLine,
            Serializable = false,
        })

        table.insert(NodeObj.ParentLines, ParentLine)
    end

    if Depth > 0 then
        if IsLastChild then
            NodeObj.CreateLastParentLine()
        else
            NodeObj.CreateParentLine()
        end
    end

    NodeObj.CreateChildrenButton = function()
        NodeObj.AlreadyCreatedChilButton = true
        
        --[[for i,v in pairs(NodeObj.ParentLines) do
            v:Destroy()
        end]]
        if #NodeObj.ParentLines > 0 then
            NodeObj.ParentLines[1]:Destroy()
            NodeObj.ParentLines[1] = nil -- mikl i swear to god
        end

        NodeObj.Button = Studio.Components.CreateStyle("ImageButton",{
            Resource = "Internal/Studio/OpenMenu.png",
            Size = Pivot2D.FromScale(0.8,0.8),
            BackgroundColor = "Text",
            SquareAxis = Enum.SquareAxis.Y, 
            Position = Pivot2D.FromScale(0,0.5),
            Pivot = Vector2.new(1,0.5),
            Parent = NodeObj.NodeInner,
            Layer = 4,
            ImageRect = Rect.new(Vector2.new(64,0),Vector2.new(64,64)),
            ForegroundColor = "Text",
        })

        if ExpandedState[Object] ~= nil then
            NodeObj.IsChildOpen = ExpandedState[Object]
        else
            NodeObj.IsChildOpen = true
        end
        NodeObj.Button:SetImageRect(Rect.new(
            Vector2.new(NodeObj.IsChildOpen and 64 or 0, 0),
            Vector2.new(64,64)
        ))

        NodeObj.Button.Clicked:Connect(function()
            NodeObj.IsChildOpen = not NodeObj.IsChildOpen
            ExpandedState[Object] = NodeObj.IsChildOpen
            SetAllChildNodeVisible(NodeObj,NodeObj.IsChildOpen)
            NodeObj.Button:SetImageRect(Rect.new(
                Vector2.new(NodeObj.IsChildOpen and 64 or 0, 0),
                Vector2.new(64,64)
            ))
        end)
    end

    return NodeObj
end

function Explorer.CreateTree(Object, Depth, BeforeNodeObj, IsLastChild)
    Order = Order + 1

    local NodeObj = Explorer.CreateNode(Object, Depth, IsLastChild)
    NodeObj.Node.ListOrder = Order
    NodeObj.Node:SetParent(ScrollContainer)
    --NodeObj.CreateParentLine(Depth+1)
    --printVerbose(NodeObj.NodeInner.BackgroundColor)
    Explorer.Tree[Object] = NodeObj.NodeInner
    Explorer.Nodes[Object] = NodeObj

    -- ??
    local IndexChild = 0
    for _, Child in pairs(Object:GetChildren()) do
        IndexChild = IndexChild + 1
        local IsLastChildCheck = IndexChild == table.length(Object:GetChildren())
        --print(table.length(Object:GetChildren()),IndexChild)
        if Child.Serializable then
            Explorer.CreateTree(Child, Depth + 1, NodeObj, IsLastChildCheck)
        end
    end

    if NodeObj.AlreadyCreatedChilButton then
        SetAllChildNodeVisible(NodeObj, NodeObj.IsChildOpen)
    end

    if BeforeNodeObj then
        table.insert(BeforeNodeObj.ChildrenInNode, NodeObj)

        if not BeforeNodeObj.AlreadyCreatedChilButton then
            BeforeNodeObj.CreateChildrenButton()
        end
    end
end

local InputService = Runtime.Services.Service("InputService") ---@class InputService
local Editor3D = Studio.Editor3D
local Selecting, Hovering
local Moving = false

local LastClick = 0

local function HandleDoubleClick(ClickedObject)
    -- I'd make this a little more advanced but scripts are most likely gonna be the only thing here
    if ClickedObject:IsA("BaseScript") then
        Studio.ScriptHandler.HandleOpenScript(ClickedObject)
    end
end

local function HandleDragStart()
    if (GlobalTick - LastClick < 0.4) then -- Process Double Click
        printVerbose("DoubleClick")
        HandleDoubleClick(Hovering.Thing)
        return
    end

    Selecting = Hovering
    local Object = Selecting.Thing

    -- Good god the amount of random shit we do for dumbass exceptions in this file
    -- Im gonna have to document this shit for once in order for anybody to get whats going on
    if (not SelectionManager.ObjectPicker) then
        LastClick = GlobalTick
    end

    SelectionManager.SelectObject(Object)
    --print("Started")
end

-- Function called when a drag stops, only called if theres a selected object
local function HandleDragEnd()
    --print("Ended")
    Selecting.Node:SetMouseLocked(false)

    if Hovering and Moving then -- If we're hovering over another object, then we attempt to  parent the selected object to it, and redraw
        local CouldParent = Selecting.Thing:SetParent(Hovering.Thing)
        printVerbose(CouldParent)
    else -- Otherwise, we just put it back in the tree
        Explorer.Tree[Selecting.Thing] = Selecting.Node
    end

    Moving = false
    Selecting = nil
end

local function OpenAncestors(Object)
    local Current = Object.Parent

    while Current do
        local NodeObj = Explorer.Nodes[Current]
        if NodeObj then
            ExpandedState[Current] = true
            NodeObj.IsChildOpen = true

            if NodeObj.Button then
                NodeObj.Button:SetImageRect(Rect.new(
                    Vector2.new(64, 0),
                    Vector2.new(64,64)
                ))
            end
        end
        if Current == Things.Root then
            break
        end
        Current = Current.Parent
    end

    local RootNode = Explorer.Nodes[Things.Root]
    if RootNode then
        SetAllChildNodeVisible(RootNode, true)
    end
end

function Explorer.Init()
    ScrollContainer = Studio.Components.CreateStyle("ScrollContainer",{
        Size = Pivot2D.FromScale(1,1),
        CanvasSize = Pivot2D.FromScale(1,4),
        BackgroundTransparency = 1,
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Parent = Explorer.Container,
        Serializable = false
    })

    Studio.Components.CreateStyle("ListLayout",{
        Parent = ScrollContainer,
        Padding = 3,
        SortMode = Enum.SortMode.Order
    })

    local Context = Studio.Components.CreateStyle("Contextulizer",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        BackgroundTransparency = 0.5,
        Layer = 999,
        SinkHovering = false,
        Parent = Explorer.Container,
        Serializable = false,
    })

    Context:SetChoices({
        {
            Type = "Button",
            Text = #Studio.Editor3D.Selecting > 1 and "Duplicate things" or "Duplicate thing",
            --SubText = "Sets cloned thing to current parent",
            Image = "Internal/Studio/ContextMenu/Clone.png",
            --Applicable = #Studio.Editor3D.Selecting > 0,
            Function = function(Menu)
                Studio.Editor3D.SelectionManager.DuplicateAll()
                Explorer.Redraw()
            end,
        },
        {
            Type = "Button",
            Text = #Studio.Editor3D.Selecting > 1 and "Delete things" or "Delete thing",
            Image = "Internal/Studio/ContextMenu/Delete.png",
            --Applicable = #Studio.Editor3D.Selecting > 0,
            Function = function(Menu)
                Studio.Editor3D.SelectionManager.DeleteAll()
                Explorer.Redraw()
            end,
        },
        {Type = "Separator"},
        {
            Type = "Button",
            Text = #Studio.Editor3D.Selecting > 1 and "Group things" or "Group thing",
            Image = "Internal/Studio/ContextMenu/Group.png",
            --Applicable = #Studio.Editor3D.Selecting > 0,
            Function = function(Menu)
                Studio.Editor3D.SelectionManager.GroupAll()
                Explorer.Redraw()
                Explorer.Redraw()
            end,
        },
        {
            Type = "Button",
            Text = #Studio.Editor3D.Selecting > 1 and "UnGroup things" or "UnGroup thing",
            Image = "Internal/Studio/ContextMenu/Ungruped.png",
            --Applicable = #Studio.Editor3D.Selecting > 0,
            Function = function(Menu)
                Studio.Editor3D.SelectionManager.UngroupAll()
                Explorer.Redraw()
            end,
        },
        {Type = "Separator"},
        {
            Type = "Button",
            Text = "Insert thing",
            Image = "Internal/Studio/ContextMenu/Ungruped.png",
            Function = function(Menu)
                Studio.Editor3D.OpenInsertWindow()
                Menu.Remove()
            end,
        },
        {
            Type = "Button",
            Text = "Zoom To",
            Image = "Internal/Studio/ContextMenu/Ungruped.png",
            Function = function(Menu)
                Studio.Editor3D.ZoomTo()
                Menu.Remove()
            end,
        }
    })

    Explorer.Redraw()
    
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

    Studio.Editor3D.OnSelect:Connect(function()
        if AddButtonWow.IsInsertOpen then
            AddButtonWow.IsInsertOpen = false
            Studio.Editor3D.CloseInsertWindow()
        end

        for _, Object in pairs(Studio.Editor3D.Selecting) do
            OpenAncestors(Object)
        end
    end)

    ---@param MouseObject InputMouseObject
    InputService.MouseMoved:Connect(function(MouseObject)
        if Selecting and MouseObject.Delta:Magnitude() > 0 then
            Moving = true
            Selecting.Node:SetMouseLocked(true)
            Explorer.Tree[Object] = nil
        end
    end)
    
    InputService.KeyEvent:Connect(function(Began, Key)
        if (Key == "delete" and Editor3D.Selecting) then
            local toDelete = Editor3D.Selecting

            for _, thing in pairs(toDelete) do
                thing:Destroy()
            end

            Editor3D.SelectionManager.DeselectAll()
        end
    end)

    Runtime.Things.TreeChanged:Connect(function()
        Explorer.Redraw()
    end)
end

function Explorer.Redraw()
    ScrollContainer:ClearAllChildren({"ListLayout"})

    table.clear(Explorer.Tree)
    table.clear(Explorer.Nodes)

    Explorer.CreateTree(Things.Root, 0)

    ExpandedState = {}
end

function Explorer.Update(dt)
    Hovering = nil

    -- This manages the insert button hint, and the current hovering object
    for Thing, NodeInner in pairs(Explorer.Tree) do
        if NodeInner.Hovering then
            Hovering = {
                Node = NodeInner,
                Thing = Thing
            }
        end

        if table.find(Studio.Editor3D.Selecting, Thing) then
            NodeInner.BackgroundColor = Studio.CurrentTheme.Selecting

            AddButtonWow.Object:SetParent(NodeInner)
        else
            NodeInner.BackgroundColor = Studio.CurrentTheme.Primary -- CHANGE IT HERE!
        end
    end
end

return Explorer