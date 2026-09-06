local Things = Runtime.Things

---@class Root: Thing
local Root = Things.Extend("Thing")

function Root:new() 
    Root.super.new(self)
    
    self.EnvironmentViewport = nil ---@class Viewport3D
    self.HudViewport = nil ---@class Viewport2D

    self.LODDistance = 10
    self.FrustumCheck = true
end

-- Clear and cleanup all objects
function Root:Clear()
    print("Clearing root")
    self:ClearAllChildren()

    if self.EnvironmentViewport then
        self.EnvironmentViewport:SetRenderContainer(nil)
    end

    if self.HudViewport then
        self.HudViewport:SetRenderContainer(nil)
    end

    Runtime.Project.Clear()
    Runtime.Things.TreeChanged.Invoke()
    Runtime.ScriptUtil.Reset()
    Scheduler.Yield(); Scheduler.Yield() -- wait 2 frames

    collectgarbage("collect")

    print("Finished clearing root")
end

function Root:SetLODDistance(Number)
    self.LODDistance = Number
    Dream:setLODDistance(Number)
end

function Root:SetFrustumCheck(Boolean)
    self.FrustumCheck = Boolean
    Dream:setFrustumCheck(Boolean)
end

function Root:DefineAPI()
    Root.super.DefineAPI(self)
    
    self.Proxy.Property("boolean FrustumCheck","number LODDistance")
    self.Proxy.Group("Render","FrustumCheck","LODDistance")
    self.Proxy.MakeNonDuplicatable()
    self.Proxy.Icon("Root")
end

-- Service() is reccommended to be used instead, but this is here for compatability
function Root:GetService(Service)
    return Runtime.Services.Service(Service)
end

function Root:OnRemove()
    self:Clear()
    print("Attempted to remove root, clearing root contents instead...")
end

---@return Camera
function Root:GetCamera()
    return self.EnvironmentViewport and self.EnvironmentViewport:GetCamera()
end

---@return Environment
function Root:GetEnvironment()
    return self:FindFirstChildOfClass("Environment")
end

---@return HUD
function Root:GetHUD()
    return self:FindFirstChildOfClass("GuiContainer")
end

return Root