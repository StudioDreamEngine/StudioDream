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

function Root:DefineAPI()
    Root.super.DefineAPI(self)

    self.Proxy.Icon("Root")
end

---@return Camera
function Root:GetCamera()
    return self.EnvironmentViewport and self.EnvironmentViewport:GetCamera()
end

---@return Environment
function Root:GetEnvironment()
    return self.EnvironmentViewport.RenderContainer
end

return Root