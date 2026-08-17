-- Clonable constants for vector2
local Constant = {
    xAxis = {1,0,0},
    yAxis = {0,1,0},
    zAxis = {0,0,1},
    plane = {1,0,1},
    zero = {0,0,0},
    one = {1,1,1}
}

local Vector3 = setmetatable({}, {
    __index = function (t, k)
        local PossibleConstant = Constant[k]

        if PossibleConstant then
            return Vector3.new(PossibleConstant[1], PossibleConstant[2], PossibleConstant[3])
        else
            return rawget(t,k)
        end
    end
})

local Methods = {
    Type = "Vector3"
}

function Methods:Copy()
    return Vector3.new(self.X,self.Y,self.Z)
end

function Methods:Lerp(SecondVector, Alpha)
    return Vector3.new(math.lerp(self.X, SecondVector.X, Alpha),math.lerp(self.Y, SecondVector.Y, Alpha),math.lerp(self.Z, SecondVector.Z, Alpha))
end

function Methods:ToDream()
    return Dream.vec3(self.X, self.Y, self.Z)
end

function Methods:ToBullet()
    return Bullet.btVector3(self.X, self.Y, self.Z)
end

function Methods:Merge(OtherVector)
    local NewVector = Methods:Copy()

    if OtherVector.X > self.X then NewVector.X = OtherVector.X end
    if OtherVector.Y > self.Y then NewVector.Y = OtherVector.Y end
    if OtherVector.Z > self.Z then NewVector.Z = OtherVector.Z end

    return NewVector
end

function Methods:Unit()
    local Unit = Vector3.new(self.X/self:Magnitude(),self.Y/self:Magnitude(),self.Z/self:Magnitude())

    return (self:Magnitude() > 0) and Unit or Vector3.zero
end

function Methods:Cross(SecondVector)
    return Vector3.new(self.Y * SecondVector.Z - self.Z * SecondVector.Y, self.Z * SecondVector.X - self.X * SecondVector.Z, self.X * SecondVector.Y - self.Y * SecondVector.X)
end

function Methods:Dot(SecondVector)
    return (self.X * SecondVector.X) + (self.Y * SecondVector.Y) + (self.Z * SecondVector.Z)
end

-- Return the simple version of the vector2, Useful for serialization
function Methods:Simple()
    return {
        X = self.X, 
        Y = self.Y,
        Z = self.Z,
        Simple = true
    }
end

function Methods:Deg()
    return Vector3.new(math.deg(self.X),math.deg(self.Y),math.deg(self.Z))
end

function Methods:Rad()
    return Vector3.new(math.rad(self.X),math.rad(self.Y),math.rad(self.Z))
end

-- for some reason __eq isnt working
function Methods:Is(SecondVector)
    return (self.X == SecondVector.X) and (self.Y == SecondVector.Y) and (self.Z == SecondVector.Z)
end

function Methods:Magnitude()
    return (self.X*self.X + self.Y*self.Y + self.Z*self.Z) ^ 1/3
end

-- Return the sum of all axises, useful for getting the value of one axis if all other axises should be zero
function Methods:Axis()
    return (self.X + self.Y + self.Z)
end

function Methods:Round()
    return Vector3.new(math.round(self.X),math.round(self.Y),math.round(self.Z))
end

function Methods:Abs()
    return Vector3.new(math.abs(self.X),math.abs(self.Y),math.abs(self.Z))
end

local Meta = { -- I have no idea how to organize this mess
    __index = Methods,
    __unm = function (t)
        return Vector3.new(-t.X,-t.Y,-t.Z)
    end,
    __add = function (t1, t2)
        if type(t1) == "number" then
            return Vector3.new(t1 + t2.X, t1 + t2.Y, t1 + t2.Z, t2.W)
        elseif type(t2) == "number" then
            return Vector3.new(t1.X + t2, t1.Y + t2, t1.Z + t2, t1.W)
        else
            return Vector3.new(t1.X + t2.X, t1.Y + t2.Y, t1.Z + t2.Z, t1.W)
        end
    end,
    __sub = function (t1, t2)
        if type(t2) == "number" then
            return Vector3.new(t1.X - t2, t1.Y - t2, t1.Z - t2, t2.W)
        else
            return Vector3.new(t1.X - t2.X, t1.Y - t2.Y, t1.Z - t2.Z, t1.W)
        end
    end,
    __tostring = function (t)
        return math.dotround(t.X)..", "..math.dotround(t.Y)..", "..math.dotround(t.Z)
    end,
    __mul = function (t1, t2)
        if type(t2) == "number" then
            return Vector3.new(t1.X * t2, t1.Y * t2, t1.Z * t2, t1.W)
        elseif type(t1) == "number" then
            return Vector3.new(t2.X * t1, t2.Y * t1, t2.Z * t1, t2.W)
        else
            return Vector3.new(t1.X * t2.X, t1.Y * t2.Y, t1.Z * t2.Z, t1.W)
        end
    end,
    __div = function (t1, t2)
        if type(t2) == "number" then
            return Vector3.new(t1.X / t2, t1.Y / t2, t1.Z / t2)
        elseif type(t1) == "number" then
            return Vector3.new(t2.X / t1, t2.Y / t1, t2.Z / t1)
        else
            return Vector3.new(t1.X / t2.X, t1.Y / t2.Y, t1.Z / t2.Z)
        end
    end
}

---@param Vector DreamVec3
function Vector3.FromDream(Vector)
    return Vector3.new(Vector.x, Vector.y, Vector.z)
end

function Vector3.FromBullet(Vector)
    return Vector3.new(Vector:x(), Vector:y(), Vector:z())
end

function Vector3.FromString(String)
    local ToFilter = string.gsub(String,"%s","") -- Strip Whitespace
    local SplitText = string.split(ToFilter,",") -- Split by ,

    -- Theres 100% a better way to do this
    return Vector3.new(tonumber(SplitText[1]) or 0, tonumber(SplitText[2]) or 0, tonumber(SplitText[3]) or 0)
end

function Vector3.GetHigherAxis(Vector)
   return math.max(Vector.X,Vector.Y,Vector.Z)
end

function Vector3.new(x,y,z,w)
    ---@class Vector3
    local Object = setmetatable({
        X = x or 0,
        Y = y or 0,
        Z = z or 0,
        W = w or 1, -- Optional distance component, any operator (aside from multiplication) will remove the w component as of currently
    }, Meta)

    return Object
end

return Vector3