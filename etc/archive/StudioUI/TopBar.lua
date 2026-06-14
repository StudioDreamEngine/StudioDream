local Things = Runtime.Things

local ExplorerContainer
local ExplorerContainer1
local TreeStarter

local RowHeight = 24
local IndentSize = 16
local IconsSize = 16 -- i will change this when we actually start making icons frfr

local NodeColor = Color.new(0.314, 0.294, 0.502)
local WindowColor = Color.new(0.106, 0.09, 0.188)
local BackWindowColor = Color.new(0.149, 0.129, 0.333)

local Order = {"Project", "File"}
local UpOptions = {
    ["Project"] = {
        Scale = Pivot2D.FromScale(0.2,1),
        Clicked = function(Button)
            print("Clicked Project")
        end,
    },
    ["File"] = {
        Scale = Pivot2D.FromScale(0.2,1),
        Clicked = function(Button)
            print("Clicked File")
        end,
    },
}

local function RenderButton(Text,Size,Parent,PositionS,CLickFunc)
    local ButtonTest = Things.Create("TextButton") {
        Size = Size,
        Position = PositionS or Pivot2D.FromScale(0,1),
        Pivot = Vector2.new(0,1),
        Parent = Parent,
        Text = Text,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        Name = "ButtonTest"
    }

    ButtonTest.Clicked:Connect(function()
        CLickFunc(ButtonTest)
    end)
end

return function(TreeStarter)
    ExplorerContainer = Things.Create "SquarePrimative" { 
       Size = Pivot2D.FromScale(1,0.05),
       Pivot = Vector2.new(0.5,1),
       Position = Pivot2D.FromScale(0.5,0.05),
       Explorer = {
        Visible = false,
       },
       BackgroundColor = WindowColor,
       Name = "Explorer",
       Layer = 1
    }
    ExplorerContainer:SetParent(TreeStarter)
    local Index = 0

    for i, key in ipairs(Order) do
        local v = UpOptions[key]
        Index = Index + 1

        RenderButton(key,Pivot2D.FromScale(0.2,1),ExplorerContainer,Pivot2D.FromScale((Index ~= 1 and Index/15 or 0),1),v.Clicked)
    end
end