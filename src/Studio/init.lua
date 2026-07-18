-- Only named StudioMain cuz init.lua is taken by the main script for stepping this version of the client... MIKL...
-- Why yall blaming me vro!!!
Studio = {}

function Studio.Init()
    Studio.Theme = require("Studio.Theme")
    Studio.Editor3D = require("Studio.Editor3D")

    Studio.Layout = require("Studio.UI.StudioLayout")
    Studio.Components = require("Studio.UI.Components")

    Studio.ProjectManager = require("Studio.ProjectManager")

    Studio.Backend = require("Studio.Backend")
    
    Studio.EditorServices = Studio.Backend -- Mikl api backwards compat, remove later!

    Studio.Components.Init()
    Studio.Layout.CreateLayout()

    Studio.Editor3D.Init()
    Studio.Backend.Init()

    print("Finished Initalizing studio")
    Shared.ProcessQueue()
end

function Studio.Update(dt)
    Studio.Editor3D.Update(dt)
    Studio.Layout.Update(dt)
    Studio.Components.Update(dt)
end

return Studio