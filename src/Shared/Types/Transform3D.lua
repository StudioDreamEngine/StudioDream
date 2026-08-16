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

    function Object:Copy()
        return Transform3D.FromMatrix(Object.GetMatrix())
    end

    function Object:Lerp(OtherTransform, Alpha)
        local Matrix1 = Matrix ---@class DreamMat4
        local Matrix2 = OtherTransform.GetMatrix() ---@class DreamMat4

        return Transform3D.FromMatrix(Matrix1 + (Matrix2 - Matrix1) * Alpha)
    end

    return setmetatable(Object, {
        __mul = function (t1, t2)
            if t1.Type == "Transform3D" and t2.Type == "Transform3D" then
                return NewTransform(t1.GetMatrix() * t2.GetMatrix())
            else
                assert("Transform3D expected, got ("..Utils.TypeOf(t2)..")")
            end
        end,
        __tostring = function(self)
            return "{"..tostring(self.Position).."} , {"..tostring(self.AsAngle():Deg()).."}" -- bullshit
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

function Transform3D.FromString(Text)
    local RemoveWhiteSpace = string.gsub(Text,"%s","") -- Strip Whitespace
    local FindBrack = string.gmatch(RemoveWhiteSpace,"{[%d,%-]+}")
    local DefaultNumber = 0
    local StringsCreated = {}

    for String in FindBrack do
        local RemoveKeys = string.gsub(String,"[%{%}]","")
        table.insert(StringsCreated,RemoveKeys)
    end

    local FinalString

    if #StringsCreated > 0 then
        print(Text)
        print(RemoveWhiteSpace)
        print(StringsCreated[1],StringsCreated[2])
        FinalString = (StringsCreated[1] or "0,0,0")..","..(StringsCreated[2] or "0,0,0")
    else
        FinalString = Text
    end

    local SplitText = string.split(FinalString,"[%, %s]")
    local ToRad = Vector3.new((tonumber(SplitText[4]) or DefaultNumber),(tonumber(SplitText[5]) or DefaultNumber),(tonumber(SplitText[6]) or DefaultNumber)):Rad()
    return Transform3D.FromPosition((tonumber(SplitText[1]) or DefaultNumber),(tonumber(SplitText[2]) or DefaultNumber),(tonumber(SplitText[3]) or DefaultNumber))*Transform3D.FromAngle(ToRad.X,ToRad.Y,ToRad.Z)
end

return Transform3D