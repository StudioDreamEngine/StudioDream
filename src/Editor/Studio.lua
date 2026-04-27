local Editor = {}

Editor.Camera = require("Editor.cameraController")
Editor.Selection = require("Editor.Selection")

Editor.StudioLayout = require("Editor.UI.StudioLayout")

function Editor.Init()
    Editor.StudioLayout.CreateLayout()
    Editor.Selection.Init()
end

function Editor.Update(dt)
end

return Editor