local Things = Runtime.Things
local Components = {}

local Updators = {}

function Components.CreateButton(Name, Properties)
    Properties.Text = Name
    Properties.CornerRadius = 5
    Properties.Alignment = Vector2.new(0.5,0.5)

    ---@class TextButton
    local Button = Components.CreateStyle("TextButton", Properties)
    Button:SetFont(Studio.CurrentTheme.FontBold)
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
        Name = "DropdownElementSimple",
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(200,0),
        Layer = 100
    })

    local DialogWindows = require("Studio.UI.Components.DialogWindows")

    Components.ContextMenu = require("Studio.UI.Components.ContextMenu")
    Components.PropertyValue = require("Studio.UI.Components.PropertyValue")
    Components.DropdownPlus = require("Studio.UI.Components.DropdownPlus")
    Components.Settings = require("Studio.UI.Components.Settings")

    Components.CreateDialog = DialogWindows.CreateDialogWindow
    Components.ShowFade = DialogWindows.ShowFade
    Components.HideFade = DialogWindows.HideFade
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
    local NodeInner = Studio.Components.CreateStyle("TextButton", {
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Size = Pivot2D.new(1,0,0,20),
        BackgroundColor = "Primary",
        --BackgroundTransparency = 0.5,
        Text = "",
        Layer = 3,
        Name = Name,
        SinkHovering = true,
        OutlineSize = 0,
        OutlineColor = "Outline",
        CornerRadius = 5,
    })
    
    local NodeText = Studio.Components.CreateStyle("Text", {
        Size =  Pivot2D.FromScale(0.95,1),
        Position = Pivot2D.FromScale(0.55,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Text = Name,
        Name = "NodeText",
        Parent = NodeInner,
        BackgroundTransparency = 1,
        ForegroundColor = "Text"
    })

    local NotFoundIcon = Runtime.Resources.GetIdentifierFromID("Internal/Studio/EditorIcons/File_Not_Found.png")
    local Icon = Runtime.Resources.GetIdentifierFromID("Internal/Studio/EditorIcons/" .. Icon .. ".png") or NotFoundIcon
    
    local NodeIcon = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(0.1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Pivot = Vector2.new(-0.1,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Resource = Icon,
        Parent = NodeInner
    })
    
    return NodeInner
end

function Components.CreateContainer(Size, Parent)
    return Things.Create("TextButton") {
        BackgroundTransparency = 0,
        Text = "",
        Size = Size,
        Name = "ContainerComponent",
        Parent = Parent
    }
end

function Components.PropertyList(Size, Parent)
    return {
        Size = Size,
        Parent = Parent
    }
end

---@param List BaseGui
function Components.ExpandableDropdown(Header, List)
    assert(List:FindFirstChildOfClass("ListLayout"), "Components.ExpandableDropdown is only intended for ListLayouts!")
    local ExpandableDropdown = {
        Visible = true -- Shit's getting crowded...
    }

    ExpandableDropdown.VisibleChanged = Signal:New("Unexpand")

    --[[ExpandableDropdown.OuterContainer = Runtime.Things.Create("Square") { 

    }]]

    ExpandableDropdown.Button = Studio.Components.CreateStyle("ImageButton",{
        Resource = "Internal/Studio/OpenMenu.png",
        Size = Pivot2D.FromScale(0.8,0.8),
        BackgroundColor = "Text",
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = Header,
        IgnoreConstraints = true,
        ImageRect = Rect.new(Vector2.new(64,0),Vector2.new(64,64)),
        ForegroundColor = "Text",
    })

    ExpandableDropdown.Container = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(0.98,1),
        Name = Header.Name.."1",
        AutomaticSize = Enum.AutomaticSize.Y,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0.5,1),
        BackgroundTransparency = 1,
        BackgroundColor = "Outline",
        Layer = 3,
        Order = Header.Order,
        Parent = List,
    })

    ExpandableDropdown.Layout = Studio.Components.CreateStyle("ListLayout",{
        Parent = ExpandableDropdown.Container,
        Alignment = Enum.Alignment.TopCenter,
        Padding = 2,
    })

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

local Styles = {
    Container = {
        BackgroundColor = "Secondary",
        ForegroundColor = "Text"
    },
    Seperator = {
        BackgroundColor = "Outline",
        CornerRadius = 2
    },
    RoundedContainer = {
        BackgroundColor = "Secondary",
        ForegroundColor = "Text",
        Font = "FontNormal",
        CornerRadius = 2
    },
    Text = {
        BackgroundTransparency = 1,
        BackgroundColor = "Text",
        Font = "FontNormal"
    },
}

local TypeAssociations = {
    Text = "Text",
    TextButton = "RoundedContainer",
    TextInput = "Text",
    Square = "Container",
    Image2D = "Container",
    ImageButton = "Container"
}

function Components.CreateDropshadow(Parent)
    return Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.new(1,30,1,30),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Resource = "Internal/Studio/Blur.png",
        ForegroundColor = Color.new(0,0,0),
        Name = "Shadow",
        ForegroundTransparency = 0.5,
        Parent = Parent,
        NineSlice = Rect.new(Vector2.new(25,25), Vector2.new(25,25)),
        FilterType = Enum.FilterType.Default,
        Layer = -1,
        IgnoreConstraints = true
    })
end

local ComponentRegistry = setmetatable({}, {
    __mode = "k"
})

function Components.RegisterToTheme(Object, PropertyName, PaletteID)
    if (not ComponentRegistry[Object]) then ComponentRegistry[Object] = {} end

    Runtime.Things.SetProperty(Object, PropertyName, Studio.CurrentTheme[PaletteID])

    table.insert(ComponentRegistry[Object], {
        ColorName = PaletteID,
        PropertyName = PropertyName
    })
end

Studio.Theme.ThemeChanged:Connect(function()
    for Object, ThemeConfigurations in pairs(ComponentRegistry) do
        for _, v in pairs(ThemeConfigurations) do
            if (not Studio.CurrentTheme[v.ColorName]) then
                print(Studio.CurrentTheme, v.ColorName)
            end

            Runtime.Things.SetProperty(Object, v.PropertyName, Studio.CurrentTheme[v.ColorName])
        end
    end
end)

function Components.CreateStyle(Type, Properties, Style)
    local MatchedUpOnTheme = {}
    local ThingCreated
    
    if (not Style) then
        Style = TypeAssociations[Type]
    end

    if Style then
        for Name, Value in pairs(Styles[Style]) do
            if (not Properties[Name]) then
                Properties[Name] = Value
            end
        end
    end

    local function SetupTheme()
        for Name, Value in pairs(Properties) do
            local ApiDump = Runtime.Things.API[Type]
            local IntendedType = ApiDump.Types[Name]

            if (IntendedType == "Color" or Name == "Font") and table.find(Studio.Theme.GetThemePalette(), Value) then
                table.insert(MatchedUpOnTheme,{ColorName = Value,PropertyName = Name})

                Properties[Name] = Studio.CurrentTheme[Value]
            end
        end
    end

    SetupTheme()

    ---@class Thing
    ThingCreated = Things.Create(Type) (Properties)
    ComponentRegistry[ThingCreated] = MatchedUpOnTheme

    ThingCreated.OnDestroy:ConnectOnce(function()
        ComponentRegistry[ThingCreated] = nil
    end)

    return ThingCreated
end

function Components.Update(dt)
    for _, Updator in pairs(Updators) do
        Updator(dt)
    end
end

return Components