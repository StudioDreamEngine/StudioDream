local Components = Studio.Components
local Things = Runtime.Things

-- All Value types for PropertyValue, returns their Update function
local ValueTypes = {
    Input = function(Parent, Info)
        ---@class TextInput
        local ValueObject = Studio.Components.CreateStyle("TextInput", {
            Position = Pivot2D.FromScale(0,0),
            Alignment = Enum.Alignment.MiddleLeft,
            Size = Pivot2D.FromScale(1,0.85),
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

        return function(Value)
            ValueObject:SetText(Value)
        end, ValueObject
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

        Button.Clicked:Connect(function()
            Info.OnChange(not Value)
        end)

        return function(InValue)
            Value = Utils.Boolean(InValue)
            Button:SetImageRect(Rect.new(LineUp[Value],Vector2.new(64,64)))
        end
    end,
    Dropdown = function(Parent, Info)
        ---@class TextButton
        local ValueObject = Studio.Components.CreateStyle("TextButton", {
            Position = Pivot2D.FromScale(0,0.5),
            IgnoreConstraints = true, -- HACK
            Pivot = Vector2.new(0,0.5),
            Alignment = Enum.Alignment.Center,
            Size = Pivot2D.FromScale(1,0.9),
            ForegroundColor = "Text",
            Placeholder = Info.Placeholder or "None",
            Parent = Parent,
        })

        local Choices = {}
        assert(Info.Choices, "Choices missing from PropertyValue info")

        for _, Choice in pairs(Info.Choices) do
            table.insert(Choices, {
                Type = "Button",
                Text = Choice,
                Function = function()
                    Info.OnChange(Choice)
                end
            })
        end

        local Dropdown = Studio.Components.DropdownPlus.new(Choices, ValueObject)
        Dropdown.Toggle(false)

        ValueObject.Clicked:Connect(Dropdown.Toggle)

        return function(Value)
            ValueObject:SetText(Value)
        end
    end
}

--[[
    PropertyList: PropertyList Object created with Components.PropertyList
    Information: {
        Icon = Thing
        Title = "Hello",
        Type = "Dropdown", "Input" or "Checkbox",
        Translate = "Any Type" -- Will translate the string of the input to an actual value (Input only)
        Update = function() -- Called each time the updator is called, return a text-friendly version of `Value`
            return Value -- Will be tostring'ed
        end,
        UserChange = function(Text) -- Called every time the user changes the value, its your job to take `Text` and update the corresponding `Value`
            Value = Blah(Text)
        end,
        Choices = { -- Choices list (dropdown only)
            "a",
            "b"
        }
    }
    Style:
        Text = "Text",
        Image = "Text",
        Square = "Outline"
]]

local TranslateTable = { -- I hate i have to do this
    ["Vector3"] = Vector3,
    ["Vector2"] = Vector2,
    ["Transform3D"] = Transform3D,
    ["Rect"] = Rect,
    ["Pivot2D"] = Pivot2D,
    ["Color"] = Color,
}

local ValueFunction = function(PropertyList, Information, Style)
    local PropertyValue = {}
    Style = Style or {}
    PropertyValue.UI = {}

    local Container = Components.CreateContainer(PropertyList.Size, PropertyList.Parent)
    local HasTitle = Information.Title

    PropertyValue.UI.Container = Container

    if HasTitle then
        PropertyValue.UI.Title = Studio.Components.CreateStyle("Text", {
            Text = Information.Title,
            Pivot = Vector2.new(0,0.5),
            Position = Pivot2D.FromScale(0.05,0.5),
            Size = Pivot2D.FromScale(0.4,0.6),
            BackgroundTransparency = 1,
            ForegroundColor = Style.Title or "Text",
            Parent = Container,
            Alignment = Enum.Alignment.Center,
            Font = Style.TitleFont or "FontBold" 
        })
    end

    PropertyValue.UI.ValueContainer = Studio.Components.CreateStyle("Square", {
        Size = Pivot2D.FromScale(HasTitle and 0.48 or 1,0.85),
        Pivot = Vector2.new(0,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Name = "ValueContainer",
        BackgroundColor = Style.ValueContainer or "Outline",
        BackgroundTransparency = (Information.Type ~= "Checkbox") and 0 or 1, -- hard-coded but im too lazy
        Parent = Container,
        CornerRadius = 5
    })

    Things.Create("ListLayout") {
        Parent = PropertyValue.UI.ValueContainer,
        Padding = 5,
        Direction = Enum.LayoutDirection.Horizontal
    }

    if Information.Icon then
        PropertyValue.UI.Icon = Studio.Components.CreateStyle("Image2D", {
            Size = Pivot2D.FromScale(1,1),
            Parent = PropertyValue.UI.ValueContainer,
            SquareAxis = Enum.SquareAxis.Y,
            Layer = 10,
            BackgroundTransparency = 1,
            Resource = "Internal/Studio/"..Information.Icon
        })
    end

    PropertyValue.PropUpdator,PropertyValue.Prop = ValueTypes[Information.Type](PropertyValue.UI.ValueContainer, Information)

    -- Called every time the PropertyValue should be updated
    Information.OnUpdate = function()
        local UpdateResult = tostring(Information.Update())
        printVerbose("PropertyValue OnUpdate Result w/ "..UpdateResult)

        PropertyValue.PropUpdator(UpdateResult)
    end

    -- Called every time the user changes the value

    if Information.StyleSelect then
        local ToggleThing = false

        local function UpdateSelect()  
            if ToggleThing then
                if Information.Type == "Input" then
                    PropertyValue.Prop:FocusHere()
                end
                PropertyValue.UI.Container.BackgroundColor = Studio.CurrentTheme["Selecting"]
            else
                PropertyValue.UI.Container.BackgroundColor = Studio.CurrentTheme[Style.Container or "Primary"]
            end
        end
        
        local ContainerSignal = Container:AddPlaceholderSignal(Runtime.InterfaceManager.OnClick:Connect(function()
            if Container.Hovering then return end
            ToggleThing = false
            UpdateSelect()
        end))

        Container.Clicked:Connect(function()
            ToggleThing = not ToggleThing
            UpdateSelect()
        end)
    end

    Information.OnChange = function(Value)
        printVerbose("PropertyValue OnChange w/ "..Value)
        if Information.Translate then
            Value = TranslateTable[Information.Translate].FromString(Value)
        end
        Information.UserChange(Value)
        Information.OnUpdate()
    end

    PropertyValue.UI.Container.BackgroundColor = Studio.CurrentTheme[Style.Container or "Primary"]
    PropertyValue.UI.Container.CornerRadius = 5

    Information.OnUpdate()

    if Information.Subs then
        PropertyValue.UI.SubContainer = Studio.Components.ExpandableDropdown(PropertyValue.UI.ValueContainer, PropertyList.Parent).Container
        for _,Object in pairs(Information.Subs) do
            Object.UI.Container:SetParent(PropertyValue.UI.SubContainer)
        end
    end

    return PropertyValue
end

return ValueFunction