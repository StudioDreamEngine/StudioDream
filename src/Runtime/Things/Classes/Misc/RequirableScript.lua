local Things = Runtime.Things

---@class RequirableScript: BaseScript
local RequirableScript = Things.Extend("BaseScript")

function RequirableScript:new()
    RequirableScript.super.new(self)
end

function RequirableScript:DefineAPI()
    RequirableScript.super.DefineAPI(self)
    self.Proxy.MakeCreatable()
    self.Proxy.Icon("Requireable_Script")
end

function RequirableScript:Require() return RequirableScript:Load() end

return RequirableScript