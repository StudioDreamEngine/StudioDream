local Backend = {}

function Backend.Init()
    printVerbose("Initalizing Studio Backend")
    Studio.History = require("Studio.Backend.History")
    Studio.ScriptHandler = require("Studio.Backend.ScriptHandler")
    Studio.ShortcutsHandler = require("Studio.Backend.Shortcuts")
    Studio.AudioInternal = require("Studio.Backend.AudioInternal")
    Studio.PresenceService = Runtime.Services.Service("PresenceService")

    Studio.PresenceService.InitDiscord()
    Studio.History.Init()
    Studio.ShortcutsHandler.Init()
end

return Backend