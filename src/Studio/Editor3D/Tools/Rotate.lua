local Rotate = {}
local Things = Runtime.Things

local RotateControl ---@class RotateControl

local Info = {
    ["StartRotObj"] = Vector3.zero,
    ["OffsetTo"] = Vector3.zero,
}

Rotate.IsRotate = true

local function StartDrag(Obj)
    Info.StartPosObj = Obj.Transform.Rotation
end

local function EndDrag()
    Info.StartPosObj = Vector3.zero
    Info.OffsetTo = Vector3.zero
end

function Rotate.Init()
    RotateControl = Things.Create("RotateControl") {
        Parent = Things.Root.RootViewport,
    }

    RotateControl.Adornee = Rotate.Selection

    RotateControl.ControlChanged:Connect(function(Axis, Rotation)
        Rotate.ChangeTransform(Transform3D.FromAngle(Rotation * Axis))
    end)

    RotateControl.StartControl:Connect(function()
        ToolManager.SetupSelection()
        StartDrag(Rotate.Selection)
    end)

    RotateControl.EndControl:Connect(function()
        Rotate.RegisterUndo()
        EndDrag()
    end)
end

function Rotate.Update()
    
end

function Rotate.Destroy()
    Things.Remove(RotateControl)
end

return Rotate