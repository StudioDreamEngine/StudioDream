local Things = Runtime.Things

-- Primative script loader for studio
-- my idea is so that we can make things easier, we dont need to use the serialization system for anything in studio, and instead all of it can be loaded directly
local ScriptLoader = {}

function ScriptLoader.LoadScript(Path, IsRequirable)
    ---@module "Runtime.Things.Classes.Script"
    local Script = Things.New(IsRequirable and "RequireableScript" or "Script")

    -- TODO: Replace with ResourcableThing system once added
    Script:SetScriptContents(love.filesystem.read(Path))

    return Script
end

return ScriptLoader