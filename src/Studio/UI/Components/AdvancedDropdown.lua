local Components = Studio.Components
local Things = Runtime.Things
local Tween = Runtime.Services.Service("TweenService")

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
            BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
            Parent = Parent
        }
    end,
    ["Table"] = function(Func,Parent,Text,Info)
        local ToLoop = Info.Table
        
    end,
}

local IsATableToTrans = {
    ["TextButton"] = "ForegroundTransparency",
    ["Text"] = "ForegroundTransparency",
    ["Square"] = "BackgroundTransparency",
    ["Image2D"] = "ForegroundTransparency"
}
local IsASecondToTrans = {
     ["TextButton"] = "OutlineTransparency",
    ["Text"] = "OutlineTransparency",
    ["Square"] = "OutlineTransparency",
}

local function ToggleAnim(CurrentDropdown,Dropdown,IsTrue)
    for i,v in pairs(CurrentDropdown:GetDescendants()) do
        if v.ClassName ~= "ListLayout" then 
            local ThingTo = IsATableToTrans[v.ClassName]
            local ThingTwo = IsASecondToTrans[v.ClassName]
            v[ThingTo] = IsTrue and 0 or 1
            if ThingTwo then v[ThingTwo] = IsTrue and 1 or 0 end
        end
        
    end
    for i,v in pairs(CurrentDropdown:GetDescendants()) do
        if v.ClassName ~= "ListLayout" then 
            local ThingTwo = IsASecondToTrans[v.ClassName]
            local ThingTo = IsATableToTrans[v.ClassName]
            if IsTrue then
                if ThingTwo then 
                    Tween.Create(CurrentDropdown, {[ThingTo] = 0,[ThingTwo] = 1}, Enum.EasingStyle.Linear, .1).Play()
                else
                    Tween.Create(CurrentDropdown, {[ThingTo] = 0}, Enum.EasingStyle.Linear, .1).Play()
                end
            else
                if ThingTwo then 
                    Tween.Create(CurrentDropdown, {[ThingTo] = 1,[ThingTwo] = 0}, Enum.EasingStyle.Linear, .1).Play()
                else
                    Tween.Create(CurrentDropdown, {[ThingTo] = 1}, Enum.EasingStyle.Linear, .1).Play()
                end
            end
        end
      --  CurrentDropdown.Visible = IsTrue
    end
    Scheduler.Yield(.1)
    Dropdown.Visible = IsTrue
    CurrentDropdown:SetVisible(IsTrue)
end

return function(Choices)
    print("Wwowoww")
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
        Position = Studio.Layout.GetMouseContext(CurrentDropdown.AbsoluteSize)
    end

    function Dropdown.SetSize(InSize) Size = InSize end

    function Dropdown.Setup(InPosition, InSize)
        Position = InPosition
        Size = InSize
    end

    Dropdown.Visible = false

    function Dropdown.Toggle(Visible)
        --print("hi")
        ToggleAnim(CurrentDropdown,Dropdown,Visible)
        --print("hi")
        --Dropdown.Visible = Visible
        --CurrentDropdown.Visible = Visible
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