local RenderService = {}

-- Ignore the code blockout!! cus idk how to do services rn
function RenderService.Init()
    RenderService.OnStep = Signal:New("GameStep")
end

function RenderService.Update(dt)
    RenderService.OnStep:Invoke(dt)
end

return RenderService