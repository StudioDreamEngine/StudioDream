-- Only named StudioMain cuz init.lua is taken by the main script for stepping this version of the client... MIKL...
-- Why yall blaming me vro!!!
local Studio = {}

Studio.Theme = require("Studio.Theme")

Studio.Editor3D = require("Studio.Editor3D")

function Studio.Init()
    Studio.Layout = require("Studio.UI.StudioLayout")
    Studio.Components = require("Studio.UI.Components")

    Studio.Layout.CreateLayout()
    Studio.Components.Init()

    Studio.Editor3D.Init()
end

function Studio.Update(dt)
    Studio.Editor3D.Update(dt)
end

return Studio