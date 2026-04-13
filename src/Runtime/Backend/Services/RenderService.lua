local RenderService = {}

-- Ignore the code blockout!! cus idk how to do services rn
function RenderService:Init()
    self.OnStep = Signal:New("GameStep")
end

function RenderService:Update(dt)
    self.OnStep:Invoke(dt)
end

return RenderService