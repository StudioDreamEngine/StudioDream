local Explorer = {}
local HowTreeIsLooking = {}

local Things = Runtime.Things

local TreeStarter = nil
local Window = nil
local ViewStart = nil

local function RenderNode(Info,Depth,YAxis)
    YAxis = YAxis+16
    local XOff = Depth*15
    local StartNode = Things.Create "TextButton" {
       Size = Pivot2D.FromScale(1,0.05),--Pivot2D.FromOffset(Vector2.new(200, 20)),
       Pivot = Vector2.new(0,0.5),
       Position = Pivot2D.FromOffset(Depth,YAxis),
       Explorer = {
        Visible = false,
       },
       BackgroundColor = NodeColor,
       Layer = 1,
       ForegroundColor = Studio.Theme.Text,
       Text = Info.Name,
       BackgroundTransparency = 0.5,
       Parent = Window
    }
    local Icon = Things.Create("Image2D") {
        Size = Pivot2D.FromOffset(32,32), -- used to be 16,16
        Image = Info.Icon,
        Pivot = Vector2.new(1,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Parent = StartNode
    }

    for i,v in pairs(Info.Children) do
        RenderNode(v,Depth+1,YAxis)
    end
end

local function CreateNode(Thing,TableStarter)
    local Tabled
    if TableStarter then
        TableStarter[Thing.Name] = {
            Icon = "Assets/EditorIcons/32/" .. (Thing.Explorer.Icon or "Icon_Not_Found") .. ".png",
            Name = Thing.Name,
            Children = {}
        }
        Tabled = TableStarter[Thing.Name]
    else
        HowTreeIsLooking[Thing.Name] = {
            Icon = "Assets/EditorIcons/32/" .. (Thing.Explorer.Icon or "Icon_Not_Found") .. ".png",
            Name = Thing.Name,
            Children = {}
        }
        Tabled = HowTreeIsLooking[Thing.Name]
    end

    for UUID,_ in pairs(Thing.Children) do
        local Thinged = Things.Get(UUID)
        if Thinged.Explorer.Visible == true then
            CreateNode(Thinged,Tabled.Children)
        end
    end

    RenderNode(Tabled,0,0)
end

function StartTree(TreeStart)
    HowTreeIsLooking[TreeStart.Name] = {}
end

function Explorer:Init(TreeStart,View)
    local WindowWow = Runtime.InterfaceManager.CreateWindow(Pivot2D.FromScale(1,0.5),Pivot2D.FromScale(0,0.31),View)
    Window = WindowWow.BackWindow
    ViewStart = View
    TreeStarter = TreeStart
    CreateNode(View)
end

return Explorer