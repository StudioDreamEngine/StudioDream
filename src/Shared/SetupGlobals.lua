local function LoadTypes()
    for _, v in pairs(Utils.GetFolderDescendants("Shared/Types/", true)) do
        local Name = string.split(v,"%.")[1]

        _G[Name] = require("Shared.Types."..Name)
    end
end

-- Seperate parts of the game like the runtime will also have their own globals
-- in the future we could perhaps make an api for handling creation of globals, depends tho
return function ()
    -- Packages
    utf8 = require("Shared.Packages.utf8")
    require("Shared.Packages.LuauPolyfill")
    Dream = require("Shared.Packages.3DreamEngine")
    Object = require("Shared.Packages.classic")
    Binser = require("Shared.Packages.Binser")
    FileDialog = require("Shared.Packages.filedialog")

    -- Helpers
    Signal = require("Shared.Helper.Signal")
    Scheduler = require("Shared.Helper.Scheduler")
    Utils = require("Shared.Helper.Utils")

    -- Types
    Pivot2D = require("Shared.Types.Pivot2D")
    Transform2D = require("Shared.Types.Transform2D")
    Enum = require("Shared.Types.Enum")
    Color = require("Shared.Types.Color")
    Rect = require("Shared.Types.Rect")
    --LoadTypes()

    -- Globals
    GlobalTick = 0
end