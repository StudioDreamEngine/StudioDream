local Transform3D = {}

local Methods = {
    Type = "Transform3D"
}

function Methods:GetMatrix()
    return self.Matrix
end

function Methods:AsAngle()
    return Vector3.FromDream(self.Matrix:toEuler())
end

function Methods:Copy()
    return Transform3D.FromMatrix(self.Matrix)
end

function Methods:GetBasis()
    return Transform3D.FromMatrix(self.Basis)
end

function Methods:GetOrigin()
    return Transform3D.FromMatrix(self.Origin)
end

function Methods:Lerp(OtherTransform, Alpha)
    local Matrix1 = self.Matrix ---@class DreamMat4
    local Matrix2 = OtherTransform:GetMatrix() ---@class DreamMat4

    return Transform3D.FromMatrix(Matrix1 + (Matrix2 - Matrix1) * Alpha)
end

local Meta = {
    __index = Methods,
    __mul = function (t1, t2)
        if t1.Type == "Transform3D" and t2.Type == "Transform3D" then
            return Transform3D.FromMatrix(t1:GetMatrix() * t2:GetMatrix())
        else
            assert("Transform3D expected, got ("..Utils.TypeOf(t2)..")")
        end
    end,
    __add = function (t1, t2)
        if t1.Type == "Transform3D" and t2.Type == "Vector3" then
            return Transform3D.FromMatrix(t1:GetMatrix() + Dream.mat4(
                0, 0, 0, t2.X,
                0, 0, 0, t2.Y,
                0, 0, 0, t2.Z,
                0, 0, 0, 0
            ))
        else
            assert("Transform3D expected, got ("..Utils.TypeOf(t2)..")")
        end
    end,
    __tostring = function(self)
        local Degree = self:AsAngle():Deg()
        return "{"..tostring(Vector3.new(self.Position.X,self.Position.Y,self.Position.Z)).."} , {"..tostring(Vector3.new(Degree.X,Degree.Y,Degree.Z)).."}" -- bullshit
    end
}

---@param Matrix DreamMat4
function Transform3D.FromMatrix(Matrix)
    ---@class Transform3D
    local Object = {
        Matrix = Matrix,

        -- Matricies
        Basis = Dream.mat4(
            Matrix[1], Matrix[2], Matrix[3], 0,
            Matrix[5], Matrix[6], Matrix[7], 0,
            Matrix[9], Matrix[10], Matrix[11], 0,
            0, 0, 0, 1
        ),
        Origin = Dream.mat4(
            1, 0, 0, Matrix[4],
            0, 1, 0, Matrix[8],
            0, 0, 1, Matrix[12],
            0, 0, 0, 1
        ),

        -- Vectors
        Side = Vector3.new(Matrix[1], Matrix[5], Matrix[9]),
        Up = Vector3.new(Matrix[2], Matrix[6], Matrix[10]),
        Forward = Vector3.new(Matrix[3], Matrix[7], Matrix[11]),
        Position = Vector3.new(Matrix[4], Matrix[8], Matrix[12])
    }
    
    return setmetatable(Object, Meta)
end

function Transform3D.LookTowards(Eye, direction)
    direction = direction:ToDream()

    local up = Dream.vec3(0.0, 1.0, 0.0)

	local zaxis = direction:normalize()
	local xaxis = zaxis:cross(up):normalize()

	-- "It just works!" - Todd Howard
	if xaxis:length() == 0 then xaxis = Dream.vec3(1,0,0) end

	local yaxis = xaxis:cross(zaxis):normalize()
	
	local rotate = Dream.mat4({
		xaxis.x, yaxis.x, -zaxis.x, 0.0,
		xaxis.y, yaxis.y, -zaxis.y, 0.0,
		xaxis.z, yaxis.z, -zaxis.z, 0.0,
		0, 0, 0, 1
	})
    return Transform3D.FromPosition(Eye) * Transform3D.FromMatrix(rotate)
end

function Transform3D.LookAt(Eye, Target)
    return Transform3D.LookTowards(Eye, (Target - Eye):Unit())
end

function Transform3D.FromAngle(X,Y,Z)
    if (not Y) then
        local Pos = X
        X,Y,Z = Pos.X, Pos.Y, Pos.Z
    end

    local Matrix = Dream.mat4.getIdentity()
    if X ~= 0 then Matrix = Matrix:rotateX(X) end
    if Y ~= 0 then Matrix = Matrix:rotateY(Y) end
    if Z ~= 0 then Matrix = Matrix:rotateZ(Z) end
    
    return Transform3D.FromMatrix(Matrix)
end

function Transform3D.FromPosition(X,Y,Z)
    if (not Y) then
        local Pos = X
        X,Y,Z = Pos.X, Pos.Y, Pos.Z
    end

    local Matrix = Dream.mat4.getIdentity()
    Matrix = Matrix:translate(X,Y,Z)

    return Transform3D.FromMatrix(Matrix)
end

function Transform3D.FromString(Text) -- also need to figure out a good way to improve this
    local RemoveWhiteSpace = string.gsub(Text,"%s","") -- Strip Whitespace
    local FindBrack = string.closeSimple(RemoveWhiteSpace,"{","}")
    local DefaultNumber = 0
    local StringsCreated = {}

    for _,String in pairs(FindBrack) do
        local RemoveKeys = string.gsub(String,"[%{%}]","")
        table.insert(StringsCreated,RemoveKeys)
    end

    local FinalString

    if #StringsCreated > 0 then
        FinalString = (StringsCreated[1] or "0,0,0")..","..(StringsCreated[2] or "0,0,0")
    else
        FinalString = Text
    end

    local SplitText = string.split(FinalString,"[%, %s]")
    local ToRad = Vector3.new((tonumber(SplitText[4]) or DefaultNumber),(tonumber(SplitText[5]) or DefaultNumber),(tonumber(SplitText[6]) or DefaultNumber)):Rad()
    return Transform3D.FromPosition((tonumber(SplitText[1]) or DefaultNumber),(tonumber(SplitText[2]) or DefaultNumber),(tonumber(SplitText[3]) or DefaultNumber))*Transform3D.FromAngle(ToRad.X,ToRad.Y,ToRad.Z)
end

return Transform3D