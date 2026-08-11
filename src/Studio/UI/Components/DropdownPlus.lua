local DropdownPlus = {}
local Things = Runtime.Things
local Components = Studio.Components
local TweenService = Runtime.Services.Service("TweenService")

local ChoiceTypes = {
    ["Button"] = function(Choice, Parent)
        local Button = Components.CreateStyle("TextButton", {
            Text = Choice.Text,
            Size = Pivot2D.FromScale(0.95,0.8),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            Parent = Parent,
            BackgroundColor = "Primary",
            Alignment = Vector2.new(0,0.5),
            CornerRadius = 2,
            HoverColorMultiplier = 6,
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
            BackgroundColor = Studio.CurrentTheme.Outline,
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
        local UsingSize = FakeParent.AbsoluteSize
        local UsingPosition = FakeParent.ViewportPosition + (FakeParent.AbsoluteSize * Vector2.yAxis)

        MajorComponent.Container:SetSize(Pivot2D.FromOffset(UsingSize.X or 200,0))
        MajorComponent.Container:SetPosition(Pivot2D.FromOffset(UsingPosition))

        for _, Choice in pairs(MajorComponent.Choices) do
            Choice.Button:SetSize(Pivot2D.new(0,1,UsingSize.Y or 20,0))
        end
    end)
end

function DropdownPlus.new(Choices,FakeParent)
    local DropdownObject = {}

    DropdownObject.Container = Things.Create("Viewport2D") {
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(100,800),
        Layer = 999,
    }

    DropdownObject.MajorParent = Components.CreateStyle("Square", {
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        Size = Pivot2D.FromScale(1,1),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = DropdownObject.Container
    })
    
    DropdownObject.Shadow = Components.CreateDropshadow(DropdownObject.MajorParent)
    DropdownObject.Choices = {}

    Components.CreateStyle("ListLayout", {
        Parent = DropdownObject.MajorParent,
        Alignment = Vector2.new(0.5,0)
    })

    for i,Choice in pairs(Choices) do
        table.insert(DropdownObject.Choices,DropdownPlus.CreateButton(Choice,DropdownObject.MajorParent))
    end

    DropdownPlus.HandleNotParentSize(DropdownObject,FakeParent)

    function DropdownObject.Toggle(Visible, Animation)
        --DropdownObject.MajorParent.Visible = Visible -- mikl i swear to god

        --[[if (not Animation) then
            DropdownObject.MajorParent:SetVisible(Visible)
            return
        end]]

        DropdownObject.MajorParent:SetActive(false)
        DropdownObject.Container:SetVisible(true)
        DropdownObject.Container.ForegroundTransparency = Visible and 1 or 0

        DropdownObject.MajorParent:SetPivot(Vector2.new(0,Visible and 1 or 0))

        local Move = TweenService.Create(DropdownObject.MajorParent, {
            Pivot = Vector2.new(0,Visible and 0 or 1),
        }, Enum.EasingStyle.ExpoOut, .25)

        local Move2 = TweenService.Create(DropdownObject.Container, {
            ForegroundTransparency = Visible and 0 or 1
        }, Enum.EasingStyle.ExpoOut, .25)

        Move.Play()
        Move2.Play()

        Move.Completed:Connect(function()
            DropdownObject.Container:SetVisible(Visible)
            DropdownObject.MajorParent:SetPivot(Vector2.new(0,Visible and 0 or 1))
            DropdownObject.MajorParent:SetActive(Visible)
        end)
    end

    function DropdownObject.Remove()
        DropdownObject.Container:Destroy()
    end

    DropdownObject.Container:SetParent(Things.Root.RootViewport)

    return DropdownObject
end

return DropdownPlus