local Things = Runtime.Things

---@class RequirableScript: BaseScript
local RequirableScript = Things.Extend("BaseScript")

function RequirableScript:new()
    RequirableScript.super.new(self)
end

function RequirableScript:Require() return RequirableScript:Load() end

return RequirableScript