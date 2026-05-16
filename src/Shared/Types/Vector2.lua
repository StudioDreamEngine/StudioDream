-- Clonable constants for vector2
local Constant = {
    xAxis = {1,0},
    yAxis = {0,1},
    zero = {0,0},
    one = {1,1}
}

local Vector2 = setmetatable({}, {
    __index = function (t, k)
        local PossibleConstant = Constant[k]

        if PossibleConstant then
            return Vector2.new(PossibleConstant[1], PossibleConstant[2])
        else
            return rawget(t,k)
        end
    end
})

function Vector2.FromSimple(Simple)
    if Simple.Simple then
        return Vector2.new(Simple.X, Simple.Y)
    else
        return Simple
    end
end

function Vector2.new(x,y)
    if (not y) then
        local ExistingVector = x

        if ExistingVector.Simple then
            return Vector2.new(ExistingVector.X, ExistingVector.Y)
        else
            return ExistingVector
        end
    end

    ---@class Vector2
    local Object = setmetatable({
        X = x,
        Y = y,
        Type = "Vector2"
    }, { -- I have no idea how to organize this mess
        __unm = function (t)
            return Vector2.new(-t.X,-t.Y)
        end,
        __eq = function (t1, t2)
            print(t1, t2)
            return (t1.X == t2.X) and (t1.Y == t2.Y)
        end,
        __add = function (t1, t2)
            if type(t1) == "number" then
                return Vector2.new(t1 + t2.X, t1 + t2.Y)
            elseif type(t2) == "number" then
                return Vector2.new(t1.X + t2, t1.Y + t2)
            else
                return Vector2.new(t1.X + t2.X, t1.Y + t2.Y)
            end
        end,
        __sub = function (t1, t2)
            if type(t2) == "number" then
                return Vector2.new(t1.X - t2, t1.Y - t2)
            elseif type(t1) == "number" then
                return Vector2.new(t1 - t2.X, t1 - t2.Y)
            else
                return Vector2.new(t1.X - t2.X, t1.Y - t2.Y)
            end
        end,
        __tostring = function (t)
            return t.X..", "..t.Y
        end,
        __mul = function (t1, t2)
            if type(t2) == "number" then
                return Vector2.new(t1.X * t2, t1.Y * t2)
            elseif type(t1) == "number" then
                return Vector2.new(t2.X * t1, t2.Y * t1)
            else
                return Vector2.new(t1.X * t2.X, t1.Y * t2.Y)
            end
        end,
        __div = function (t1, t2)
            if type(t2) == "number" then
                return Vector2.new(t1.X / t2, t1.Y / t2)
            else
                return Vector2.new(t1.X / t2.X, t1.Y / t2.Y)
            end
        end
    })

    function Object.Lerp(SecondVector, Alpha)
        return Vector2.new(math.lerp(Object.X, SecondVector.X, Alpha),math.lerp(Object.Y, SecondVector.Y, Alpha))
    end
    
    function Object.Copy()
        return Vector2.new(Object.X,Object.Y)
    end

    function Object.Dot(SecondVector)
        return (Object.X * SecondVector.X) + (Object.Y * SecondVector.Y)
    end

    -- Return the simple version of the vector2, Useful for serialization
    function Object.Simple()
        return {
            X = Object.X, 
            Y = Object.Y,
            Type = "SimpleVector2",
            Simple = true
        }
    end

    -- for some reason __eq isnt working
    function Object.Is(SecondVector)
        return (Object.X == SecondVector.X) and (Object.Y == SecondVector.Y)
    end

    function Object.Magnitude()
        return math.sqrt(Object.X*Object.X + Object.Y*Object.Y)
    end

    function Object.Unit()
        return Vector2.new(Object.X/Object.Magnitude(),Object.Y/Object.Magnitude())
    end

    function Object.Round()
        return Vector2.new(math.round(Object.X),math.round(Object.Y))
    end

    function Object.Abs()
        return Vector2.new(math.abs(Object.X),math.abs(Object.Y))
    end

    return Object
end

return Vector2