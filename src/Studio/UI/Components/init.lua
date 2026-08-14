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
    local NodeInner = Studio.Components.CreateStyle("TextButton", {
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Size = Pivot2D.new(0,1,20,0),
        BackgroundColor = "Primary",
        --BackgroundTransparency = 0.5,
        Text = "",
        Layer = 3,
        Name = Name,
        SinkHovering = true,
        OutlineSize = 0.2,
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
        Size = Pivot2D.new(0,0.1,0,1),
        SquareAxis = Enum.SquareAxis.Y,
        Pivot = Vector2.new(-0.1,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Resource = Icon,
        Parent = NodeInner
    })
    
    return NodeInner
end

function Components.CreateContainer(Size, Parent)
    return Things.Create("Square") {
        BackgroundTransparency = 1,
        Size = Size,
        Parent = Parent
    }
end

function Components.PropertyList(Size, Parent)
    return {
        Size = Size,
        Parent = Parent
    }
end

-- All Value types for PropertyValue, returns their Update function
local ValueTypes = {
    Input = function(Parent, Info)
        ---@class TextInput
        local ValueObject = Studio.Components.CreateStyle("TextInput", {
            Position = Pivot2D.FromScale(1,0.5),
            Pivot = Vector2.new(0,0),
            Alignment = Enum.Alignment.MiddleLeft,
            Size = Pivot2D.FromScale(1,0.9),
            ForegroundColor = "Text",
            Placeholder = Info.Placeholder or "0",
            Parent = Parent,
        })

        ValueObject.FocusEnd:Connect(function()
            Info.OnChange(ValueObject.Text)
        end)

        Things.Create("Flex") {
            Parent = ValueObject
        }

        return function()
            ValueObject:SetText(tostring(Info.OnUpdate()))
        end
    end,
    Checkbox = function(Parent, Info)
        -- Mikls code.. im lazy...
        local LineUp = {
            ["true"] = Vector2.new(64,0),
            ["false"] = Vector2.new(128,0),
            ["nil"] = Vector2.new(0,0)
        }

        local Value

        ---@class ImageButton
        local Button = Studio.Components.CreateStyle("ImageButton",{
            Resource = "Internal/Studio/Boolean.png",
            Size = Pivot2D.FromScale(1,1),
            SquareAxis = Enum.SquareAxis.Y,
            Parent = Parent,
            ForegroundColor = "Text",
            SinkHovering = true,
        })

        -- Mikls code.. im lazy... (2)
        local function UpdateButton(Property)
            Value = Property
            Button:SetImageRect(Rect.new(LineUp[Property],Vector2.new(64,64)))
        end

        Button.Clicked:Connect(function()
            Info.OnChange(not Value)
        end)

        return function()
            local Update = Info.OnUpdate()
            local Final

            -- God... why..........
            if (type(Update) ~= "nil") then Final = (Update and true or false)
            else Final = nil end

            UpdateButton(Final)
        end
    end,
    Dropdown = function()
        -- TODO
    end
}

--[[
    Information: {
        Icon = Thing
        Title = "Hello",
        Type = "Dropdown", "Input" or "Checkbox",
        Update = function() -- Called each time the updator is called
            return Value -- Will be tostring'ed
        end,
        Change = function(Text) -- Called every time the user changes the value
            Value = Blah(Text)
        end
    }
]]
function Components.PropertyValue(PropertyList, Information)
    local PropertyValue = {}

    local Container = Components.CreateContainer(PropertyList.Size, PropertyList.Parent)
    local HasTitle = Information.Title

    if HasTitle then
        Studio.Components.CreateStyle("Text", {
            Text = Information.Title,
            Size = Pivot2D.FromScale(HasTitle and 0.45 or 1,1),
            BackgroundTransparency = 1,
            ForegroundColor = "Text",
            Parent = Container
        })
    end

    local ValueContainer = Studio.Components.CreateStyle("Square", {
        Size = Pivot2D.FromScale(HasTitle and 0.5 or 1,0.8),
        Pivot = Vector2.new(1,0.5),
        Position = Pivot2D.FromScale(1,0.5),
        BackgroundColor = "Outline",
        BackgroundTransparency = (Information.Type ~= "Checkbox") and 0 or 1, -- hard-coded but im too lazy
        Parent = Container,
        CornerRadius = 5
    })

    Things.Create("ListLayout") {
        Parent = ValueContainer,
        Padding = 5,
        Direction = Enum.LayoutDirection.Horizontal
    }

    if Information.Icon then
        Studio.Components.CreateStyle("Image2D", {
            Size = Pivot2D.FromScale(1,1),
            Parent = ValueContainer,
            SquareAxis = Enum.SquareAxis.Y,
            BackgroundTransparency = 1,
            Resource = "Internal/Studio/"..Information.Icon
        })
    end

    Information.OnUpdate = function()
        return Information.Update()
    end

    PropertyValue.PtopUpdator = ValueTypes[Information.Type](ValueContainer, Information)
    PropertyValue.PtopUpdator()

    Information.OnChange = function(Value)
        Information.Change(Value)
        PropertyValue.PropUpdator()
    end

    return PropertyValue
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
        Size = Pivot2D.new(30,1,30,1),
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

local ComponentRegistry = {}

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

    --[[for i,v in pairs(MatchedUpOnTheme) do
        --[[if v.PropertyName ~= "Font" then
            ThingCreated[v.PropertyName] = Studio.CurrentTheme[v.SettingInTheme]
        else
            ThingCreated:SetFont(Studio.CurrentTheme[v.SettingInTheme])
        end
        --LoadFromTheme()
    end]]
end)

function Components.CreateStyle(Type, Properties, Style)
    local MatchedUpOnTheme = {}
    local Signalwow
    --local Itwasbetterifimadeatable
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

        --MatchedUpOnTheme = {}
        --[[for ProName,ProVal in pairs(ThingCreated.Proxy.Serializable) do
            for ConfigName,Value in pairs(TableOfTheme) do
                if ThingCreated[ProName] == Value then
                    table.insert(MatchedUpOnTheme,{SettingInTheme = ConfigName,ValueName = ProName})
                end
                if ProName == "Font" then
                    --print(ThingCreated[ProName])
                    if ThingCreated[ProName] and ThingCreated[ProName].ID == Value then
                        table.insert(MatchedUpOnTheme,{SettingInTheme = ConfigName,ValueName = ProName})
                    end 
                end
            end
        end]]
    end

    SetupTheme()

    ---@class Thing
    ThingCreated = Things.Create(Type) (Properties)
    ComponentRegistry[ThingCreated] = MatchedUpOnTheme

    return ThingCreated
end

function Components.Update(dt)
    for _, Updator in pairs(Updators) do
        Updator(dt)
    end
end

return Components