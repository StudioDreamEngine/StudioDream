local DropdownPlus = {}
local Things = Runtime.Things
local Components = Studio.Components
local TweenService = Runtime.Services.Service("TweenService")

local ChoiceTypes = {
    ["Button"] = function(Choice, Object, Parent)
        --[[local Padding = Components.CreateStyle("Padding", {
            PaddingX = 2,
            PaddingY = 2,
            Parent = Parent,
        })]]
        local Button = Components.CreateStyle("TextButton", {
            Text = Choice.Text,
            Size = Pivot2D.FromScale(0.9,0.9),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            Parent = Parent,
            BackgroundColor = "Outline",
            Font = "FontBold",
            Alignment = Enum.Alignment.MiddleLeft,
            CornerRadius = 100,
            HoverColorMultiplier = 0.5,
        })

        if Choice.Function then
            Button.Clicked:Connect(function()
                Object.Toggle(false)
                Choice.Function()
            end)
        end
    end,
    ["Separator"] = function(Func,Object, Parent)
        Parent:SetSize(Pivot2D.new(1,0,0,8))
        Components.CreateStyle("Square",{
            Size = Pivot2D.new(1,0,0,4),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            BackgroundColor = "Primary",
            BackgroundTransparency = 0,
            Parent = Parent,
        })
    end,
    ["Table"] = function(Func,Parent,Text,Info)
        local ToLoop = Info.Table
        
    end,
}

function DropdownPlus.CreateButton(Choice,Object)
    local Button = {}

    Button.Button = Components.CreateStyle("Square", {
        Size = Pivot2D.new(1,0,0,20),
        BackgroundTransparency = 1,
        Parent = Object.MajorParent
    })
    Button.Type = ChoiceTypes[Choice.Type](Choice,Object,Button.Button)

    return Button
end

function DropdownPlus.HandleNotParentSize(MajorComponent,FakeParent, Size)
    local Pivot = Vector2.yAxis
    return Components.RegisterUpdator(function()
        local UsingSize = Size or FakeParent.AbsoluteSize
        local UsingPosition = FakeParent.ViewportPosition + (FakeParent.AbsoluteSize * Pivot)
        local Context = Studio.Layout.GetAreaContext(MajorComponent.Container)

        Pivot = Vector2.new(0,1)
        MajorComponent.Container:SetPivot(Vector2.new(0,0))

        if Context.Left then
            local Context = Studio.Layout.GetContextOf(FakeParent.ViewportPosition,FakeParent.AbsoluteSize)
            Pivot = Vector2.new(1,Pivot.Y)
            MajorComponent.Container:SetPivot(Vector2.new(1,MajorComponent.Container.Pivot.Y))
        end

        MajorComponent.Container:SetSize(Pivot2D.FromOffset(200,0))
        MajorComponent.Container:SetPosition(Pivot2D.FromOffset(UsingPosition))

        for _, Choice in pairs(MajorComponent.Choices) do
            Choice.Button:SetSize(Pivot2D.new(1,0,0,Choice.Button.Size.Offset.Y))
        end
    end)
end

function DropdownPlus.new(Choices, FakeParent, Size)
    local DropdownObject = {}

    DropdownObject.Container = Things.Create("ViewportLite") {
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(100,800),
        BackgroundTransparency = 1,
        Layer = 999,
    }

    DropdownObject.MajorParent = Components.CreateStyle("Square", {
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(0,0),
        Pivot = Vector2.new(0.5,0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = DropdownObject.Container,
        CornerRadius = 5,
        OutlineColor = "Primary",
        OutlineSize = 2,
    })
    
    --DropdownObject.Shadow = Components.CreateDropshadow(DropdownObject.MajorParent)
    DropdownObject.Choices = {}

    DropdownObject.Visible = true

    Components.CreateStyle("ListLayout", {
        Parent = DropdownObject.MajorParent,
        Alignment = Vector2.new(0.5,0)
    })

    for i,Choice in pairs(Choices) do
        table.insert(DropdownObject.Choices, DropdownPlus.CreateButton(Choice,DropdownObject))
    end

    local Updator = DropdownPlus.HandleNotParentSize(DropdownObject,FakeParent, Size)

    FakeParent.OnDestroy:ConnectOnce(function()
        DropdownObject.Remove()
        DropdownObject.Container = nil
    end)

    local Move, Move2

    function DropdownObject.Toggle(Visible, Animation)
        if (type(Visible) == "nil") then
            Visible = (not DropdownObject.Visible)
        end

        printVerbose("Visible nil check")
        
        --DropdownObject.MajorParent.Visible = Visible -- mikl i swear to god

        --[[if (not Animation) then
            DropdownObject.MajorParent:SetVisible(Visible)
            return
        end]]

        if (not DropdownObject.Visible) and (not Visible) then
            if Move then Move.Cancel() end
            if Move2 then Move2.Cancel() end

            DropdownObject.Container:SetVisible(false)
            return
        end

        DropdownObject.Container:SetVisible(true)
        DropdownObject.Container.ForegroundTransparency = Visible and 1 or 0
        DropdownObject.MajorParent:SetPivot(Vector2.new(0,Visible and 1 or 0))
        DropdownObject.MajorParent:SetActive(false)

        Move = TweenService.Create(DropdownObject.MajorParent, {
            Pivot = Vector2.new(0,Visible and 0 or 1),
        }, Enum.EasingStyle.QuintOut, .2)

        Move2 = TweenService.Create(DropdownObject.Container, {
            ForegroundTransparency = Visible and 0 or 1
        }, Enum.EasingStyle.QuintOut, .2)

        Move.Play()
        Move2.Play()

        Move.Completed:Connect(function()
            --printVerbose("Move completed function start")
            DropdownObject.Visible = Visible
            DropdownObject.Container:SetVisible(Visible)
            DropdownObject.MajorParent:SetPivot(Vector2.new(0,Visible and 0 or 1))
            DropdownObject.MajorParent:SetActive(Visible)
            printVerbose("DropdownObject MajorParent SetActive (2)")
        end)
        --printVerbose("Move completed")
    end

    function DropdownObject.Remove()
        DropdownObject.Container:Destroy()
        Components.UnregisterUpdator(Updator)
    end

    DropdownObject.Container:SetParent(Things.RenderRoot)

    return DropdownObject
end

return DropdownPlus