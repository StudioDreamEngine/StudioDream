local Things = Runtime.Things

---@class Root: Thing
local Root = Things.Extend("Thing")

function Root:new() 
    Root.super.new(self)

    self.Explorer = {
        UseNewIcon = true,
        Visible = true,
        Icon = "Root",
    }

    self.Serializable = false
    
    self.EnvironmentViewport = nil
    self.RootViewport = nil
end

return Root