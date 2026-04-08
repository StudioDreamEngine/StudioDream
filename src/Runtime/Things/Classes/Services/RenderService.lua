local Things = Runtime.Things
local RenderService = Things.Extend("Thing")

function RenderService:Update(dt) end

local Signals = {
    RenderStep = nil
}

-- Ignore the code blockout!! cus idk how to do services rn
function RenderService:Init()
    local self = {}

    function self:RenderStep(dt)
        Signals.RenderStep = Signal:New("RenderStep")
    end

    return self
end

function RenderService:Update(dt)
    for i,v in Signals do
        v:InvokeSignal(dt)
    end
end

return RenderService