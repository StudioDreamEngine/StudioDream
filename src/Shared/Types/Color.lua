local Color = {}

function Color.new(R,G,B,A)
    ---@class Color
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
            return math.dotround(t.R)..", "..math.dotround(t.G)..", "..math.dotround(t.B)..", "..math.dotround(t.A)
        end
    })

    Utils.AssertTypes({R,G,B},"number")

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

    function Object.ToDream()
        return Dream.vec3(Object.R,Object.G,Object.B)
    end
    
    function Object.ToRGB()
        return {R=Object.R*255,G=Object.G*255,B=Object.B*255}
    end

    function Object.ToHVS() -- from https://github.com/iskolbin/lhsx/blob/master/hsx.lua !
        local M, m = math.max( Object.R, Object.G, Object.B ), math.min( Object.R, Object.G, Object.B )
	    local C = M - m
	    local K = 1.0/(6.0 * C)
	    local h = 0.0
	    if C ~= 0.0 then
		    if M == Object.R then 
                h = ((Object.G - Object.B) * K) % 1.0
		    elseif M == Object.G then 
                h = (Object.B - Object.R) * K + 1.0/3.0
		    else 
                h = (Object.R - Object.G) * K + 2.0/3.0
		    end
	    end
	    return {H = h,S = M == 0.0 and 0.0 or C / M,V = M}
    end

    function Object.ToHex() -- from https://gist.github.com/marceloCodget/3862929
        local TableToLoop = {Object.R*255, Object.G*255, Object.B*255}
        local hexadecimal = '#'

	    for key, value in pairs(TableToLoop) do
		    local hex = ''

		    while(value > 0)do
			    local index = math.fmod(value, 16) + 1
			    value = math.floor(value / 16)
			    hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		    end

		    if(string.len(hex) == 0)then
			    hex = '00'

		    elseif(string.len(hex) == 1)then
			    hex = '0' .. hex
		    end

		    hexadecimal = hexadecimal .. hex
	    end

	    return hexadecimal
    end

    function Object.Invert()
        return Color.new(1-Object.R,1-Object.B,1-Object.G,1-Object.A)
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

function Color.HVSFromString(String)
    local ToFilter = string.gsub(String,"%s","") -- Strip Whitespace
    local SplitText = string.split(ToFilter,",") -- Split by ,
    --local SplitText = string.split(SplitText1,"{") -- Split by {

    -- Theres 100% a better way to do this
    --print(SplitText)
    return {H = tonumber(SplitText[1]) or 1,S = tonumber(SplitText[2]) or 1,V = tonumber(SplitText[3]) or 1}
end

function Color.RGBFromString(String)
    local ToFilter = string.gsub(String,"%s","")
    local SplitText = string.split(ToFilter,",")
    return tonumber(SplitText[1]) or 1, tonumber(SplitText[2]) or 1, tonumber(SplitText[3]) or 1
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

function Color.FromHSV(h, s, v)
    if s <= 0 then return Color.new(v,v,v) end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return Color.new(r+m, g+m, b+m)
end

function Color.Invert(ColorToInvert)
   assert("Deprecated, Try using .Invert from a color object!")
end

return Color