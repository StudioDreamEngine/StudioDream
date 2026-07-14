---@diagnostic disable: undefined-global
-- For now, there might be some shinanigans we can do with like .Cross() but idk
local InverseLookup = {
    [Vector3.xAxis] = {
        "Y",
        "Z"
    },
    [Vector3.yAxis] = {
        "X",
        "Z"
    },
    [Vector3.zAxis] = {
        "Y",
        "X"
    }
}

function InputService.InputChanged()
    local UUID = CreateUUID()
    local SignalCool = Signal:New("SignalDefaultWowz")
    InputService.EventsConnected.Changed[UUID] = SignalCool
    return SignalCool
end

--[[function InputService.JoystickConnect(ContollerID)
    local InputServiceed = {}

    local joysticks = love.joystick.getJoysticks()
    local js = joysticks[ContollerID]

    function InputServiceed:HasController()
        if not js and not #joysticks>1 then
            return false
        else
            return true
        end
    end

    function InputServiceed:GetControllerName()
        js:getName()
    end

    function InputServiceed:GetJoyAxis(JoyId)
        if JoyId == 1 then
            return Vector2.new(js:getAxis(1),js:getAxis(2))
        elseif JoyId == 2 then
            return Vector2.new(js:getAxis(3),js:getAxis(4))
        end
    end

    return InputServiceed
end]]

--[[
    Takes a ray direction and checks where that ray intersects on a 2d plane

    PlaneAxis will be be direction that the plane doesnt extend in, if you want a plane across the x and y, then the PlaneAxis is (0,0,1)
    We could probably do some shitty vector rotation stuff in the future for diagonal planes, but for now, just planes that are aligned to an axis please!

    The idea is simillar to how it'd be done on a 2d plane
    where we use ``y = mx + b`` in order to check at which ``y`` that ``x`` will intersect
    ``x`` in this case will be where the Plane is relative to the RayOrigin

    I'm so thankful I paid attention in math class - Bloctans
]]
function Camera:RayDirectionToPlane(PlaneOrigin, PlaneAxis, RayDirection)
    local RayOrigin = self.Position -- RayOrigin is always assumed to be where the camera is for now
    local LocalPlaneOrigin = (PlaneOrigin - RayOrigin).Abs()
    local PlaneIntersect = (LocalPlaneOrigin * PlaneAxis).Axis()

    --[[
        We will always be ignoring one axis when handling this, so thats nice

        Example Equation (Z Axis):
            Y = Direction.Y * PlaneIntersect
            X = Direction.X * PlaneIntersect
    ]]
    
    local ToPlane = Vector3.zero
    local AxisAxises

    -- Cuz we cant just directly index another vector rn
    for Axises, Value in pairs(InverseLookup) do
        if Axises:Is(PlaneAxis) then
            AxisAxises = Value
        end
    end
    
    --[[
        It works, but now we gotta account more properly for perspective
    ]]

    for _, Axis in pairs(AxisAxises) do
        local Result = Vector3[string.lower(Axis).."Axis"] * (RayDirection[Axis] * PlaneIntersect)

        ToPlane = ToPlane + Result
    end

    return ToPlane/self:GetFocalLength()
end