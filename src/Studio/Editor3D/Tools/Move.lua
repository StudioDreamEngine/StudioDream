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

function Move.Init(Snap)
    MoveControl = Things.Create("MoveControl") {
        Parent = Things.Root.RootViewport,
        GridSnap = Studio.Editor3D.GridSnap
    }

    MoveControl.GridSnap = Snap
    MoveControl.Adornee = Move.Selection

    Studio.Editor3D.GridUpdated:Connect(function()
        printVerbose("Updated")
        MoveControl:UpdateGrid(Studio.Editor3D.GridSnap)
    end)

    MoveControl.ControlChanged:Connect(function(Plane)
        Info.OffsetTo = Plane

        Move.ChangeTransform(Transform3D.FromPosition(Info.OffsetTo.X,Info.OffsetTo.Y,Info.OffsetTo.Z))
    end)

    MoveControl.StartControl:Connect(function()
        ToolManager.SetupSelection()
        StartDrag(Move.Selection)
    end)

    MoveControl.EndControl:Connect(function()
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