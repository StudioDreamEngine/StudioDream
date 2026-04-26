local Editor = {}

Editor.Camera = require("Editor.cameraController")
Editor.UI = require("Editor.UI")
Editor.Selection = require("Editor.Selection")

function Editor.Init()
    Editor.Theme = require("Editor.Theme")

    Editor.UI.Init(Runtime.Things.GetRoot("ViewportInternal"))
    Editor.Selection:Init()
end

function Editor.Render(dt)
    --TODO
end

function Editor.Update()
    
end

return Editor