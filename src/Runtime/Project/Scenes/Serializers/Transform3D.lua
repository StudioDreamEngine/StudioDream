local Serializer = {}

function Serializer.Serialize(Value)
    local Matrix = Value:GetMatrix()
    return NAML.SerializeList(Matrix)
end

function Serializer.Deserialize(Value)
    Value = NAML.DeserializeList(Value)
    if Value.X then
        local Rotationed = Vector3.new(Value.XR,Value.YR,Value.ZR):Rad()
        return Transform3D.FromPosition(Value.X, Value.Y, Value.Z)*Transform3D.FromAngle(Rotationed)
    else
        return Transform3D.FromMatrix(Dream.mat4(Value))
    end
end

return Serializer