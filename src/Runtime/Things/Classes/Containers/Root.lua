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
    
    self.Proxy.MakeNonDuplicatable()
    self.Proxy.Icon("Root")
end

function Root:OnRemove()
    error("Attempted to remove root")
end

---@return Camera
function Root:GetCamera()
    return self.EnvironmentViewport and self.EnvironmentViewport:GetCamera()
end

---@return Environment
function Root:GetEnvironment()
    return self:FindFirstChild("Environment")
end

return Root