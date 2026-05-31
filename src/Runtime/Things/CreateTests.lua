local Things = Runtime.Things

return function ()
    local Environment = Things.GetRoot("Environment")
    local Viewport = Things.Root.RootViewport

    -- 3d test
    ---@class Mesh
    --local Mesh = Things.Create("Mesh") {}

    ---@class Primitive
    local brick = Things.Create("Primitive") {
        Name = "Ground"
    }

    ---@class Primitive
    local ball = Things.Create("Primitive") {
        Name = "Ball",
        Shape = Enum.Shape.Ball,
        Dynamic = true
    }

    ---@class Primitive
    local wedge = Things.Create("Primitive") {
        Name = "Primitive",
        Shape = "wedge",
        Dynamic = true
    }

    local Folder = Things.Create("Folder") {
        Parent = Environment
    }

    Runtime.BackendFS.MountProject("../tests/ProjectTest/")
    --Runtime.Resources.RegisterIdentifier("ResourceTest", "Field of Hopes and Dreams.mp3")
    Runtime.Resources.RegisterIdentifier("ResourceTest", "GK_NTTE.wav")

    Things.Create("Audio") {
        Resource = "ResourceTest"
    }

    brick.Scale     = Vector3.new(512,5,512)
    brick:SetTransform(Transform3D.FromPosition(0, -10, 0))

    wedge:SetTransform(Transform3D.FromPosition(0, 10, 0))

    --Mesh:SetParent(Environment)
    brick:SetParent(Environment)
    ball:SetParent(Environment)
    wedge:SetParent(Environment)

    --Things.SetDebugObject(Mesh)
end