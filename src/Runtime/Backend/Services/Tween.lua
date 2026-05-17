local TweenService = {}

local ActiveTweens = {}

function TweenService.Init()
    
end

function TweenService.Create(Time, Subject, Target, Style, InOrOut)
    local UUID = CreateUUID()
    InOrOut = InOrOut or "in"
    Style = Style or "linear"
    local FinishedStyle = (Style~="linear") and InOrOut..Style or "linear"
    print(Target)
    ActiveTweens[UUID] = {
        StartTime = GlobalTick,
        Tween = Tweener.new(Time, Subject, Target, FinishedStyle)
    }

    return UUID
end

-- Internal function to step util tweens
function TweenService.Update(dt)
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

return TweenService