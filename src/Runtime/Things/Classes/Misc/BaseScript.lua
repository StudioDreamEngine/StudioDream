local Things = Runtime.Things
local ScriptUtil = Runtime.ScriptUtil

---@class BaseScript: Thing
local BaseScript = Things.Extend("Thing")

function BaseScript:new()
    BaseScript.super.new(self)

    self.ScriptContents = nil
    self.ScriptTask = nil
    self.Resource = nil

    self.Required = nil

    self.ScriptLoaded = Signal:New("ScriptLoaded")
end

function BaseScript:DefineAPI()
    BaseScript.super.DefineAPI(self)

    self.Proxy.SetCategory("Script")

    self.Proxy.Icon("Script")
    self.Proxy.Property("Resource Resource")

    self.Proxy.Group("Script", "Resource")
end

function BaseScript:OnRemove()
    BaseScript.super.OnRemove(self)

    if self.ScriptTask then
        Scheduler.CancelTask(self.ScriptTask)
    end
end

function BaseScript:Traceback(Error)
    local TraceMessage = {
        "An error ocurred!",
        tostring(Error),
        "Traceback:"
    }
    local Level = 1
    while true do
        local info = debug.getinfo(Level,"nSl")
        if not info then break end
        if info.source and info.name == "ModuleFunction" then--string.sub(info.source,1,1) ~= "@" then  (..(info.name or "[NIL]"))
            table.insert(TraceMessage,"  At: "..(self:GetPath())..", Line: "..(info.currentline-1 or "-1").." ("..((info.currentline or "?"))..")")
        end
        Level = Level + 1
    end
    return table.concat(TraceMessage,"\n")
end

-- Load the script and yield until it is ready.
function BaseScript:Load()
    if (not self.ModuleFunction) then print("Attempted to load script ("..(self:GetPath() or "No path")..") without a resource attached") return end

    self.ScriptTask = Scheduler.QueueTask(function()
        xpcall(function()
            self.Required = self.ModuleFunction()
            self.ScriptLoaded:Invoke()
        end, function(Error)
            print(self:Traceback(Error))
        end)
    end)

    self.ScriptLoaded:Wait()
    return self.Required
end

function BaseScript:SetResource(Identifier)
    self.ModuleFunction, self.Resource = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID, "Script")
    if (not self.ModuleFunction) then return end

    self.ModuleFunction = self.ModuleFunction()

    setfenv(self.ModuleFunction, ScriptUtil.CreateGlobals(self))
end


return BaseScript