-- Clonable constants for vector2
local Constant = {
    xAxis = {1,0},
    yAxis = {0,1},
    zero = {0,0},
    one = {1,1}
}

---@class Vector2
local Methods = {
    Type = "Vector2"
}

function Methods:Lerp(SecondVector, Alpha)
    return Vector2.new(math.lerp(self.X, SecondVector.X, Alpha),math.lerp(self.Y, SecondVector.Y, Alpha))
end

function Methods:Copy()
    return Vector2.new(self.X,self.Y)
end

function Methods:Dot(SecondVector)
    return (self.X * SecondVector.X) + (self.Y * SecondVector.Y)
end

-- Return the simple version of the vector2, Useful for serialization
function Methods:Simple()
    return {
        X = self.X, 
        Y = self.Y,
        Type = "SimpleVector2",
        Simple = true
    }
end

-- for some reason __eq isnt working
function Methods:Is(SecondVector)
    return (self.X == SecondVector.X) and (self.Y == SecondVector.Y)
end

function Methods:Magnitude()
    return math.sqrt(self.X*self.X + self.Y*self.Y)
end

function Methods:Unit()
    return Vector2.new(self.X/Methods:Magnitude(),self.Y/Methods:Magnitude())
end

-- Return the sum of all axises, useful for getting the value of one axis if all other axises should be zero
function Methods:Axis()
    return (self.X + self.Y)
end

function Methods:Round()
    return Vector2.new(math.round(self.X),math.round(self.Y))
end

function Methods:Abs()
    return Vector2.new(math.abs(self.X),math.abs(self.Y))
end
Profiler.Start("Vector2 - Meta Creation")
local Meta = { -- I have no idea how to organize this mess
    __index = Methods,
    __unm = function (t)
        return Vector2.new(-t.X,-t.Y)
    end,
    -- TODO: Remove?
    __eq = function (t1, t2)
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
        t2 = t2 or 1

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
}
Profiler.End()

Profiler.Start("Vector2 - Vector2 Metatable")
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
Profiler.End()

function Vector2.FromSimple(Simple)
    if Simple.Simple then
        return Vector2.new(Simple.X, Simple.Y)
    else
        return Simple
    end
end

function Vector2.FromString(String)
    local ToFilter = string.gsub(String,"%s","") -- Strip Whitespace
    local SplitText = string.split(ToFilter,",") -- Split by ,

    -- Theres 100% a better way to do this
    return Vector2.new(tonumber(SplitText[1]) or 0, tonumber(SplitText[2]) or 0)
end

---@return Vector2
function Vector2.new(x,y)
    Profiler.Start("Vector2 - Creation")
    if (not y) then
        local ExistingVector = x

        if ExistingVector.Simple then
            return Vector2.new(ExistingVector.X, ExistingVector.Y)
        else
            return ExistingVector
        end
    end

    local MetaTableWow = setmetatable({
        X = x,
        Y = y,
    }, Meta)

    Profiler.End()

    return MetaTableWow
end

return Vector2