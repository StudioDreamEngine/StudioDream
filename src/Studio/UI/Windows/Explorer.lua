local Things = Runtime.Things
local SelectionManager = Studio.Editor3D.SelectionManager

local Explorer = {}
Explorer.Tree = {}

local AddButtonObject = Runtime.Things.Create("ImageButton") {
    Resource = "Internal/Studio/AddThing.png",
    Size = Pivot2D.FromScale(1,1),
    Position = Pivot2D.FromScale(0.5,0),
    Pivot = Vector2.new(1,0.0001),
    SquareAxis = Enum.SquareAxis.Y,
}

local ScrollContainer

local AddButtonWow = {}

local Order = 0

AddButtonWow = {
    Object = AddButtonObject,
    Connect = AddButtonObject.Clicked:Connect(function()
        printVerbose("Insert open")

        AddButtonWow.IsInsertOpen = true
        Studio.Editor3D.OpenInsertWindow(AddButtonWow.Object)
    end),
    IsInsertOpen = false
}

local function ParentInserter(Obj)
    if AddButtonWow.IsInsertOpen then
        AddButtonWow.IsInsertOpen = false
        Studio.Editor3D.CloseInsertWindow()
    end

    AddButtonWow.Object:SetParent(Obj)
end

local function SetAllChildNodeVisible(NodeObj,Visiblity)
    for i,ChildNodeObj in pairs(NodeObj.ChildrenInNode) do
        ChildNodeObj.Node:SetVisible(Visiblity)
        SetAllChildNodeVisible(ChildNodeObj,Visiblity and ChildNodeObj.IsChildOpen)
    end
end

function Explorer.CreateNode(Object, Depth)
    local NodeObj = {}

    NodeObj.ChildrenInNode = {}

    NodeObj.Node = Things.Create("Square") { 
        Size = Pivot2D.new(0,1,15,0),
        Pivot = Vector2.new(0,0),
        BackgroundTransparency = 1,
        Layer = 3,
        Parent = ScrollContainer,
        Serializable = false,
        CornerRadius = 5,
    }

    NodeObj.Context = Things.Create("Contextulizer") { 
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        --BackgroundTransparency = 1,
        Layer = 999,
        Parent = NodeObj.Node,
        Serializable = false,
        SinkHovering = true,
    }

    NodeObj.Context.OnContextCreate:Connect(function()
        print(Object.Proxy.Duplicatable)
    end)
    NodeObj.Context:SetChoices({
        {Type = "Separator"},
        {
            Type = "Button",
            Text = "Duplicate thing",
            SubText = "Sets cloned thing to current parent",
            Image = "Internal/Studio/ContextMenu/Clone.png",
            Applicable = Object.Proxy.Duplicatable,
            Function = function(Menu)
                Object:Clone():SetParent(Object.Parent)
                Explorer.Redraw()
                Menu.Remove()
            end,
        },
        {
            Type = "Button",
            Text = "Delete thing",
            Image = "Internal/Studio/ContextMenu/Delete.png",
            Applicable = Object.Proxy.Creatable,
            Function = function(Menu)
                Object:Destroy()
                Explorer.Redraw()
                Menu.Remove()
            end,
        },
        {Type = "Separator"},
        {
            Type = "Button",
            Text = "Group thing",
            Image = "Internal/Studio/ContextMenu/Group.png",
            Applicable = Object.Proxy.Creatable,
            Function = function(Menu)
                local Folder = Things.Create("Folder") {Parent = Object.Parent}
                Object:SetParent(Folder) 
                Explorer.Redraw()
                Menu.Remove()
            end,
        },
        {
            Type = "Button",
            Text = "Ungroup thing",
            Image = "Internal/Studio/ContextMenu/Ungruped.png",
            Applicable = Object:IsA("Folder"),
            Function = function(Menu)
                for i,v in pairs(Object:GetChildren()) do
                    v:SetParent(Object.Parent)
                end
                Object:Destroy()
                Explorer.Redraw()
                Menu.Remove()
            end,
        },
        {Type = "Separator"},
        {
            Type = "Button",
            Text = "Insert thing",
            Image = "Internal/Studio/ContextMenu/Ungruped.png",
            Function = function(Menu)
                Studio.Editor3D.OpenInsertWindow()
                Explorer.Redraw()
                Menu.Remove()
            end,
        },
        {Type = "Separator"},
    })

    NodeObj.AlreadyCreatedChilButton = false

    NodeObj.NodeInner = Studio.Components.CreateIconObject(Object.Name, Object.Proxy.ExplorerIcon) -- Actually creates the visual part of the node
    NodeObj.NodeInner:SetSize(Pivot2D.new(-Depth*20,1,0,1))
    NodeObj.NodeInner:SetParent(NodeObj.Node)
    NodeObj.NodeInner.BackgroundColor = Studio.Theme.CurrentTheme.Primary
    NodeObj.CreateChildrenButton = function()
        NodeObj.AlreadyCreatedChilButton = true
        
        NodeObj.Button = Runtime.Things.Create("ImageButton") {
            Resource = "Internal/Studio/OpenMenu.png",
            Size = Pivot2D.FromScale(0.8,0.8),
            BackgroundColor = Studio.Theme.CurrentTheme.Text,
            SquareAxis = Enum.SquareAxis.Y, 
            Position = Pivot2D.FromScale(0,0.5),
            Pivot = Vector2.new(1,0.5),
            Parent = NodeObj.NodeInner,
            Layer = 4,
            ImageRect = Rect.new(Vector2.new(64,0),Vector2.new(64,64))
        }

        NodeObj.IsChildOpen = true

        NodeObj.Button.Clicked:Connect(function()
            NodeObj.IsChildOpen = not NodeObj.IsChildOpen
            SetAllChildNodeVisible(NodeObj,NodeObj.IsChildOpen)
            NodeObj.Button:SetImageRect(Rect.new(
                Vector2.new(NodeObj.IsChildOpen and 64 or 0, 0),
                Vector2.new(64,64)
            ))
        end)
    end

    return NodeObj
end

function Explorer.CreateTree(Object, Depth, BeforeNodeObj)
    Order = Order + 1

    local NodeObj = Explorer.CreateNode(Object, Depth)
    NodeObj.Node.ListOrder = Order
    NodeObj.Node:SetParent(ScrollContainer)
    printVerbose(NodeObj.NodeInner.BackgroundColor)
    Explorer.Tree[Object] = NodeObj.NodeInner
    
    if BeforeNodeObj then
        table.insert(BeforeNodeObj.ChildrenInNode,NodeObj)
        if not BeforeNodeObj.AlreadyCreatedChilButton then
            BeforeNodeObj.CreateChildrenButton()
        end
    end

    for _, Child in pairs(Object:GetChildren()) do
        if Child.Serializable then
            Explorer.CreateTree(Child, Depth + 1, NodeObj)
        end
    end
end

local InputService = Runtime.Services.Service("InputService") ---@class InputService
local Editor3D = Studio.Editor3D
local Selecting
local Hovering

local LastClick = 0

local function HandleDoubleClick(ClickedObject)
    -- I'd make this a little more advanced but scripts are most likely gonna be the only thing here
    if ClickedObject:IsA("BaseScript") then
        Studio.ScriptHandler.HandleOpenScript(ClickedObject)
    end
end

local function HandleDragStart()
    if GlobalTick - LastClick < 0.4 then -- Process Double Click
        HandleDoubleClick(Hovering.Thing)
        return
    end

    Selecting = Hovering
    local Object = Selecting.Thing

    LastClick = GlobalTick

    Selecting.Node:SetMouseLocked(true)

    SelectionManager.SelectObject(Object)
    Explorer.Tree[Object] = nil
end

local function HandleDragEnd()
    Selecting.Node:SetMouseLocked(false)

    if Hovering then
        local CouldParent = Selecting.Thing:SetParent(Hovering.Thing)
        printVerbose(CouldParent)

        if CouldParent then Explorer.Redraw() end
    else
        Explorer.Tree[Selecting.Thing] = Selecting.Node
    end

    Selecting = nil
end

function Explorer.Init()
    ScrollContainer = Things.Create("Square") { --Things.Create("ScrollContainer") { 
        Size = Pivot2D.FromScale(1,1),
        --CanvasSize = Pivot2D.FromScale(1,4),
        BackgroundTransparency = 1,
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Parent = Explorer.Container,
    }

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
    
    InputService.KeyEvent:Connect(function(Began, Key)
        if (Key == "delete" and Editor3D.Selecting) then
            local toDelete = Editor3D.Selecting
            Editor3D.SelectionManager.DeselectAll()
            
            for _, thing in pairs(toDelete) do
                thing:Destroy()
            end

            toDelete = {}

            Explorer.Redraw()
        end
    end)

end

function Explorer.Redraw()
    ScrollContainer:ClearAllChildren()
    
    Explorer.Tree = {}
    Explorer.CreateTree(Things.Root, 0)

    Things.Create("ListLayout") {
        Parent = ScrollContainer,
        Padding = 3,
    }
end

function Explorer.Update(dt)
    Hovering = nil

    for Thing, Object in pairs(Explorer.Tree) do
        local NodeInner = Object
        if NodeInner.Hovering then 
            Hovering = {
                Node = NodeInner,
                Thing = Thing
            }
        end

        if table.find(Studio.Editor3D.Selecting, Thing) then
            NodeInner.BackgroundColor = Studio.Theme.CurrentTheme.Selecting
            ParentInserter(NodeInner)
        else
            NodeInner.BackgroundColor = Studio.Theme.CurrentTheme.Primary -- CHANGE IT HERE!
        end
    end
end

return Explorer