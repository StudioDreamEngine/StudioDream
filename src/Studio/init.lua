local Editor = {}

function Editor.Init()
    Studio = require("Studio.StudioMain")
    Studio.Init()
end

function Editor.Update(dt)
    Studio.Update(dt)
end

return Editor