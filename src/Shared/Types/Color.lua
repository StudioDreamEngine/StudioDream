local Color = {}

function Color.new(R,G,B)
    local Object = {}

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