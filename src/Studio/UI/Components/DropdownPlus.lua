local DropdownPlus = {}
local Things = Runtime.Things
local Components = Studio.Components

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

        if Choice.Function then
            Button.Clicked:Connect(Choice.Function)
        end
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
        BackgroundTransparency = 1,
        Parent = MajorParent
    })
    Button.Type = ChoiceTypes[Choice.Type](Choice,Button.Button)

    return Button
end

function DropdownPlus.HandleNotParentSize(MajorComponent,FakeParent)
    Components.RegisterUpdator(function()
        local UsingPosition, UsingSize = Position, Size

        UsingSize = Size and Vector2.new(FakeParent.AbsoluteSize.X, FakeParent.AbsoluteSize.Y*Size.Y) or FakeParent.AbsoluteSize
        UsingPosition = FakeParent.ViewportPosition + (FakeParent.AbsoluteSize * Vector2.yAxis)

        MajorComponent.MajorParent:SetSize(Pivot2D.FromOffset(UsingSize.X or 200,0))
        MajorComponent.MajorParent:SetPosition(Pivot2D.FromOffset(UsingPosition))

        for _, Choice in pairs(MajorComponent.Choices) do
            Choice.Button:SetSize(Pivot2D.new(0,1,UsingSize.Y or 20,0))
        end
    end)
end

function DropdownPlus.new(Choices,FakeParent)
    local DropdownObject = {}

    DropdownObject.MajorParent = Components.CreateStyle("Square", {
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(200,0),
        Layer = 100,
        BackgroundTransparency = 0,
        BackgroundColor = Studio.Theme.CurrentTheme.Outline,
    })
    
    DropdownObject.Choices = {}

    Components.CreateStyle("ListLayout", {
        Parent = DropdownObject.MajorParent,
        Alignment = Vector2.new(0.5,0.5)
    })

    for i,Choice in pairs(Choices) do
        table.insert(DropdownObject.Choices,DropdownPlus.CreateButton(Choice,DropdownObject.MajorParent))
    end

    DropdownPlus.HandleNotParentSize(DropdownObject,FakeParent)

    function DropdownObject.Remove()
        DropdownObject.MajorParent:Destroy()
    end

    DropdownObject.MajorParent:SetParent(Things.Root.RootViewport)

    return DropdownObject
end

return DropdownPlus