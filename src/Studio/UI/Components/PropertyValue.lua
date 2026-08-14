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

        return function()
            ValueObject:SetText(Info.OnUpdate())
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
        return tostring(Information.Update())
    end

    PropertyValue.PtopUpdator = ValueTypes[Information.Type](ValueContainer, Information)
    PropertyValue.PtopUpdator()

    Information.OnChange = function(Value)
        Information.Change(Value)
        PropertyValue.PropUpdator()
    end

    return PropertyValue
end