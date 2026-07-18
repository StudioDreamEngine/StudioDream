local Backend = {}

function Backend.Init()
    print("Initalizing Studio Backend")
    Studio.Undo = require("Studio.Backend.Undo")
    Studio.ScriptHandler = require("Studio.Backend.ScriptHandler")

    Backend.Undo = Studio.Undo
end

return Backend