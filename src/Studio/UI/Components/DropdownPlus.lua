local DropdownPlus = {}

local ChoiceTypes = {
    ["Button"] = function(Choice, Parent)
        local Button = Components.CreateStyle("TextButton", {
            Text = Choice.Text,
            Size = Pivot2D.FromScale(0.95,0.8),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            Parent = Parent,
            BackgroundColor = Studio.Theme.CurrentTheme.Primary,
            Alignment = Vector2.new(0,0.5),
            CornerRadius = 2,
        })

        return Button.Clicked
    end,
    ["Separator"] = function(Func,Parent,Text)
        Parent:SetSize(Pivot2D.new(0,1,1,0))
        Things.Create("Square") {
            Size = Pivot2D.FromScale(0.9,0.35),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            BackgroundColor = Studio.Theme.CurrentTheme.Outline,
            Parent = Parent,
            CornerRadius = 2,
        }
    end,
    ["Table"] = function(Func,Parent,Text,Info)
        local ToLoop = Info.Table
        
    end,
}

function DropdownPlus.CreateButton(Choice,MajorParent)
    local Button = {}

    Button.Button = Components.CreateStyle("Square", {
        Size = Pivot2D.new(0,1,20,0),
        Parent = CurrentDropdown,
        BackgroundTransparency = 1
    })
    Button.Type = ChoiceTypes[Choice.Type](Choice,Button.Button)
    return Button
end

function DropdownPlus.HandleNotParentSize(MajorComponent,FakeParent)
    Components.RegisterUpdator(function()
        local UsingPosition, UsingSize = Position, Size 

        UsingSize = Size and Vector2.new(FakeParent.Position.AbsoluteSize.X, FakeParent.Position.AbsoluteSize.Y*Size.Y) or FakeParent.Position.AbsoluteSize
        UsingPosition = FakeParent.Position.ViewportPosition + (FakeParent.Position.AbsoluteSize * Vector2.yAxis)

        CurrentDropdown:SetSize(Pivot2D.FromOffset(UsingSize.X or 200,0))
        CurrentDropdown:SetPosition(Pivot2D.FromOffset(UsingPosition))

        for _, Choice in pairs(MajorComponent.Choices) do
            Choice.Button:SetSize(Pivot2D.new(0,1,UsingSize.Y or 20,0))
        end
    end)
end

function DropdownPlus.new(Choices)
    local selfed = {}

    selfed.MajorParent = omponents.CreateStyle("Square", {
            Size = Pivot2D.new(0,1,20,0),
            Parent = CurrentDropdown,
            BackgroundTransparency = 1
    })

    selfed.Choices = {}

    for i,Choice in pairs(Choices) do
        table.insert(selfed.Choices,DropdownPlus.CreateButton(Choice,MajorParent))
    end

    return selfed
end

return DropdownPlus