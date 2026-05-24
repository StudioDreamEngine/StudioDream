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
        Name = "Primitive",
        Shape = "ball",
        Dynamic = true
    }

    ---@class Primitive
    local wedge = Things.Create("Primitive") {
        Name = "Primitive",
        Shape = "wedge",
        Dynamic = true
    }

    brick:SetTransform(Transform3D.FromPosition(0, -10, 0))
    brick.Scale     = Vector3.new(512,5,512)

    --ball:SetTransform(Transform3D.FromPosition(10, 0, 0))
    wedge:SetTransform(Transform3D.FromPosition(0, 10, 0))

    --Mesh:SetParent(Environment)
    brick:SetParent(Environment)
    ball:SetParent(Environment)
    wedge:SetParent(Environment)

    --Things.SetDebugObject(Mesh)
end