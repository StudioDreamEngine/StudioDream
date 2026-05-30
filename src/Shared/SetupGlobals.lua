-- Seperate parts of the game like the runtime will also have their own globals
-- in the future we could perhaps make an api for handling creation of globals, depends tho
return function ()
    -- Polyfill and Dependencies
    utf8 = require("Shared.Packages.utf8")
    require("Shared.Packages.LuauPolyfill")
    print("Polyfill Ready, Loading shared components")

    -- Packages
    Dream = require("Shared.Packages.3DreamEngine")
    Binser = require("Shared.Packages.Binser")
    FileDialog = require("Shared.Packages.filedialog")
    TweenFunctions = require("Shared.Packages.Tweener")
    NativeFS = require("Shared.Packages.nativefs")

    -- Helpers
    Signal = require("Shared.Helper.Signal")
    Scheduler = require("Shared.Helper.Scheduler")
    Utils = require("Shared.Helper.Utils")
    LoveEvents = require("Shared.Helper.LoveEvents")
    Profiler = require("Shared.Helper.Profiler")

    -- Types
    require("Shared.SetupTypes")()

    -- Globals
    GlobalTick = 0

    --Example()

    -- Load the second stage of globals
    return function()
        local BulletModule = require("Shared.Packages.bullet3min")
        BulletModule.init()
        Bullet = BulletModule.bindings
    end
end