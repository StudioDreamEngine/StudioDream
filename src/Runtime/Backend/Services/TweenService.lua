---@class TweenService
local TweenService = {}

-- t = time == how much time has to pass for the tweening to complete
-- b = begin == starting property value
-- c = change == ending - beginning
-- d = duration == running time. How much time has passed *right now*

local ActiveTweens = {}

function TweenService.Init()
    
end

-- TODO: Pause & Stop functions?
function TweenService.Create(Subject, Target, Style, Time)
    local Tween = {}

    Tween.UUID = CreateUUID()
    Tween.Type = "Tween"

    local EasingFunction = TweenFunctions.easing[Style]

    local StartTime = 0
    Tween.Playing = false

    local InitalValues = {}
    
    function Tween.Play()
        StartTime = GlobalTick
        Tween.Playing = true

        ActiveTweens[Tween.UUID] = Tween

        for Name, _ in pairs(Target) do
            InitalValues[Name] = Subject[Name]
        end

        return Tween
    end

    --[[
        GotoTarget: If we should go to the target values once this is called
    ]]
    function Tween.Stop(GotoTarget)
        if GotoTarget then Tween.Set(1) end

        ActiveTweens[Tween.UUID] = nil
        Tween.Playing = false
    end

    function Tween.Set(Alpha)
        for Name, Value in pairs(Target) do
            local SubjectVal = InitalValues[Name]
            local TargetValue = 0

            if type(SubjectVal) == "table" and SubjectVal.Lerp then
                TargetValue = SubjectVal.Lerp(Value, Alpha)
            elseif type(SubjectVal) == "number" then
                TargetValue = math.lerp(SubjectVal, Value, Alpha)
            end

            Runtime.Things.SetProperty(Subject, Name, TargetValue)
        end
    end

    function Tween.Update(dt)
        if (not Tween.Playing) then return end

        local Elapsed = (GlobalTick-StartTime)

        if Elapsed/Time >= 1 then 
            Tween.Stop(true) 
            return
        end

        local LerpedAlpha = EasingFunction(Elapsed, 0, 1, Time)
        Tween.Set(LerpedAlpha)
    end

    return Tween
end

function TweenService.LinkTick(tick)
    -- Doesnt exist now sorrey!
end

function TweenService.CreateAndPlay(Subject, Target, Style, Time, Wow)
    local Tween = TweenService.Create(Subject, Target, Style, Time).Play()
    if not Time then print("Not given Time! Please try again!") return end
    Scheduler.Yield(Time)

    return Tween
end

-- Internal function to step util tweens
function TweenService.Update(dt)
    for UUID, Tween in pairs(ActiveTweens) do
        Tween.Update(dt)
    end
end

return TweenService