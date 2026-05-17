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

function Components.ShowDropdown(Position, Choices, Size, BaseThing, CreateOne)
    if (not Size) then Size = {} end
    
    local CurrentDropdown = DropdownFrame

    if CreateOne then 
        CurrentDropdown = Components.CreateStyle("Square", {
            Parent = Things.Root.RootViewport,
            Name = "DropdownElement",
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = Pivot2D.FromOffset(200,0),
            Layer = 100
        })
    end

    local Dropdown = {}

    CurrentDropdown:ClearAllChildren()
    CurrentDropdown:SetPosition(BaseThing and Pivot2D.new(Position+BaseThing.AbsolutePosition) or Pivot2D.FromOffset(Position))
    CurrentDropdown.Visible = true

    CurrentDropdown:SetSize(Size.X or 200,0)

    for _, Choice in pairs(Choices) do
        local Button = Components.CreateStyle("TextButton", {
            Text = Choice.Text,
            OnClick = Choice.Function,
            Size = Pivot2D.new(0,1,Size.Y or 20,0),
            Parent = CurrentDropdown
        })

        Button.OutlineColor = Studio.Theme.Tertiary
    end

    Things.Create("ListLayout") {
        Parent = CurrentDropdown
    }

    function Dropdown:RemoveDropdown()
        if CreateOne then
            Things.Remove(CurrentDropdown)
        else
            print("Function is using made in dropdown, that one cant be deleted bud!!")
        end
    end

    return Dropdown
end

function Components.CreateStyle(Type, Properties)
    Properties.BackgroundColor = Studio.Theme.Secondary
    Properties.ForegroundColor = Studio.Theme.Text
    Properties.OutlineSize = 2
    Properties.OutlineColor = Studio.Theme.SecondaryOutline
   
    return Things.Create(Type) (Properties)
end

return Components