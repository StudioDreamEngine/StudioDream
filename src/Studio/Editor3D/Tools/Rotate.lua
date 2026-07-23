local Rotate = {}
local Things = Runtime.Things

local MoveControl ---@class MoveControl

local Info = {
    ["StartRotObj"] = Vector3.zero,
    ["OffsetTo"] = Vector3.zero,
}

local function StartDrag(Obj)
    Info.StartPosObj = Obj.Transform.Rotation
end

local function EndDrag()
    Info.StartPosObj = Vector3.zero
    Info.OffsetTo = Vector3.zero
end

function Rotate.Init()
    MoveControl = Things.Create("RotateControl") {
        Parent = Things.Root.RootViewport,
    }

    MoveControl.Adornee = Rotate.Selection

    MoveControl.OnMove:Connect(function(Plane)
        Info.OffsetTo = Plane

        Rotate.ChangeTransform(Transform3D.FromAngle(Info.StartRotObj.X + Info.OffsetTo.X,Info.StartRotObj.Y + Info.OffsetTo.Y,Info.StartRotObj.Z + Info.OffsetTo.Z))
    end)

    MoveControl.StartMove:Connect(function()
        ToolManager.SetupSelection()
        StartDrag(Rotate.Selection)
    end)

    MoveControl.EndMove:Connect(function()
        Rotate.RegisterUndo()
        EndDrag()
    end)
end

function Rotate.Update()
    
end

function Rotate.Destroy()
    Things.Remove(MoveControl)
end

return Rotate