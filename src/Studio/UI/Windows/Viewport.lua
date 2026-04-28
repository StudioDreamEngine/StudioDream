local Things = Runtime.Things
local Viewport = {}

function Viewport.Init(WindowContainer)
    local Enviornment = Things.GetRoot("Environment")
    
    ---@type Viewport3D
    local EnvironmentViewport = Things.Create("Viewport3D") {
        RenderFolder = Enviornment,
        Name = "MainViewport",
        Size = Pivot2D.FromScale(1,1),
        Parent = WindowContainer
    }

    Things.Root.EnvironmentViewport = EnvironmentViewport
end

return Viewport