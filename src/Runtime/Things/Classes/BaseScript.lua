local Things = Runtime.Things

---@module "Thing"
local BaseScript = Things.Extend("Thing")

function BaseScript:new()
    self.ScriptContents = ""
    self.ScriptTask = nil

    self.IsModule = false
end

-- Called on initalization of the script
function BaseScript:Load()
    local Contents = self.ScriptContents

    if (not self.IsModule) then
        -- TODO: If lua complains, add some code to return a table around self.ScriptContents
    end

    local Module = load(Contents, nil, "t", {})

    print(Module)

    return Module
end

return BaseScript