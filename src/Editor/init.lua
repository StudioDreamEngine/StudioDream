local Editor = {}

Runtime = require("Runtime")

function Editor.Init()
    Studio = require("Editor.Studio")

    Runtime.Init()
    Studio.Init()
end

function Editor.Update(dt)
    Runtime.Update(dt)
    Studio.Update(dt)
end

function Editor.Render()
    Runtime.Render()
end

return Editor