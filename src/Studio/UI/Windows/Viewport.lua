local Things = Runtime.Things
local Tween = Runtime.Services.Service("TweenService")

return function(Viewport)
    function Viewport.SelectScene(ID)
        local Tab = Viewport.Tabs[ID]

        Viewport.CurrentlySelected = ID
    end

    function Viewport.CreateTab(Name,SceneID)
        local Tab = {}

        Tab.Name = Name
        Tab.SceneID = SceneID

        Tab.Object = Studio.Components.CreateStyle("TextButton",{
            Size = Pivot2D.new(0,200,1,0),
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
        })

        Tab.Object.Clicked:Connect(function()
            Viewport.SelectScene(SceneID)
        end)

        Viewport.Tabs[SceneID] = Tab
    end

    function Viewport.Init()
        Viewport.Tabs = {}
        Viewport.CurrentlySelected = nil

        local Environment = Things.Root:GetEnvironment()

        Viewport.TopContainer:ClearAllChildren()
        Viewport.TopContainer:SetPosition(Pivot2D.new(0.5,0,0,40))
        Viewport.TopContainer:SetPivot(Vector2.new(0.5,1))
        Viewport.TopContainer:SetSize(Pivot2D.new(1,0,0,30))

        Viewport.Container:SetPivot(Vector2.one)
        Viewport.Container:SetPosition(Pivot2D.FromScale(1,1))
        Viewport.Container:SetSize(Pivot2D.new(1,0,1,-30))

        local Dropdown

        local OpenScene = Studio.Components.CreateStyle("ImageButton", {
            Size = Pivot2D.FromScale(0.6,0.6),
            Pivot = Vector2.new(1,0.5),
            Position = Pivot2D.new(1,-2,0.25,0),
            SquareAxis = Enum.SquareAxis.Y,
            IgnoreConstraints = true,
            CornerRadius = 10,
            Parent = Viewport.TopContainer,
            BackgroundTransparency = 0,
            BackgroundColor = "Primary",
            Resource = "Internal/Studio/AddThing.png",
            Clicked = function() Dropdown.Toggle() end
        })

        Dropdown = Studio.Components.DropdownPlus.new({
            {
                Type = "Button",
                Text = "Load Scene",
                Function = function()
                    Studio.Components.OpenResourcePicker(function(Identifier)
                        Runtime.Project.LoadEnviornment(Identifier)
                    end)
                end
            },
            {
                Type = "Button",
                Text = "Create Scene",
                Function = function()
                    Studio.Layout.GetHandle("Dialogs").CreateDialog("Input",{
                        Topic = "Give the scene name",
                        Placeholder = "Scene Name",
                        ApplyButton = "Create scene",
                        OnEnd = function(_,Text)
                            local IdentifierID = Runtime.Resources.GetOrCreateIdentifierID(Text..".sds")

                            local Scene = Runtime.Things.CreateTemplate("Environment")
                            Scene.Scene = IdentifierID

                            Runtime.Project.Scenes.SaveScene(Scene)
                            Scene:Destroy()
                        end,
                    })
                end
            }
        }, OpenScene, Vector2.new(140,20))

        Dropdown.Toggle(false)

        Studio.Components.CreateStyle("ListLayout", {
            Parent = Viewport.TopContainer,
            Padding = 4,
            SortMode = Enum.SortMode.Order,
            Direction = Enum.LayoutDirection.Horizontal,
            Alignment = Enum.Alignment.TopLeft,
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

        Viewport.SelectScene(1)
    end

    function Viewport.Update(dt)
        for _, Tab in pairs(Viewport.Tabs) do
            local IsSelected = Tab.SceneID == Viewport.CurrentlySelected

            --Tab.Object:SetPivot(Tab.Object.Pivot:Lerp(Vector2.new(0, IsSelected and .05 or -.15), dt*16))
            Tab.Object:SetPivot(Vector2.new(0, IsSelected and .05 or -.15))

            Tab.Object.ForegroundTransparency = IsSelected and 0.25 or 0.5
            Tab.Object.BackgroundTransparency = IsSelected and 0 or 0.5
        end
    end

    return Viewport
end