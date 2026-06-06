local Things = Runtime.Things
local ScriptUtil = Runtime.ScriptUtil

---@module "Thing"
---@class Script: BaseScript
local Script = Things.Extend("BaseScript")

function Script:new()
    Script.super.new(self) 
end

return Script