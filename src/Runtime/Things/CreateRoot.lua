local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    local Root = Things.Create("Container") {
        Name = "RootInternal",
        Serializable = false
    }

    ---@module 'Enviornment'
    local Enviornment = Things.Create("Enviornment") {
        Name = "Enviornment",
        Parent = Root
    }

    ---@module 'Viewport2D'
    local Viewport = Things.Create("Viewport2D") {
        Name = "ViewportInternal",
        Size = Pivot2D.FromOffset(800, 600),
        Serializable = false,
        Parent = Root
    }
    
    ---@module 'TextButton'
    local SaveTest = Things.Create("TextButton") {
        Parent = Viewport,
        Position = Pivot2D.FromScale(0,0.8)
    }

    SaveTest.Clicked:Connect(function()
        Runtime.Serializer.Save()
    end)

    Things.Create("Viewport3D") {
        Size = Pivot2D.FromScale(0.75,0.8),
        Position = Pivot2D.FromScale(0,0),
        Parent = Viewport,
        RenderFolder = Enviornment,
        Name = "MainViewport"
    }

    -- 3d test
    local Mesh = Things.Create("Mesh"){}
    local Primitive = Things.Create("Primitive"){
        Name = ":3"
    }

    Primitive.Position = Vector3.new(0, -1, 0)
    Primitive.Size = Vector3.new(512, 8, 512)

    Mesh:SetParent(Enviornment)
    Primitive:SetParent(Enviornment)

    return Root
end