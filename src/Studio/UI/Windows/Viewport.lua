local Things = Runtime.Things
local Viewport = {}

function Viewport.Init()
    local Environment = Things.Root:GetEnvironment()
    
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
        Parent = Viewport.Container
    }
    
    Things.Root.EnvironmentViewport = EnvironmentViewport
    Things.Root.HudViewport = HudViewport
end

return Viewport