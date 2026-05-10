-- Only named StudioMain cuz init.lua is taken by the main script for stepping this version of the client... MIKL...
-- Why yall blaming me vro!!!
local Studio = {}

Studio.Editor3D = require("Studio.Editor3D")
Studio.StudioLayout = require("Studio.UI.StudioLayout")
Studio.SelectionPriority = require("Studio.SelectionPriority")

function Studio.Init()
    Studio.StudioLayout.CreateLayout()
    Studio.Editor3D.Init()
    Studio.SelectionPriority.Init()
end

function Studio.Update(dt)
    Studio.Editor3D.Update(dt)
end

return Studio