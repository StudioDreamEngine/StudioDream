local Serializer = {}

function Serializer.Serialize(Value)
    local Position = Value.Position
    local Rotation = Value:AsAngle():Deg()
    return NAML.SerializeList({
        X = Position.X,
        Y = Position.Y,
        Z = Position.Z,

        XR = Rotation.X,
        YR = Rotation.Y,
        ZR = Rotation.Z,
    })
end

function Serializer.Deserialize(Value)
    Value = NAML.DeserializeList(Value)
    local Rotationed = Vector3.new(Value.XR,Value.YR,Value.ZR):Rad()
    return Transform3D.FromPosition(Value.X, Value.Y, Value.Z)*Transform3D.FromAngle(Rotationed)
end

return Serializer