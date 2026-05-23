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


local ChoiceTypes = {
    ["Button"] = function(Func,Parent,Text)
        local Button = Components.CreateStyle("TextButton", {
            Text = Text,
            Clicked = Func,
            Size = Pivot2D.new(0,1,20,0),
            Parent = Parent,
            BackgroundTransparency = 1
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

function Components.CreateDropdown(Position,Choices,Size) -- Advanced dropdown!! bleh
    local Dropdown = {}
    local CurrentButtonactions = {}
    local CurrentDropdown = Components.CreateStyle("Square", {
        Name = "DropdownElement",
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(200,0),
        Layer = 100
    })
    Components.CreateStyle("ListLayout", {
        Parent = CurrentDropdown
    })

    if Position.Type == "Thing" then
        Size = Position.AbsoluteSize
        Position = Position.AbsolutePosition + (Position.AbsoluteSize * Vector2.yAxis)
    end

    CurrentDropdown:SetSize(Pivot2D.FromOffset(Size.X or 200,0))
    CurrentDropdown:SetPosition(Pivot2D.FromOffset(Position))
    for _,Choice in pairs(Choices) do
        local CurrentSection = Components.CreateStyle("Square", {
            Size = Pivot2D.new(0,1,Size.Y or 20,0),
            Parent = CurrentDropdown,
            BackgroundTransparency = 1
        })
        CurrentSection:SetOutlineSize(0)
        local ReturnedClicked = ChoiceTypes[Choice.Type](Choice.Function,CurrentSection,Choice.Text,Choice)
        if ReturnedClicked then
            table.insert(CurrentButtonactions,ReturnedClicked)
        end
        if Choice.SubText then
            local SubText = Components.CreateStyle("Text", {
                Text = Choice.SubText,
                Size = Pivot2D.FromScale(0.5,1),
                Pivot = Vector2.new(1,0.5),
                Position = Pivot2D.FromScale(1,0.5),
                Parent = CurrentSection,
                BackgroundTransparency = 1,
                OutlineSize = 0.1,
                Align = Vector2.new(1,1),
            })
            SubText:SetOutlineSize(0)
        end
    end

    CurrentDropdown:SetParent(Things.Root.RootViewport)

    return Dropdown
end

function Components.ShowDropdown(Position, Choices, Size)--, CreateOne)
    if (not Size) then Size = {} end

    local ButtonsActions = {}

    local CurrentDropdown = DropdownFrame
    
    -- Special code for positioning below an object
    if Position.Type == "Thing" then
        Size = Position.AbsoluteSize
        Position = Position.DisplayPosition + (Position.AbsoluteSize * Vector2.yAxis)
    end

    --[[if CreateOne then
        CurrentDropdown = Components.CreateStyle("Square", {
        Name = "DropdownElement",
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(200,0),
        Layer = 100
    })
    end]]

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
            Parent = CurrentDropdown,
            BackgroundTransparency = 1
        })

        Button.OutlineColor = Studio.Theme.Tertiary
        table.insert(ButtonsActions,Button.Clicked)
    end

    Things.Create("ListLayout") {
        Parent = CurrentDropdown
    }

    function Dropdown:RemoveDropdown()
        --[[for i,v in pairs(ButtonsActions) do
            v:Destroy()
        end
        if CreateOne then
            Things.Remove(CurrentDropdown)
        else]]
        CurrentDropdown.Visible = false
        --end
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