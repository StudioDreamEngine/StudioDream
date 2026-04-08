local Color = {}

function Color.new(R,G,B)
    local Object = setmetatable({
        R = 1,
        G = 1,
        B = 1,
        Type = "Color"
    }, {
        __mul = function (t1, t2)
            -- is there a better way to do this
            if type(t1) == "number" then
                return Color.new(t2.R * t1, t2.G * t1, t2.B * t1)
            elseif type(t2) == "number" then
                return Color.new(t1.R * t2, t1.G * t2, t1.B * t2)
            else
                return Color.new(t1.R * t2.R, t1.G * t2.G, t1.B * t2.B)
            end
        end
    })

    if not (G or B) then
        Object.R = R
        Object.G = R
        Object.B = R
    else
        Object.R = R
        Object.G = G
        Object.B = B
    end

    return Object
end

return Color