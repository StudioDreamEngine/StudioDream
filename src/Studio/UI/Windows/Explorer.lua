local Things = Runtime.Things
local SelectionManager = Studio.Editor3D.SelectionManager

local Explorer = {}
Explorer.Tree = {}

local AddButtonObject = Runtime.Things.Create("ImageButton") {
    Resource = "Internal/Icons/Engine/AddThing.png",
    Size = Pivot2D.FromScale(1,1),
    Position = Pivot2D.FromScale(0.5,0),
    Pivot = Vector2.new(1,0.0001),
    SquareAxis = Enum.SquareAxis.Y,
}

local AddButtonWow = {}

local Order = 0
local Window

AddButtonWow = {
    Object = AddButtonObject,
    Connect = AddButtonObject.Clicked:Connect(function()
        print("Insert open")

        AddButtonWow.IsInsertOpen = true
        Studio.Editor3D.OpenInsertWindow(AddButtonWow.Object)
        Explorer.Redraw()
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
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Layer = 2,
        BackgroundTransparency = 0.5,
        Parent = Node,
    }

    local NodeInner = Studio.Components.CreateIconObject(Object.Name, Object.Proxy.ExplorerIcon)
    NodeInner:SetSize(Pivot2D.new(-Depth*20,1,0,1))
    NodeInner:SetParent(Node)

    return Node, NodeInner
end

function Explorer.CreateTree(Object, Depth)
    Order = Order + 1

    local Node, NodeInner = Explorer.CreateNode(Object, Depth)
    Node.ListOrder = Order
    Node:SetParent(Window)

    Explorer.Tree[Object] = NodeInner

    for _, Child in pairs(Object:GetChildren()) do
        if Child.Serializable then
            Explorer.CreateTree(Child, Depth + 1)
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
    print("Drag end")
    Selecting.Node:SetMouseLocked(false)

    if Hovering then
        local CouldParent = Selecting.Thing:SetParent(Hovering.Thing)
        print(CouldParent)

        if CouldParent then Explorer.Redraw() end
    else
        Explorer.Tree[Selecting.Thing] = Selecting.Node
    end

    Selecting = nil
end

function Explorer.Init()
    Window = Explorer.Container

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
            Editor3D.SelectionManager.DeselectObject()
            toDelete:Destroy()
            Explorer.Redraw()
        end
    end)

end

function Explorer.Redraw()
    Window:ClearAllChildren()
    
    Explorer.CreateTree(Things.Root, 0)

    Things.Create("ListLayout") {
        Parent = Window
    }
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
            Object.BackgroundColor = Studio.Theme.GetCurrentTheme().Selecting
            ParentInserter(Object)
        else
            Object.BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary
        end
    end
end

return Explorer