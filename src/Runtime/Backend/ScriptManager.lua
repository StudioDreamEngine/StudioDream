-- Handle general management of non-module scripts
local ScriptManager = {}
local LoadQueued = {}
local StartedScripts = false

-- Queue a script for loading, as we may not want to start scripts immediately
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