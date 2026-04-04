-- Seperate parts of the game like the runtime will also have their own globals
-- in the future we could perhaps make an api for handling creation of globals, depends tho
return function ()
    -- Packages
    utf8 = require("Packages.utf8")
    require("LuauPolyfill")
    Dream = require("Packages.3DreamEngine")
    Object = require("Packages.classic")

    -- Helpers
    Signal = require("Helper.Signal")
    Scheduler = require("Helper.Scheduler")
    Utils = require("Helper.Utils")

    -- Types
    Pivot2D = require("Types.Pivot2D")
    Transform2D = require("Types.Transform2D")

    -- Globals
    GlobalTick = 0
end