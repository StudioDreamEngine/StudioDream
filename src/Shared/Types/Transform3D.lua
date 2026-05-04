return { new = function()
    local Transform3D = {}

    local Matrix = Dream.mat4({
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    })
    Transform3D.Position = Vector3.zero

    function Transform3D.GetForward()
        return Vector3.new(Matrix[3], Matrix[7], Matrix[11])
    end

    function Transform3D.SetPosition(Position)
        Matrix[4] = Position.X
        Matrix[8] = Position.Y
        Matrix[12] = Position.Z
    end

    function Transform3D.GetTransform()
        return Matrix
    end

    function Transform3D.UpdateValues()
        Transform3D.Position = Vector3.new(Matrix[4], Matrix[8], Matrix[12])

        Transform3D.Forward = Transform3D.GetForward()
        --Transform3D.Side
        Transform3D.Up = Vector3.yAxis -- For now :trol:
    end

    return Transform3D
end }