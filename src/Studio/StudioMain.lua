-- Only named StudioMain cuz init.lua is taken by the main script for stepping this version of the client... MIKL...
local Studio = {}

Studio.Editor3D = require("Studio.Editor3D")

Studio.StudioLayout = require("Studio.UI.StudioLayout")

function Studio.Init()
    Studio.StudioLayout.CreateLayout()
    Studio.Editor3D.Init()
end

function Studio.Update(dt)
end

return Studio