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

function Vector3.new(x,y,z,w)
    ---@class Vector3
    local Object = setmetatable({
        X = x,
        Y = y,
        Z = z,
        W = w or 1, -- Optional distance component, any operator (aside from multiplication) will remove the w component as of currently
        Type = "Vector3"
    }, { -- I have no idea how to organize this mess
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
            return t.X..", "..t.Y..", "..t.Z
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
    })

    function Object.Copy()
        return Vector3.new(Object.X,Object.Y,Object.Z)
    end

    function Object.Lerp(SecondVector, Alpha)
        return Vector3.new(math.lerp(Object.X, SecondVector.X, Alpha),math.lerp(Object.Y, SecondVector.Y, Alpha),math.lerp(Object.Z, SecondVector.Z, Alpha))
    end

    function Object.ToDream()
        return Dream.vec3(Object.X, Object.Y, Object.Z)
    end

    function Object.ToBullet()
        return Bullet.btVector3(Object.X, Object.Y, Object.Z)
    end

    function Object.Merge(OtherVector)
        local NewVector = Object.Copy()

        if OtherVector.X > Object.X then NewVector.X = OtherVector.X end
        if OtherVector.Y > Object.Y then NewVector.Y = OtherVector.Y end
        if OtherVector.Z > Object.Z then NewVector.Z = OtherVector.Z end

        return NewVector
    end

    function Object.Unit()
        local Unit = Vector3.new(Object.X/Object.Magnitude(),Object.Y/Object.Magnitude(),Object.Z/Object.Magnitude())

        return (Object.Magnitude() > 0) and Unit or Vector3.zero
    end

    function Object.Cross(SecondVector)
        return Vector3.new(Object.Y * SecondVector.Z - Object.Z * SecondVector.Y, Object.Z * SecondVector.X - Object.X * SecondVector.Z, Object.X * SecondVector.Y - Object.Y * SecondVector.X)
    end

    function Object.Dot(SecondVector)
        return (Object.X * SecondVector.X) + (Object.Y * SecondVector.Y) + (Object.Z * SecondVector.Z)
    end

    -- Return the simple version of the vector2, Useful for serialization
    function Object.Simple()
        return {
            X = Object.X, 
            Y = Object.Y,
            Z = Object.Z,
            Simple = true
        }
    end

    function Object.Deg()
        return Vector3.new(math.deg(Object.X),math.deg(Object.Y),math.deg(Object.Z))
    end

    function Object.Rad()
        return Vector3.new(math.rad(Object.X),math.rad(Object.Y),math.rad(Object.Z))
    end

    -- for some reason __eq isnt working
    function Object.Is(SecondVector)
        return (Object.X == SecondVector.X) and (Object.Y == SecondVector.Y) and (Object.Z == SecondVector.Z)
    end

    function Object.Magnitude()
        return (Object.X*Object.X + Object.Y*Object.Y + Object.Z*Object.Z) ^ 1/3
    end

    -- Return the sum of all axises, useful for getting the value of one axis if all other axises should be zero
    function Object.Axis()
        return (Object.X + Object.Y + Object.Z)
    end
    
    function Object.Round()
        return Vector3.new(math.round(Object.X),math.round(Object.Y),math.round(Object.Z))
    end

    function Object.Abs()
        return Vector3.new(math.abs(Object.X),math.abs(Object.Y),math.abs(Object.Z))
    end

    return Object
end

return Vector3