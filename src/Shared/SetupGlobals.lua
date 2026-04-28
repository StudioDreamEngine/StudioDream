local function Example()
    local ExampleSignal = Signal:New("TestSignal") -- This creates a new signal object, the first arg is the event name, useful for debugging, and the second arg is blocking, which currently isnt used and is optional

    -- connections can also have listeners, Which act as a filter
    ExampleSignal:Connect(function()
        print("I fire on Listener1")
    end, "Listener1")

    ExampleSignal:Connect(function()
        print("I fire on Listener2")
    end, "Listener2")

    -- connections with no listener fires even if a listener is present
    ExampleSignal:Connect(function()
        print("I fire on both listeners")
    end)

    ExampleSignal.Invoke()
end

local function PrintInfo()

end

-- Seperate parts of the game like the runtime will also have their own globals
-- in the future we could perhaps make an api for handling creation of globals, depends tho
return function ()
    -- Polyfill and Dependencies
    utf8 = require("Shared.Packages.utf8")
    require("Shared.Packages.LuauPolyfill")
    print("Polyfill Ready, Loading shared components")

    -- Packages
    Dream = require("Shared.Packages.3DreamEngine")
    Object = require("Shared.Packages.classic")
    Binser = require("Shared.Packages.Binser")
    FileDialog = require("Shared.Packages.filedialog")

    -- Helpers
    Signal = require("Shared.Helper.Signal")
    Scheduler = require("Shared.Helper.Scheduler")
    Utils = require("Shared.Helper.Utils")
    LoveEvents = require("Shared.Helper.LoveEvents")

    -- Types
    Pivot2D = require("Shared.Types.Pivot2D")
    Transform2D = require("Shared.Types.Transform2D")
    Enum = require("Shared.Types.Enum")
    Color = require("Shared.Types.Color")
    Rect = require("Shared.Types.Rect")

    -- Globals
    GlobalTick = 0

    --Example()
end