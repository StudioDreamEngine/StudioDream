local Shared = {}

function Shared.Init()
    require("Shared.SetupGlobals")()
end

function Shared.Update(dt)
    GlobalTick = GlobalTick + dt

    Scheduler.Update()
end

return Shared