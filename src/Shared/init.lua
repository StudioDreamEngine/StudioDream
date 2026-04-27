local Shared = {}

function Shared.Update(dt)
    GlobalTick = GlobalTick + dt
    Scheduler.Update()
end

return Shared