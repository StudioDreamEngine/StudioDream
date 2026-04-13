local Things = Runtime.Things

---@module "Thing"
local Script = Things.Extend("BaseScript")

function Script:new()
    Script.super.new(self) 
    Script.super.Load(self)
end

return Script