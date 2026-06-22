local Things = Runtime.Things
local Viewport = {}

function Viewport.Init()
    local Environment = Things.GetRoot("Environment")
    
    ---@type Viewport3D
    local EnvironmentViewport = Things.Create("Viewport3D") {
        RenderContainer = Environment,
        Name = "MainViewport",
        Size = Pivot2D.FromScale(1,1),
        Parent = Viewport.Container
    }

    local HudViewport = Things.Create("Viewport2D") {
        RenderContainer = Things.GetRoot("HUD"),
        Name = "HudViewport",
        Layer = 2,
        Size = Pivot2D.FromScale(1,1),
        Parent = Viewport.Container
    }
    
    Things.Root.EnvironmentViewport = EnvironmentViewport
end

return Viewport