local Things = Runtime.Things

---@class Root: Thing
local Root = Things.Extend("Thing")

function Root:new() 
    Root.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "Root",
    }
    
    self.EnvironmentViewport = nil ---@class Viewport3D
    self.HudViewport = nil ---@class Viewport2D
end

-- Clear and cleanup all objects
function Root:Clear()
    self:ClearAllChildren()

    if self.EnvironmentViewport then
        self.EnvironmentViewport:SetRenderContainer(nil)
    end

    if self.HudViewport then
        self.HudViewport:SetRenderContainer(nil)
    end

    Runtime.Things.TreeChanged.Invoke()
    Runtime.ScriptUtil.Reset()
    Scheduler.Yield(); Scheduler.Yield() -- wait 2 frames

    collectgarbage("collect")
end

function Root:DefineAPI()
    Root.super.DefineAPI(self)
    
    self.Proxy.MakeNonDuplicatable()
    self.Proxy.Icon("Root")
end

-- Service() is reccommended to be used instead, but this is here for compatability
function Root:GetService(Service)
    return Runtime.Services.Service(Service)
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
    return self:FindFirstChildOfClass("Environment")
end

---@return HUD
function Root:GetHUD()
    return self:FindFirstChildOfClass("GuiContainer")
end

return Root