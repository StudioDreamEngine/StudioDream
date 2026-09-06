return function()
    local Environment = Runtime.Things.Root:GetEnvironment() ---@class Environment

    local Camera = Runtime.Things.Create("Camera") {
        Parent = Environment
    }

    Runtime.Things.Create("Primitive") {
        Scale = Vector3.new(40,2,40),
        Position = Vector3.new(0,-10,0),
        Parent = Environment
    }

    Environment.Camera = Camera 
end