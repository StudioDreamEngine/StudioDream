local Editor = {}

Editor.Camera = require("Editor.cameraController")
Editor.UI = require("Editor.UI")

function Editor.Init()
    Editor.Theme = require("Editor.Theme")

    Editor.UI.Init(Runtime.Things.GetRoot("ViewportInternal"))
end

function Editor.Render(dt)
    --TODO
end

function Editor.Update()
    
end

return Editor