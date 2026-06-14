local EditorServices = {}

function EditorServices.Init()
    EditorServices.Undo = require("Studio.EditorServices.Services.Undo")

    EditorServices.Undo.Init()
end

return EditorServices