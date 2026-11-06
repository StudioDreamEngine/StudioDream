---@class Corners
local Methods = {
    Type = "Corners"
}

local Meta = {
    __index = Methods,
    __mul = function (t1, t2)
        if type(t2) == "number" then
            return Corners.new(t1.TL * t2, t1.TR * t2, t1.BL * t2, t1.BR * t2)
        end
    end,
}

local Corners = {}

function Corners.new(TL, TR, BL, BR)
    if (not TR) then
        TR, BL, BR = TL, TL, TL
    end

    ---@class Corners
    local Object = setmetatable({
        TL = TL or 0,
        TR = TR or 0,
        BL = BL or 0,
        BR = BR or 0,
    }, Meta)

    return Object
end

return Corners