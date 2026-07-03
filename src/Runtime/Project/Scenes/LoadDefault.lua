return function()
    local Environment = Runtime.Things.GetRoot("Environment") ---@class Environment

    local Camera = Runtime.Things.Create("Camera") {
        Parent = Environment
    }

    Runtime.Things.Create("Primitive") {
        Scale = Vector3.new(100,2,100),
        Position = Vector3.new(0,-10,0),
        Parent = Environment
    }

    Environment.Camera = Camera
end