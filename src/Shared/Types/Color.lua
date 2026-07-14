local Color = {}

function Color.new(R,G,B,A)
    local Object = setmetatable({
        R = 1,
        G = 1,
        B = 1,
        A = 1,
        Type = "Color"
    }, {
        __mul = function (t1, t2)
            -- is there a better way to do this
            if type(t1) == "number" then
                return Color.new(t2.R * t1, t2.G * t1, t2.B * t1, t2.A)
            elseif type(t2) == "number" then
                return Color.new(t1.R * t2, t1.G * t2, t1.B * t2, t1.A)
            else
                return Color.new(t1.R * t2.R, t1.G * t2.G, t1.B * t2.B, t1.A)
            end
        end,

        __tostring = function(t)
            return t.R..", "..t.G..", "..t.B..", "..t.A
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

    if A then
        Object.A = A
    end

    function Object.ToShader()
        return {Object.R, Object.G, Object.B, Object.A}
    end

    return Object
end

function Color.FromString(String)
    local ToFilter = string.gsub(String,"%s","") -- Strip Whitespace
    local SplitText = string.split(ToFilter,",") -- Split by ,
    --local SplitText = string.split(SplitText1,"{") -- Split by {

    -- Theres 100% a better way to do this
    --print(SplitText)
    return Color.new(tonumber(SplitText[1]) or 1, tonumber(SplitText[2]) or 1, tonumber(SplitText[3]) or 1,tonumber(SplitText[4]) or 1)
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