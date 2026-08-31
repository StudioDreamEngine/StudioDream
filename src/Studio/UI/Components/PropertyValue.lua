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

        Things.Create("Flex") {
            Parent = ValueObject
        }

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
            IgnoreConstraints = true,
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
        end
    end,
    Button = function(Parent, Info)
        ---@class TextButton
        local ValueObject = Studio.Components.CreateStyle("TextButton", {
            Position = Pivot2D.FromScale(0,0.5),
            IgnoreConstraints = true, -- HACK
            Pivot = Vector2.new(0,0.5),
            Alignment = Enum.Alignment.Center,
            Size = Pivot2D.FromScale(1,0.9),
            ForegroundColor = "Text",
            Placeholder = Info.Placeholder or "None",
            ForegroundTransparency = Info.Disabled and 0.5 or 0,
            Parent = Parent,
        })

        ValueObject.Clicked:Connect(function()
            local RequestText = Info.UserRequest(Info.OnChange) or tostring(Info.ReturnDisplay())

            Info.PropUpdator(RequestText)
        end)

        return function(Value)
            ValueObject:SetText(Value)
        end
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

local ValueFunction = function(PropertyList, Information, Style)
    local PropertyValue = {}
    Style = Style or {}
    PropertyValue.UI = {}

    local Container = Things.Create(Information.StyleSelect and "TextButton" or "Square") {
        BackgroundTransparency = 0,
        Text = "",
        Size = PropertyList.Size,
        Name = Information.Name or "Container",
        CornerRadius = 5,
        Parent = PropertyList.Parent
    }
    local HasTitle = Information.Title

    PropertyValue.UI.Container = Container

    Studio.Components.RegisterToTheme(Container, "BackgroundColor", Style.Container or "Primary")

    if HasTitle then
        PropertyValue.UI.Title = Studio.Components.CreateStyle("Text", {
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

    if type(Information.Type) ~= "function" then
        Information.PropUpdator,PropertyValue.Prop = ValueTypes[Information.Type](PropertyValue.UI.ValueContainer, Information)
    else
        Information.PropUpdator,PropertyValue.Prop = Information.Type(PropertyValue.UI.ValueContainer, Information)
    end

    -- Called every time the PropertyValue should be updated
    Information.OnUpdate = function()
        local Success, Message = pcall(function()
            local UpdateResult = tostring(Information.ReturnDisplay())
            printVerbose("PropertyValue OnUpdate Result w/ "..UpdateResult)
            
            Information.PropUpdator(UpdateResult)
        end)

        if (not Success) then
            printVerbose("Error ocurred during ReturnDisplay: "..Message) -- im not dealing with this shit right now
        end
    end

    if Information.TrackObjects then
        for _,Thing in pairs(Information.TrackObjects.Things) do
            Container:AddPlaceholderSignal(Thing.PropertyChanged:ConnectDeferred(function(Val,Property) -- Can be a memory leak so change this to something better later
                if Property == Information.TrackObjects.Property then
                    Information.OnUpdate()
                end
            end))
        end
    end

    if Information.StyleSelect then
        local ToggleThing = false

        local ContainerSignal = Container:AddPlaceholderSignal(Runtime.InterfaceManager.OnClick:Connect(function()
            if Container.Hovering then return end
            ToggleThing = false
        end))

        Container.Clicked:Connect(function()
            ToggleThing = not ToggleThing
        end)
    end

    -- Called every time the user changes the value

    Information.OnChange = function(Value)
        if type(Value) ~= "nil" then 
            printVerbose("PropertyValue OnChange w/ "..tostring(Value))

            -- Auto-translate value
            if Information.Translate then
                Value = _G[Information.Translate].FromString(Value)
            end

            Information.UserChange(Value)
        end
        
        Information.OnUpdate()
    end

    Information.OnUpdate()
    PropertyValue.OnUpdate = Information.OnUpdate

    return PropertyValue
end

return ValueFunction