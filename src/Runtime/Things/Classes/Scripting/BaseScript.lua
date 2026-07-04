local Things = Runtime.Things
local ScriptUtil = Runtime.ScriptUtil

---@module "Thing"
---@class BaseScript: Thing
local BaseScript = Things.Extend("Thing")

function BaseScript:new()
    BaseScript.super.new(self)

    self.ScriptContents = nil
    self.ScriptTask = nil
    self.Resource = nil

    self.Required = nil

end

function BaseScript:DefineAPI()
    BaseScript.super.DefineAPI(self)

    self.Proxy.Icon("Script")
    self.Proxy.Property("Resource Resource")

    self.Proxy.Group("Script", "Resource")

    self.Proxy.MakeCreatable()
end

function BaseScript:Load()
    if (not self.ModuleFunction) then return end

    self.ScriptTask = Scheduler.NewTask(function()
        self.Required = self.ModuleFunction()
    end)

    return self.Required
end

function BaseScript:SetResource(Identifier)
    self.ModuleFunction, self.Resource = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID)
    self.ModuleFunction = self.ModuleFunction()

    setfenv(self.ModuleFunction, ScriptUtil.CreateGlobals(self))
end


return BaseScript