local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    local Root = Things.Create("Root", "Root") {
        Name = "Root"
    }

    ---@module 'Environment'
    local Environment = Things.Create("Environment") {
        Name = "Environment",
        Parent = Root
    }
     local HUD = Things.Create("HUD") {
        Name = "HUD",
        Parent = Root
    }
    ---@module 'Viewport2D'
    local Viewport = Things.Create("Viewport2D") {
        Name = "ViewportInternal",
        Size = Pivot2D.FromOffset(800, 600),
        Serializable = false,
        Explorer = {
            Visible = false
        },
        Parent = Root
    }
    --@module 'Camera'
    local Camera = Things.Create("Camera") {
        Name = 'Camera',
        Parent = Environment
    }
    
    ---@module 'TextButton'
    local SaveTest = Things.Create("TextButton") {
        Parent = Viewport,
        Position = Pivot2D.FromScale(0,0.8)
    }

    SaveTest.Clicked:Connect(function()
        Runtime.Serializer.Save()
    end)

    ---@module 'TextButton'
    local LoadTest = Things.Create("TextButton") {
        Parent = Viewport,
        Position = Pivot2D.FromScale(0.1,0.8)
    }

    LoadTest.Clicked:Connect(function()
        Runtime.Serializer.Load()
    end)

    local Viewport3Dwow = Things.Create("Viewport3D") {
        Size = Pivot2D.FromScale(0.75,0.8),
        Position = Pivot2D.FromScale(0,0),
        Parent = Viewport,
        RenderFolder = Environment,
        Name = "MainViewport"
    }

    -- 3d test
    ---@class Mesh
    local Mesh = Things.Create("Mesh"){}
    ---@class Primitive
    local brick = Things.Create("Primitive"){
        Name = "Primitive"
    }
    ---@class Primitive
    local ball = Things.Create("Primitive"){
        Name = "Primitive",
        Shape = "ball"
    }
    ---@class Primitive
    local wedge = Things.Create("Primitive"){
        Name = "Primitive",
        Shape = "wedge"
    }

    brick.Position = Vector3.new(0, -1, 0)
    brick.Size     = Vector3.new(512, 8, 512)

    ball.Position  = Vector3.new(1, 0, 0)
    wedge.Position = Vector3.new(-1, 0, 0)

    Mesh:SetParent(Environment)
    brick:SetParent(Environment)
    ball:SetParent(Environment)
    wedge:SetParent(Environment)

    Runtime.Services.InputService:SetViewportDefaultOnService(Viewport3Dwow)
    Runtime.Services.Debug:SetViewportDefaultOnService(Viewport3Dwow)
    Runtime.Services.Debug:AssingScripty(Mesh)
    return Root
end