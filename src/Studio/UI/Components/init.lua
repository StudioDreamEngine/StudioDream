local Things = Runtime.Things
local Components = {}

local Updators = {}

function Components.CreateButton(Name, Properties)
    Properties.Text = Name
    Properties.CornerRadius = 5
    Properties.Alignment = Vector2.new(0.5,0.5)

    ---@class TextButton
    local Button = Components.CreateStyle("TextButton", Properties)
    Button:SetFont(Studio.Theme.CurrentTheme.FontBold)
    return Button
end

---@class Square
local DropdownFrame

function Components.RegisterUpdator(Updator) 
    local UUID = CreateUUID()
    Updators[UUID] = Updator 
    return UUID
end
function Components.UnregisterUpdator(UUID) Updators[UUID] = nil end

function Components.Init()
    print("Initalizing Studio Components")

    DropdownFrame = Components.CreateStyle("Square", {
        Parent = Things.Root.RootViewport,
        Name = "DropdownElement",
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(200,0),
        Layer = 100
    })

    local DialogWindows = require("Studio.UI.Components.DialogWindows")

    Components.AdvancedDropdown = require("Studio.UI.Components.AdvancedDropdown")
    Components.CreateDialog = DialogWindows.CreateDialogWindow
    Components.DropdownPlus = require("Studio.UI.Components.DropdownPlus")
    Components.ShowFade = DialogWindows.ShowFade
    Components.HideFade = DialogWindows.HideFade
    Components.ContextMenu = require("Studio.UI.Components.ContextMenu")
    Components.ContextMenu.Init()
    Shared.AbortAPI = Components.SimpleDialog
end

function Components.SimpleDialog(Text, Callback)
    Studio.Components.CreateDialog("Option", {
        Text = Text,
        OnClick = Callback
    })
end

function Components.CreateIconObject(Name, Icon)
    local NodeInner = Things.Create("TextButton") {
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Size = Pivot2D.new(0,1,20,0),
        BackgroundColor = Studio.Theme.CurrentTheme.Primary,
        --BackgroundTransparency = 0.5,
        Text = "",
        Layer = 3,
        Name = Name,
        SinkHovering = true,
        --[[OutlineSize = 0.5,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline,]]
        CornerRadius = 5,
    }
    
    local NodeText = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.95,1),
        Position = Pivot2D.FromScale(0.55,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Text = Name,
        Name = "NodeText",
        Parent = NodeInner,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.CurrentTheme.Text
    }

    local NotFoundIcon = Runtime.Resources.GetIdentifierFromID("Internal/Studio/EditorIcons/File_Not_Found.png")
    local Icon = Runtime.Resources.GetIdentifierFromID("Internal/Studio/EditorIcons/" .. Icon .. ".png") or NotFoundIcon
    
    local NodeIcon = Things.Create("Image2D") {
        Size = Pivot2D.new(0,0.1,0,1),
        SquareAxis = Enum.SquareAxis.Y,
        Pivot = Vector2.new(-0.1,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Resource = Icon,
        Parent = NodeInner
    }
    
    return NodeInner
end

---@param List BaseGui
function Components.ExpandableDropdown(Header, List)
    assert(List:FindFirstChildOfClass("ListLayout"), "Components.ExpandableDropdown is only intended for ListLayouts!")
    local ExpandableDropdown = {
        Visible = true -- Shit's getting crowded...
    }

    ExpandableDropdown.VisibleChanged = Signal:New("Unexpand")

    ExpandableDropdown.Button = Runtime.Things.Create("ImageButton") {
        Resource = "Internal/Studio/OpenMenu.png",
        Size = Pivot2D.FromScale(0.8,0.8),
        BackgroundColor = Studio.Theme.CurrentTheme.Text,
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = Header,
        ImageRect = Rect.new(Vector2.new(64,0),Vector2.new(64,64))
    }

    ExpandableDropdown.Container = Things.Create("Square") { 
        Size = Pivot2D.FromScale(0.98,1),
        AutomaticSize = Enum.AutomaticSize.Y,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0.5,1),
        BackgroundTransparency = 1,
        BackgroundColor = Studio.Theme.CurrentTheme.Outline,
        Layer = 3,
        Order = Header.Order,
        Parent = List,
    }

    ExpandableDropdown.Layout = Things.Create("ListLayout") {
        Parent = ExpandableDropdown.Container,
        Alignment = Enum.Alignment.TopCenter,
        Padding = 2,
    }

    function ExpandableDropdown.Toggle(Visible)
        ExpandableDropdown.Visible = Visible
        ExpandableDropdown.Container:SetVisible(Visible)
        ExpandableDropdown.Button:SetImageRect(Rect.new(
            Vector2.new(ExpandableDropdown.Visible and 64 or 0, 0),
            Vector2.new(64,64)
        ))
    end

    ExpandableDropdown.Button.Clicked:Connect(function()
        ExpandableDropdown.Toggle(not ExpandableDropdown.Visible)  
        ExpandableDropdown.VisibleChanged.Invoke(ExpandableDropdown.Visible) 
    end)
    
    return ExpandableDropdown
end

function Components.SimpleDropdown(Position, Choices, Size)
    if (not Size) then Size = {} end

    local ButtonsActions = {}

    local CurrentDropdown = DropdownFrame
    
    -- Special code for positioning below an object
    if Position.Type == "Thing" then
        Size = Position.AbsoluteSize
        Position = Position.AbsolutePosition + (Position.AbsoluteSize * Vector2.yAxis)
    end

    local Dropdown = {}

    CurrentDropdown:ClearAllChildren()
    CurrentDropdown:SetPosition(Pivot2D.FromOffset(Position))
    CurrentDropdown:SetVisible(true)

    CurrentDropdown:SetSize(Pivot2D.FromOffset(Size.X or 200,0))

    for _, Choice in pairs(Choices) do
        local Button = Components.CreateStyle("TextButton", {
            Text = Choice.Text,
            Clicked = Choice.Function,
            Name = "SimpleDropdown",
            Size = Pivot2D.new(0,1,Size.Y or 20,0),
            Parent = CurrentDropdown,
            BackgroundTransparency = 1
        })

        Button.OutlineColor = Studio.Theme.CurrentTheme.SecondaryOutline
        table.insert(ButtonsActions,Button.Clicked)
    end

    Things.Create("ListLayout") {
        Parent = CurrentDropdown
    }

    function Dropdown:RemoveDropdown()
        CurrentDropdown:SetVisible(false)
    end

    CurrentDropdown:SetParent(Things.Root.RootViewport) -- This makes them appear already loaded dont remove!

    return Dropdown
end

function Components.CreateStyle(Type, Properties)
    Properties.BackgroundColor = Studio.Theme.CurrentTheme.Secondary
    Properties.ForegroundColor = Studio.Theme.CurrentTheme.Text
    --[[Properties.OutlineSize = 1.5
    Properties.OutlineColor = Studio.Theme.GetCurrentTheme().Outline]]
   
    return Things.Create(Type) (Properties)
end

function Components.Update(dt)
    for _, Updator in pairs(Updators) do
        Updator(dt)
    end
end

return Components