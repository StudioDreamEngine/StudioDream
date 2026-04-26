local Things = Runtime.Things
local ScriptUtil = Runtime.ScriptUtil

---@module "Thing"
---@class BaseScript: Thing
local BaseScript = Things.Extend("Thing")

function BaseScript:new()
    BaseScript.super.new(self)

    self.ScriptContents = nil
    self.ScriptTask = nil
    self.Require = nil -- Required table if it exists

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = self.IsModule and "Requireable_Script" or "Script"
    }
end

-- Called on initalization of the script
function BaseScript:Load()
    if self.Require then
        print("Reloading already loaded script")
        return self.Require
    end

    local Contents = "return function()\n"..self.ScriptContents.."\nend"

    local Globals = ScriptUtil.CreateGlobals(self)
    local ModuleFunction = load(Contents, self.Name, "t", Globals)()

    self.ScriptTask = Scheduler.NewTask(function()
        self.Require = ModuleFunction()
    end)

    return self.Require
end

return BaseScript