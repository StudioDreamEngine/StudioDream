local Components = Studio.Components
local Things = Runtime.Things

-- All Value types for PropertyValue, returns their Update function
local ValueTypes = {
    Input = function(Parent, Info)
        local CanBeActive

        if Info.Disabled then
            CanBeActive = false
        else
            CanBeActive = true
        end

        ---@class TextInput
        local ValueObject = Studio.Components.CreateStyle("TextInput", {
            Position = Pivot2D.FromScale(0,0),
            Alignment = Enum.Alignment.MiddleLeft,
            Size = Pivot2D.FromScale(1,0.85),
            ForegroundColor = "Text",
            Placeholder = Info.Placeholder or "0",
            Parent = Parent,
            ForegroundTransparency = Info.Disabled and 0.5 or 0,
            Active = CanBeActive
        })

        ValueObject.FocusEnd:Connect(function()
            if not Info.Disabled then 
                Info.OnChange(ValueObject.Text)
            end
        end)

        if Info.Icon then
            Things.Create("Flex") {
                Parent = ValueObject
            }
        end

        return function(Value)
            ValueObject:SetText(Value)
        end, ValueObject
    end,
    Checkbox = function(Parent, Info)
        local CanBeActive

        if Info.Disabled then
            CanBeActive = false
        else
            CanBeActive = true
        end
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
            ForegroundTransparency = Info.Disabled and 0.5 or 0,
            Active = CanBeActive,
        })

        Button.Clicked:Connect(function()
            if not Info.Disabled then
                Info.OnChange(not Value)
            end
        end)

        return function(InValue)
            Value = Utils.Boolean(InValue)

            Button:SetImageRect(Rect.new(LineUp[(type(InValue) == "string" and InValue or Value)],Vector2.new(64,64)))
        end, Button
    end,
    Dropdown = function(Parent, Info)
        ---@class TextButton
        local ValueObject = Studio.Components.CreateStyle("TextButton", {
            Position = Pivot2D.FromScale(0,0.5),
            IgnoreOverrides = true, -- HACK
            Pivot = Vector2.new(0,0.5),
            Alignment = Enum.Alignment.Center,
            Size = Pivot2D.FromScale(1,0.9),
            ForegroundColor = "Text",
            Placeholder = Info.Placeholder or "None",
            ForegroundTransparency = Info.Disabled and 0.5 or 0,
            Parent = Parent,
        })

        local Button = Studio.Components.CreateStyle("Image2D",{
            Resource = "Internal/Studio/OpenMenu.png",
            Size = Pivot2D.FromScale(0.8,0.8),
            BackgroundColor = "Text",
            SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
            Position = Pivot2D.FromScale(1,0.5),
            Pivot = Vector2.new(1,0.5),
            Parent = ValueObject,
            IgnoreOverrides = true,
            ImageRect = Rect.new(Vector2.new(64,0),Vector2.new(64,64)),
            ForegroundColor = "Text",
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

        table.clear(Info.Choices)
        table.clear(Choices)

        ValueObject.Clicked:Connect(function()
            if not Info.Disabled then
                Dropdown.Toggle()
                Button:SetImageRect(Rect.new(
                    Vector2.new(Dropdown.Visible and 64 or 0, 0),
                    Vector2.new(64,64)
                ))
            end 
        end)

        return function(Value)
            ValueObject:SetText(Value)
        end, ValueObject
    end,
    Button = function(Parent, Info)
        ---@class TextButton
        local ValueObject = Studio.Components.CreateStyle("TextButton", {
            Position = Pivot2D.FromScale(0,0.5),
            IgnoreOverrides = true, -- HACK
            Pivot = Vector2.new(0,0.5),
            Alignment = Enum.Alignment.Center,
            Size = Pivot2D.FromScale(1,0.9),
            ForegroundColor = "Text",
            Placeholder = Info.Placeholder or "None",
            ForegroundTransparency = Info.Disabled and 0.5 or 0,
            Parent = Parent,
        })

        ValueObject.Clicked:Connect(function()
            if Info.Disabled then return end

            
            local RequestText = Info.UserRequest(Info.OnChange) or (Info.ReturnDisplay() and tostring(Info.ReturnDisplay()) or "")
            Info.PropUpdator(RequestText)
        end)

        return function(Value)
            ValueObject:SetText(Value)
        end, ValueObject
    end,
    Slider = function() -- TODO
        
    end
}

--[[
    PropertyList: PropertyList Object created with Components.PropertyList
    Information: {
        Icon = Thing
        Title = "Hello",
        Type = "Dropdown", "Input" or "Checkbox",
        Translate = "Any Type" -- Will translate the string of the input to an actual value (Input only)
        ReturnDisplay = function() -- Called each time the updator is called, return a text-friendly version of `Value`
            return Value -- Will be tostring'ed
        end,
        UserChange = function(Text) -- Called every time the user changes the value, its your job to take `Text` and update the corresponding `Value`
            Value = Blah(Text)
        end,
        UserRequest = function(Change) -- Only for buttons, called on click, the passed change function is to be called when ready for it to be
            Scheduler.Wait(5)
            Change("Hello!!")
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

local PropertyValue = {}

function PropertyValue.New(PropertyList, Information, Style)
    local Object = {}
    Style = Style or {}
    Object.UI = {}

    local Container = Studio.Components.CreateStyle(Information.StyleSelect and "TextButton" or "Square", {
        BackgroundTransparency = 0,
        Text = Information.Title,
        Size = PropertyList.Size,
        ForegroundColor = "Text",
        Name = Information.Name or "Container",
        CornerRadius = 5,
        Alignment = Vector2.new(0.05,0.5),
        Parent = PropertyList.Parent
    })

    local HasTitle = Information.Title

    Object.UI.Container = Container

    Studio.Components.RegisterToTheme(Container, "BackgroundColor", Style.Container or "Primary")

    if not Information.StyleSelect and HasTitle then
        Object.UI.Title = Studio.Components.CreateStyle("Text", {
            Text = Information.Title,
            Pivot = Vector2.new(0,0.5),
            Position = Pivot2D.FromScale(0.05,0.5),
            Size = Pivot2D.FromScale(0.4,0.95),
            BackgroundTransparency = 1,
            ForegroundColor = Style.Title or "Text",
            Parent = Container,
            Alignment = Enum.Alignment.MiddleLeft,
            Font = Style.TitleFont or "FontNormal",
            ForegroundTransparency = Information.Disabled and 0.5 or 0,
        })
    end

    Object.UI.ValueContainer = Studio.Components.CreateStyle("Square", {
        Size = Pivot2D.FromScale(HasTitle and 0.48 or 1,0.85),
        Pivot = Vector2.new(0,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Name = "ValueContainer",
        BackgroundColor = Style.ValueContainer or "Outline",
        BackgroundTransparency = (Information.Type ~= "Checkbox") and 0 or 1, -- hard-coded but im too lazy
        Parent = Container,
        CornerRadius = 5
    })

    if Information.Icon then
        Things.Create("ListLayout") {
            Parent = Object.UI.ValueContainer,
            Padding = 5,
            Direction = Enum.LayoutDirection.Horizontal
        }

        if type(Information.Icon) ~= "boolean" then
            Object.UI.Icon = Studio.Components.CreateStyle("Image2D", {
                Size = Pivot2D.FromScale(1,1),
                Parent = Object.UI.ValueContainer,
                SquareAxis = Enum.SquareAxis.Y,
                Layer = 10,
                BackgroundTransparency = 1,
                Resource = "Internal/Studio/"..Information.Icon
            })
        end
    end

    Information.PropUpdator, Object.Prop = PropertyValue.CreateValue(Information.Type, Object.UI.ValueContainer, Information)

    -- Called every time the Object should be updated
    Information.OnUpdate = function()
        local Success, Message = pcall(function()
            local UpdateResult = tostring(Information.ReturnDisplay()) or "nil"

            --printVerbose("Object OnUpdate Result w/ "..UpdateResult)
            
            Information.PropUpdator(UpdateResult)
        end)

        if (not Success) then
            printVerbose("Error ocurred during ReturnDisplay: "..Message) -- im not dealing with this shit right now
        end
    end

    -- Called every time the user changes the value

    Information.OnChange = function(Value)
        Information.UserChange(Value)
        Information.OnUpdate()
    end

    Information.OnUpdate()
    Object.OnUpdate = Information.OnUpdate
    Object.OnChange = Information.OnChange

    return Object
end

function PropertyValue.CreateValue(Type, Parent, Info)
    return ValueTypes[Type](Parent, Info)
end

return PropertyValue