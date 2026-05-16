local Tween = {}

local ActiveTweens = {}

function Tween.StartTween(Time, Subject, Target, Style)
    local UUID = CreateUUID()

    ActiveTweens[UUID] = {
        StartTime = GlobalTick,
        Tween = Tween.new(Time, Subject, Target, Style)
    }

    return UUID
end

-- Internal function to step util tweens
function Tween.Update(dt)
    for UUID, Tween in pairs(ActiveTweens) do
        local Alpha = GlobalTick - Tween.StartTime

        --[[if Tween.Choppy then
            Alpha = Utils.Round(GlobalTick - Tween.StartTime, Tween.Choppy)
        end]]

        Tween.Tween:set(Alpha)

	    if GlobalTick > (Tween.StartTime + Tween.Tween.duration) then 
            ActiveTweens[UUID] = nil 
        end
    end
end

return Tween