local Things = Runtime.Things

return function ()
    local Environment = Things.GetRoot("Environment")
    local Viewport = Things.Root.RootViewport

    ---@module 'TextButton'
    local SaveTest = Things.Create("TextButton") {
        Parent = Viewport,
        Text = "Save",
        Position = Pivot2D.FromScale(0,0.8)
    }

    SaveTest.Clicked:Connect(function()
        Runtime.Serializer.Save()
    end)

    ---@module 'TextButton'
    local LoadTest = Things.Create("TextButton") {
        Parent = Viewport,
        Text = "Load",
        Position = Pivot2D.FromScale(0.1,0.8)
    }

    LoadTest.Clicked:Connect(function()
        Runtime.Serializer.Load()
    end)

    -- 3d test
    ---@class Mesh
    local Mesh = Things.Create("Mesh") {}

    ---@class Primitive
    local brick = Things.Create("Primitive") {
        Name = "Primitive"
    }
    
    ---@class Primitive
    local ball = Things.Create("Primitive") {
        Name = "Primitive",
        Shape = "ball"
    }

    ---@class Primitive
    local wedge = Things.Create("Primitive") {
        Name = "Primitive",
        Shape = "wedge"
    }

    brick.Transform = Transform3D.FromPosition(0, -1, 0)
    brick.Scale     = Vector3.new(512, 8, 512)

    ball.Transform = Transform3D.FromPosition(1, 0, 0)
    wedge.Transform = Transform3D.FromPosition(-1, 0, 0)

    Mesh:SetParent(Environment)
    brick:SetParent(Environment)
    ball:SetParent(Environment)
    wedge:SetParent(Environment)

    Things.SetDebugObject(Mesh)
end