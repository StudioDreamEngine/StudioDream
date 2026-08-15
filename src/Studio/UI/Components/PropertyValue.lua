local Components = Studio.Components
local Things = Runtime.Things

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

        return function(Value)
            ValueObject:SetText(Value)
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
]]
return function(PropertyList, Information)
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
        Name = "ValueContainer",
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
            Layer = 10,
            BackgroundTransparency = 1,
            Resource = "Internal/Studio/"..Information.Icon
        })
    end

    PropertyValue.PropUpdator = ValueTypes[Information.Type](ValueContainer, Information)

    -- Called every time the PropertyValue should be updated
    Information.OnUpdate = function()
        local UpdateResult = tostring(Information.Update())
        printVerbose("PropertyValue OnUpdate Result w/ "..UpdateResult)

        PropertyValue.PropUpdator(UpdateResult)
    end

    -- Called every time the user changes the value
    Information.OnChange = function(Value)
        printVerbose("PropertyValue OnChange w/ "..Value)

        Information.UserChange(Value)
        Information.OnUpdate()
    end

    Information.OnUpdate()

    return PropertyValue
end