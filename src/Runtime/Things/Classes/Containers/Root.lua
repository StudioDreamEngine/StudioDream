local Things = Runtime.Things

---@class Root: Thing
local Root = Things.Extend("Thing")

function Root:new() 
    Root.super.new(self)

    self.Explorer = {
        
        Visible = true,
        Icon = "Root",
    }

    self.Serializable = false
    
    self.EnvironmentViewport = nil
    self.RootViewport = nil
end

---@return Camera
function Root:GetCamera()
    return self.EnvironmentViewport:GetCamera()
end

function Root:GetEnvironment()
    return self.EnvironmentViewport.RenderFolder
end

return Root