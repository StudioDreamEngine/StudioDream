local Backend = {}

function Backend.Init()
    printVerbose("Initalizing Studio Backend")
    Studio.History = require("Studio.Backend.History")
    Studio.ScriptHandler = require("Studio.Backend.ScriptHandler")
    Studio.PresenceService = Runtime.Services.Service("PresenceService")
    Studio.PresenceService.InitDiscord()

    Studio.History.Init()
end

return Backend