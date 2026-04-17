local Things = Runtime.Things

---@module "Thing"
---@class RequirableScript
local RequirableScript = Things.Extend("BaseScript")

function RequirableScript:new()
    RequirableScript.super.new(self)
end

return RequirableScript