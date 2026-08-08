local Things = Runtime.Things
local Toolbar = {}

Toolbar.Container = nil ---@class Square

local LastButtonUsed = nil
local LockInsert = false

Toolbar.ButtonsToCreate = {
    {
        Icon = "Insert",
        Name = "Insert thing",
        Clicked = function()
            LockInsert = not LockInsert
            if LockInsert then
                Studio.Editor3D.OpenInsertWindow()
            else
                Studio.Editor3D.CloseInsertWindow()
            end
        end,
    },
    {
        Name = "Selector",
    },
    {
        Icon = "Move",
        Name = "Move",
        Clicked = function()
            Toolbar.SelectTool("Move")
        end,
    },
    {
        Icon = "Scale",
        Name = "Scale",
        Clicked = function()
            Toolbar.SelectTool("Scale")
        end,
    },
    {
        Icon = "Rot",
        Name = "Rotate",
        Clicked = function()
            Toolbar.SelectTool("Rotate")
        end,
    },
    {
        Name = "Selector",
    },
}

Toolbar.ButtonsCreated = {}

function Toolbar.SelectTool(Name)
    if LastButtonUsed then
        LastButtonUsed.Main.BackgroundColor = Studio.CurrentTheme.Secondary
    end
    Studio.Editor3D.ToolManager.ChangeTool(Name)
    local ButtonCurrent = Toolbar.ButtonsCreated[Name]
    ButtonCurrent.Main.BackgroundColor = Studio.CurrentTheme.Selecting
    LastButtonUsed = ButtonCurrent
end

function Toolbar.CreateToolButton(Obj)
    local ToolButtonObject = {}

    ToolButtonObject.Main = Things.Create("ImageButton") {
        Size = Pivot2D.FromScale(0.9,0.9),
        --Position = Pivot2D.FromScale(0.5,0.5),
        --Pivot = Vector2.new(0.5,0.5),
        SquareAxis = Enum.SquareAxis.X,
        BackgroundColor = Studio.CurrentTheme.Secondary,
        BackgroundTransparency = 0,
        ForegroundTransparency = 1,
        CornerRadius = 100,
        Parent = Toolbar.Container,
    }
    ToolButtonObject.Image = Things.Create("Image2D") {
        Size = Pivot2D.FromScale(0.8,0.8),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        ScaleType = Enum.ScaleType.LockAspect,
        Resource = "Internal/Studio/TabIcons/"..Obj.Icon.."Icon.png",
        Parent = ToolButtonObject.Main,
    }
    --[[ToolButtonObject.Text = Things.Create("Text") {
        Size = Pivot2D.FromScale(0.7,0.5),
        Position = Pivot2D.FromScale(0.5,1),
        Pivot = Vector2.new(0.5,1),
        BackgroundTransparency = 1,
        Parent = ToolButtonObject.Main,
        Text = Obj.Name,
        ForegroundColor = Studio.CurrentTheme.Text,
        Alignment = Enum.Alignment.Center,
    }]]

    ToolButtonObject.Main.Clicked:Connect(Obj.Clicked)

    return ToolButtonObject
end

function Toolbar.CreateSeparator()
    local SepObject = {}

    SepObject.Main = Things.Create("Square") {
        Size = Pivot2D.FromScale(0.9,0.01),
        --Position = Pivot2D.FromScale(0.5,0.5),
        --Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Studio.CurrentTheme.Outline,
        BackgroundTransparency = 0,
        ForegroundTransparency = 1,
        CornerRadius = 100,
        Parent = Toolbar.Container,
    }

    return SepObject
end

function Toolbar.Init()
    Toolbar.Container.Size = Pivot2D.FromScale(0.8,0.99)
    --Toolbar.FullContainer.BackgroundColor = Studio.CurrentTheme.Primary

    Things.Create("ListLayout") {
        Parent = Toolbar.Container,
        Alignment = Enum.Alignment.Center,
        Padding = 5,
        SortMode = Enum.SortMode.Order,
    }

    for i,v in ipairs(Toolbar.ButtonsToCreate) do
        if v.Name ~= "Selector" then
            Toolbar.ButtonsCreated[v.Name] = Toolbar.CreateToolButton(v)
        else
            table.insert(Toolbar.ButtonsCreated,Toolbar.CreateSeparator())
        end
    end

    Toolbar.SelectTool("Move")
end

function Toolbar.Update(dt)
    
end

return Toolbar