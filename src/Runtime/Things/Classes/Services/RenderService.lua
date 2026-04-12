local Things = Runtime.Things
local RenderService = Things.Extend("BaseService")

-- Ignore the code blockout!! cus idk how to do services rn
function RenderService:new()
    RenderService.super.new(self)

    self.OnStep = Signal:New("GameStep")
end

function RenderService:Update(dt)
    self.OnStep:Invoke()
end

return RenderService