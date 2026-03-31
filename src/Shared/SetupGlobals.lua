-- Seperate parts of the game like the runtime will also have their own globals
-- in the future we could perhaps make an api for handling creation of globals, depends tho
return function ()
    -- Packages
    utf8 = require("Packages.utf8")
    require("LuauPolyfill")
    Dream = require("Packages.3DreamEngine")

    -- Helpers
    Signal = require("Helper.Signal")
    Scheduler = require("Helper.Scheduler")
    Utils = require("Helper.Utils")

    -- Globals
    GlobalTick = 0
end