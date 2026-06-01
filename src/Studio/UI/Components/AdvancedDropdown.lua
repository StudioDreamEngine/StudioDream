local Components = Studio.Components
local Things = Runtime.Things

local ChoiceTypes = {
    ["Button"] = function(Choice, Parent)
        local Button = Components.CreateStyle("TextButton", {
            Text = Choice.Text,
            Size = Pivot2D.FromScale(1,0.8),
            Position = Pivot2D.FromScale(0,0.5),
            Pivot = Vector2.new(0,0.5),
            Parent = Parent,
            BackgroundTransparency = 1,
            Alignment = Vector2.new(0,0.5),
        })
        Button:SetOutlineSize(0)

        return Button.Clicked
    end,
    ["Separator"] = function(Func,Parent,Text)
        Parent:SetSize(Pivot2D.new(0,1,5,0))
        Things.Create("Square") {
            Size = Pivot2D.FromScale(0.9,0.35),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            BackgroundColor = Studio.Theme.Outline,
            Parent = Parent
        }
    end,
    ["Table"] = function(Func,Parent,Text,Info)
        local ToLoop = Info.Table
        
    end,
}

return function(Choices)
    local Dropdown = {}
    local BindedEvents = {}
    local CurrentDropdown = Components.CreateStyle("Square", {
        Name = "DropdownElement",
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(200,0),
        Layer = 100,
        Visible = false
    })

    local Position, Size = Vector2.zero, Vector2.new(0,25)

    local Updator = Components.RegisterUpdator(function()
        local UsingPosition, UsingSize = Position, Size -- idk what to call this

        if Position.Type == "Thing" then
            UsingSize = Size and Vector2.new(Position.AbsoluteSize.X, Position.AbsoluteSize.Y*Size.Y) or Position.AbsoluteSize
            UsingPosition = Position.AbsolutePosition + (Position.AbsoluteSize * Vector2.yAxis)
        end

        CurrentDropdown:SetSize(Pivot2D.FromOffset(UsingSize.X or 200,0))
        CurrentDropdown:SetPosition(Pivot2D.FromOffset(UsingPosition))

        for _, Choice in pairs(Choices) do
            Choice.Object:SetSize(Pivot2D.new(0,1,UsingSize.Y or 20,0))
        end
    end)

    Components.CreateStyle("ListLayout", {
        Parent = CurrentDropdown
    })

    for _,Choice in pairs(Choices) do
        local CurrentSection = Components.CreateStyle("Square", {
            Size = Pivot2D.new(0,1,20,0),
            Parent = CurrentDropdown,
            BackgroundTransparency = 1
        })
        CurrentSection:SetOutlineSize(0)

        Choice.Object = CurrentSection

        local ClickEvent = ChoiceTypes[Choice.Type](Choice, CurrentSection)

        if ClickEvent then
            table.insert(BindedEvents, ClickEvent:Connect(Choice.Function))
        end

        if Choice.SubText then
            local SubText = Components.CreateStyle("Text", {
                Text = Choice.SubText,
                Size = Pivot2D.FromScale(1,0.8),
                Pivot = Vector2.new(1,0.5),
                Position = Pivot2D.FromScale(1,0.5),
                Parent = CurrentSection,
                Alignment = Vector2.new(0.5,0.5),
            })
            SubText:SetOutlineSize(0)
        end

        if Choice.SubImage then
            Components.CreateStyle("Image2D", {
                Image = Choice.SubImage,
                Size = Pivot2D.FromScale(1,1),
                SquareAxis = Enum.SquareAxis.Y,
                Pivot = Vector2.new(1,0.5),
                Position = Pivot2D.FromScale(1,0.5),
                Parent = CurrentSection,
            })
        end
    end

    CurrentDropdown:SetParent(Things.Root.RootViewport)

    function Dropdown.MoveToMouse()
        local MousePos = Things.Root.RootViewport.MousePosition
        
        Position = Pivot2D.FromOffset(MousePos)
    end

    function Dropdown.SetSize(InSize) Size = InSize end

    function Dropdown.Setup(InPosition, InSize)
        Position = InPosition
        Size = InSize
    end

    Dropdown.Visible = false

    function Dropdown.Toggle(Visible)
        Dropdown.Visible = Visible
        CurrentDropdown.Visible = Visible
    end
    
    function Dropdown.Remove()
        for _,v in pairs(BindedEvents) do
            v:Disconnect()
        end

        Components.UnregisterUpdator(Updator)
        Things.Remove(CurrentDropdown)
    end

    return Dropdown
end