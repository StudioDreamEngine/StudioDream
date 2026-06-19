local Things = Runtime.Things
local ScriptUtil = Runtime.ScriptUtil

---@module "Thing"
---@class Script: BaseScript
local Script = Things.Extend("BaseScript")

function Script:new()
    Script.super.new(self) 

    self.Enabled = false
    self.RestartOnEnable = true -- TODO: Add support
end

function Script:OnRemove()
    Script.super.OnRemove(self)
end

function Script:DefineAPI()
    Script.super.DefineAPI(self)

    self.Proxy.Property("boolean Enabled","boolean RestartOnEnable")--, "boolean RestartOnEnable")
    self.Proxy.Group("Script", "Enabled", "RestartOnEnable")--, "RestartOnEnable")
end

function Script:AttemptLoad()
    ScriptUtil.RequestLoad(self)
end

function Script:SetEnabled(Enabled)
    self.Enabled = Enabled

    if (not Enabled) then
        if (not self.ScriptTask) then return end

        Scheduler.CancelTask(self.ScriptTask)
        self.ScriptTask = nil
    else
        self:AttemptLoad()
    end
end

return Script