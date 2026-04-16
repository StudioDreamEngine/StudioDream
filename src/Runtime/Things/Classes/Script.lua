local Things = Runtime.Things

---@module "Thing"
local Script = Things.Extend("BaseScript")

function Script:new()
    Script.super.new(self) 
end

function Script:SetScriptContents(New)
    if self.ScriptContents then
        error("Script contents already assigned")
    end

    self.ScriptContents = New

    Script.super.Load(self)
end

return Script