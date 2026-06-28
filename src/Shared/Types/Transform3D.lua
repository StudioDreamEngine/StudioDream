local Transform3D = {}

---@param Matrix DreamMat4
local function NewTransform(Matrix, Rotated)
    local Object = {}

    Object.Type = "Transform3D"

    Object.Side = Vector3.new(Matrix[1], Matrix[5], Matrix[9])
    Object.Up = Vector3.new(Matrix[2], Matrix[6], Matrix[10]) 
    Object.Forward = Vector3.new(Matrix[3], Matrix[7], Matrix[11])
    Object.Position = Vector3.new(Matrix[4], Matrix[8], Matrix[12])

    -- Extract basis
    if not Rotated then
        Object.Rotation = NewTransform(Dream.mat4(
            Matrix[1], Matrix[2], Matrix[3], 0,
            Matrix[5], Matrix[6], Matrix[7], 0,
            Matrix[9], Matrix[10], Matrix[11], 0,
            0, 0, 0, 1
        ), true) -- I dont like doing this... oh well!
    end

    ---@return DreamMat4
    function Object.GetMatrix() return Matrix end

    function Object.AsAngle()
        return Vector3.FromDream(Matrix:toEuler())
    end

    return setmetatable(Object, {
        __mul = function (t1, t2)
            if t1.Type == "Transform3D" and t2.Type == "Transform3D" then
                return NewTransform(t1.GetMatrix() * t2.GetMatrix())
            end
        end
    })
end

function Transform3D.FromAngle(X,Y,Z)
    if (not Y) then
        local Pos = X
        X,Y,Z = Pos.X, Pos.Y, Pos.Z
    end

    local Matrix = Dream.mat4.getIdentity()
    Matrix = Matrix:rotateX(X)
    Matrix = Matrix:rotateY(Y)
    Matrix = Matrix:rotateZ(Z)
    
    return NewTransform(Matrix)
end

function Transform3D.FromMatrix(Matrix)
    return NewTransform(Matrix)
end

function Transform3D.FromPosition(X,Y,Z)
    if (not Y) then
        local Pos = X
        X,Y,Z = Pos.X, Pos.Y, Pos.Z
    end

    local Matrix = Dream.mat4.getIdentity()
    Matrix = Matrix:translate(X,Y,Z)

    return NewTransform(Matrix)
end

return Transform3D