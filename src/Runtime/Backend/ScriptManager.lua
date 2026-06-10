-- Handle general management of non-module scripts
local ScriptManager = {}
local LoadQueued = {}
local StartedScripts = false

---@param Script BaseScript
function ScriptManager.RequestLoad(Script)
    if StartedScripts then Script:Load() return end

    print("Queued Script for loading")
    table.insert(LoadQueued, Script) 
end

function ScriptManager.StartScripts()
    StartedScripts = true

    ---@param Queued BaseScript
    for _, Queued in pairs(LoadQueued) do Queued:Load() end
    LoadQueued = {}
end

return ScriptManager