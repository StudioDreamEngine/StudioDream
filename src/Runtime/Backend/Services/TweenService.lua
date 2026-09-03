---@class TweenService
local TweenService = {}

-- t = time == how much time has to pass for the tweening to complete
-- b = begin == starting property value
-- c = change == ending - beginning
-- d = duration == running time. How much time has passed *right now*

function TweenService.Init()
    
end

-- Create a tween group, these are used for pausing/unpausing a certain group of tweens
function TweenService.CreateGroup()
    local Group = {}
    local ActiveTweens = {}

    Group.Playing = true
    Group.Tick = 0

    function Group.Add(Tween)
        ActiveTweens[Tween.UUID] = Tween
        Tween.Group = Group
    end

    function Group.Remove(Tween)
        ActiveTweens[Tween.UUID] = nil
        Tween.Group = nil
    end

    function Group.Toggle(Paused)
        Group.Playing = not Paused
    end

    function Group.Update(dt)
        if Group.Playing then
            for _, Tween in pairs(ActiveTweens) do
                Tween.Update(dt)
            end
        end
    end

    return Group
end

local CurrentGroup = TweenService.CreateGroup()

-- TODO: Pause & Stop functions?
function TweenService.Create(Subject, Target, Style, Time)
    local Tween = {}

    Tween.UUID = CreateUUID()
    Tween.Type = "Tween"
    Tween.Group = nil
    Tween.Elapsed = 0

    local EasingFunction = TweenFunctions.easing[Style]

    Tween.Playing = false

    Tween.Completed = Signal:New("Completed_Tween")

    local InitalValues = {}
    
    function Tween.Play()
        Tween.Playing = true

        for Name, _ in pairs(Target) do
            InitalValues[Name] = Subject[Name]
        end

        return Tween
    end

    function Tween.LinkToGroup(Group)
        if Tween.Group then
            Tween.Group.Remove(Tween)
            Tween.Group = nil
        end

        Group.Add(Tween)
    end

    Tween.LinkToGroup(CurrentGroup)

    --[[
        GotoTarget: If we should go to the target values once this is called
    ]]
    function Tween.Stop(GotoTarget)
        if GotoTarget then Tween.Set(1) end

        Tween.Playing = false
    end

    function Tween.Set(Alpha)
        for Name, Value in pairs(Target) do
            local SubjectVal = InitalValues[Name]
            local TargetValue = 0

            if type(SubjectVal) == "table" and SubjectVal.Lerp then
                TargetValue = SubjectVal:Lerp(Value, Alpha)
            elseif type(SubjectVal) == "number" then
                TargetValue = math.lerp(SubjectVal, Value, Alpha)
            end

            Runtime.Things.SetProperty(Subject, Name, TargetValue)
        end
    end

    function Tween.Update(dt)
        Tween.Elapsed =  Tween.Elapsed + dt

        if (not Tween.Playing) then return end

        local Elapsed = Tween.Elapsed

        if Elapsed/Time >= 1 then
            Tween.Completed.Invoke() 
            Tween.Stop(true) 
            return
        end

        local LerpedAlpha = EasingFunction(Elapsed, 0, 1, Time)
        Tween.Set(LerpedAlpha)
    end

    return Tween
end

function TweenService.CreateAndPlay(Subject, Target, Style, Time, Wow)
    local Tween = TweenService.Create(Subject, Target, Style, Time).Play()
    if not Time then print("Not given Time! Please try again!") return end
    Scheduler.Yield(Time)

    return Tween
end

-- Internal function to step util tweens
function TweenService.Update(dt)
    CurrentGroup.Update(dt)
end

return TweenService