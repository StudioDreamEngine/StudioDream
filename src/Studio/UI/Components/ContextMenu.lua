local ContextMenu = {}
local Things = Runtime.Things
local Components = Studio.Components

local CurrentContextMenu = nil
local LastParent = nil

--TODO: MAKE THE CURRENTCONTEXTMENU DESAPEAR WHEN U CLICK OFF IT (we have that on ultra top buttons)

local ChoiceTypes = {
    ["Button"] = function(Choice, Parent, ContextMenuObject)
        local HasImage = Choice.Image
        
        local Button = Components.CreateStyle("TextButton", {
            Text = "",
            Size = Pivot2D.FromScale(0.95,0.8),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            Parent = Parent,
            BackgroundColor = Studio.Theme.CurrentTheme.Primary,
            Alignment = Vector2.new(0,0.5),
            CornerRadius = 2,
        })

        local ActualText = Components.CreateStyle("Text",{
            Text = Choice.Text,
            Parent = Button,
            Position = HasImage and  Pivot2D.FromScale(0.1,0.5) or Pivot2D.FromScale(0,0.5),
            Pivot = Vector2.new(0,0.5),
            Size = Pivot2D.FromScale(0.95,0.8),
            BackgroundTransparency = 1,
        })

        if HasImage then
            Runtime.Things.Create("Image2D") {
                Size = Pivot2D.FromScale(1,1),
                Pivot = Vector2.new(0,0.5),
                Position = Pivot2D.FromScale(0,0.5),
                SquareAxis = Enum.SquareAxis.Y,
                Resource = HasImage,
                Parent = Button
            }
        end
        if Choice.Function then
            Button.Clicked:Connect(function() 
                Choice.Function(ContextMenuObject)
            end)
        end
    end,
    ["Separator"] = function(Choice, Parent)
        Parent:SetSize(Pivot2D.new(0,1,3,0))
        Things.Create("Square") {
            Size = Pivot2D.FromScale(0.98,1),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            BackgroundColor = Studio.Theme.CurrentTheme.Outline,
            Parent = Parent,
            CornerRadius = 2,
        }
    end,
    ["Table"] = function(Choice, Parent)
        local ToLoop = Info.Table
        
    end,
}

function ContextMenu.CreateButton(Choice,MajorParent,DropdownObject)
    local Button = {}

    Button.Button = Components.CreateStyle("Square", {
        Size = Pivot2D.new(0,1,20,0),
        BackgroundTransparency = 1,
        Parent = MajorParent
    })
    Button.Type = ChoiceTypes[Choice.Type](Choice,Button.Button,DropdownObject)

    return Button
end

function ContextMenu.Init()
    --[[Runtime.InterfaceManager.OnClick:Connect(function()
        if CurrentContextMenu and not CurrentContextMenu.MajorParent.Hovering then
            print("Context removed")
            CurrentContextMenu.Remove()
            CurrentContextMenu = nil
        end
    end)]]
end

function ContextMenu.HandleNotParentSize(MajorComponent,FakeParent)
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

function ContextMenu.new(Choices,ParentThingy)
    if CurrentContextMenu and LastParent ~= ParentThingy then
        CurrentContextMenu.Remove()
    end

    if LastParent == ParentThingy and CurrentContextMenu then
        CurrentContextMenu.MajorParent:SetPosition(Studio.Layout.GetMouseContext(CurrentContextMenu.MajorParent))
        return
    end
    
    local DropdownObject = {}

    DropdownObject.MajorParent = Components.CreateStyle("ContextSquare", {
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = Pivot2D.FromOffset(200,0),
        Layer = 999,
        BackgroundTransparency = 0,
        BackgroundColor = Studio.Theme.CurrentTheme.Outline,
        CornerRadius = 5,
        Parent = Things.Root.RootViewport,
    })
    
    DropdownObject.Choices = {}

    DropdownObject.MajorParent:SetPosition(Studio.Layout.GetMouseContext(DropdownObject.MajorParent))

    Components.CreateStyle("ListLayout", {
        Parent = DropdownObject.MajorParent,
        Alignment = Vector2.new(0.5,0.5)
    })

    function DropdownObject.Remove()
        DropdownObject.MajorParent:Destroy()
    end

    DropdownObject.MajorParent:SetParent(Things.Root.RootViewport)

    CurrentContextMenu = DropdownObject
    LastParent = ParentThingy

    for i,Choice in pairs(Choices) do
        table.insert(DropdownObject.Choices,ContextMenu.CreateButton(Choice,DropdownObject.MajorParent,DropdownObject))
    end

    return DropdownObject
end

return ContextMenu