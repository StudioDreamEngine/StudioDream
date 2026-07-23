local Backend = {}

function Backend.Init()
    printVerbose("Initalizing Studio Backend")
    Studio.History = require("Studio.Backend.History")
    Studio.ScriptHandler = require("Studio.Backend.ScriptHandler")

    Studio.History.Init()
end

return Backend