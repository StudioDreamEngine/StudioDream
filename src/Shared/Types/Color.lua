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

function Color.FromRGB(R,G,B)
    return Color.new(R/255, G/255, B/255)
end

function Color.FromHex(Hex)
    if string.sub(Hex, 1,1) == "#" then
        Hex = string.sub(Hex, 2,-1)
    end

    local R = tonumber(string.sub(Hex,1,2), 16)
    local G = tonumber(string.sub(Hex,3,4), 16)
    local B = tonumber(string.sub(Hex,5,6), 16)

    return Color.FromRGB(R,G,B)
end

return Color