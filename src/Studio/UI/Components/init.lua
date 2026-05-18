local Things = Runtime.Things
local Components = {}

function Components.CreateButton(Name, Properties)
    Properties.Text = Name
    Properties.CornerRadius = 7
    Properties.AlignX = Enum.AlignmentX.Center
    Properties.AlignY = Enum.AlignmentY.Center

    ---@class TextButton
    local Button = Components.CreateStyle("TextButton", Properties)

    return Button
end

---@class Square
local DropdownFrame

function Components.Init()
    DropdownFrame = Components.CreateStyle("Square", {
        Parent = Things.Root.RootViewport,
        Name = "DropdownElement",
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(200,0),
        Layer = 100
    })
end

function Components.ShowDropdown(Position, Choices, Size, CreateOne)
    if (not Size) then Size = {} end

    local ButtonsActions = {}

    local CurrentDropdown = DropdownFrame
    -- Special code for positioning below an object
    if Position.Type == "Thing" then
        Size = Position.AbsoluteSize
        Position = Position.DisplayPosition + (Position.AbsoluteSize * Vector2.yAxis)
    end

    if CreateOne then
        CurrentDropdown = Components.CreateStyle("Square", {
        Name = "DropdownElement",
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(200,0),
        Layer = 100
    })
    end

    local Dropdown = {}

    CurrentDropdown:ClearAllChildren()
    CurrentDropdown:SetPosition(Pivot2D.FromOffset(Position))
    CurrentDropdown.Visible = true

    CurrentDropdown:SetSize(Pivot2D.FromOffset(Size.X or 200,0))

    for _, Choice in pairs(Choices) do
        local Button = Components.CreateStyle("TextButton", {
            Text = Choice.Text,
            Clicked = Choice.Function,
            Size = Pivot2D.new(0,1,Size.Y or 20,0),
            Parent = CurrentDropdown
        })

        Button.OutlineColor = Studio.Theme.Tertiary
        table.insert(ButtonsActions,Button.Clicked)
    end

    Things.Create("ListLayout") {
        Parent = CurrentDropdown
    }

    function Dropdown:RemoveDropdown()
        for i,v in pairs(ButtonsActions) do
            print(v)
            v:Destroy()
        end
        if CreateOne then
            Things.Remove(CurrentDropdown)
        else
            CurrentDropdown.Visible = false
        end
    end

    CurrentDropdown:SetParent(Things.Root.RootViewport) -- This makes them appear already loaded dont remove!

    return Dropdown
end

function Components.CreateStyle(Type, Properties)
    Properties.BackgroundColor = Studio.Theme.Secondary
    Properties.ForegroundColor = Studio.Theme.Text
    Properties.OutlineSize = 2
    Properties.OutlineColor = Studio.Theme.Outline
   
    return Things.Create(Type) (Properties)
end

return Components