local Move = {}
local Things = Runtime.Things

local MoveControl ---@class MoveControl

local Info = {
    StartPosObj = Vector3.zero,
    OffsetTo = Vector3.zero,
}

local function StartDrag(Obj)
    Info.StartPosObj = Obj.Position
end

local function EndDrag()
    Info.StartPosObj = Vector3.zero
    Info.OffsetTo = Vector3.zero
end

function Move.Init()
    MoveControl = Things.Create("MoveControl") {
        Parent = Things.Root.RootViewport
    }

    MoveControl.Adornee = Move.Selection

    MoveControl.OnMove:Connect(function(Plane)
        Info.OffsetTo = Plane

        Move.ChangeTransform(Transform3D.FromPosition(Info.OffsetTo.X,Info.OffsetTo.Y,Info.OffsetTo.Z))
    end)

    MoveControl.StartMove:Connect(function()
        ToolManager.SetupSelection()
        StartDrag(Move.Selection)
    end)

    MoveControl.EndMove:Connect(function()
        Move.RegisterUndo()
        EndDrag()
    end)
end

function Move.Update()
    
end

function Move.Destroy()
    Things.Remove(MoveControl)
end

return Move