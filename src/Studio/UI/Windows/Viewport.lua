local Things = Runtime.Things
local Tween = Runtime.Services.Service("TweenService")

return function(Viewport)

    function Viewport.FindTabByVal(Val,Check)
        for _,data in pairs(Viewport.Tabs) do
            if data[Val] and data[Val] == Check then
                return data
            end
        end
    end

    function Viewport.SelectTab(ID)
        local Tab = Viewport.FindTabByVal("SceneID",ID)
        if Viewport.CurrentlySelected and Viewport.CurrentlySelected~=Tab then
            Tween.Create(Viewport.CurrentlySelected.Object, {Pivot = Vector2.new(0,-.15),ForegroundTransparency = 0.5}, Enum.EasingStyle.Linear, .1).Play()
        end
        Tween.Create(Tab.Object, {Pivot = Vector2.new(0,.05),ForegroundTransparency = 0}, Enum.EasingStyle.Linear, .1).Play()
        if Tab.OnSelect then
            Tab.OnSelect()
        end
        Viewport.CurrentlySelected = Tab
    end

    function Viewport.CreateTab(Name,SceneID,OnSelect)
        local Tab = {Name = Name,SceneID = SceneID,OnSelect = OnSelect, Object = Studio.Components.CreateStyle("TextButton",{
            Size = Pivot2D.FromScale(0.15,1),
            Pivot = Vector2.new(0,-.15),
            ForegroundColor = "Text",
            Text = Name,
            TextScaled = false,
            TextSize = 16,
            Layer = 3,
            ForegroundTransparency = 0.5,
            Parent = Viewport.TopContainer,
            BackgroundColor = "Primary",
            CornerRadius = 10,
            Alignment = Vector2.new(0.5,0.05),
            Font = "FontBold"
        })}
        Tab.Object.Clicked:Connect(function()
            Viewport.SelectTab(SceneID)
        end)
        table.insert(Viewport.Tabs,Tab)
    end

    function Viewport.Init()
        Viewport.Tabs = {}
        Viewport.CurrentlySelected = nil

        local Environment = Things.Root:GetEnvironment()

        Studio.Components.CreateStyle("ListLayout", {
            Parent = Viewport.TopContainer,
            Padding = 4,
            Direction = Enum.LayoutDirection.Horizontal,
            Alignment = Enum.Alignment.MiddleLeft,
        })
        ---@type Viewport3D
        local EnvironmentViewport = Things.Create("Viewport3D") {
            RenderContainer = Environment,
            Name = "MainViewport",
            Layer = 7,
            Size = Pivot2D.FromScale(1,1),
            Parent = Viewport.Container
        }

        local HudViewport = Things.Create("Viewport2D") {
            RenderContainer = Things.Root:GetHUD(),
            Name = "HudViewport",
            Layer = 10,
            Size = Pivot2D.FromScale(1,1),
            Parent = Viewport.Container,
        }
        
        Things.Root:SetEnvironmentViewport(EnvironmentViewport)
        Things.Root.HudViewport = HudViewport

        Viewport.CreateTab("MainScene.sds",1)
        Viewport.CreateTab("AnotherScene.sds",2)

        Viewport.SelectTab(1)
    end

    return Viewport
end