local Move = {}
local Things = Runtime.Things

local MoveControl ---@class MoveControl
local SelectingObj

local Info = {
    ["StartPosObj"] = Vector3.zero,
    ["OffsetTo"] = Vector3.zero,
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
        SelectingObj = Move.Selection
        Info.OffsetTo = Plane

        SelectingObj:SetTransform(Transform3D.FromPosition(Info.StartPosObj.X + Info.OffsetTo.X,Info.StartPosObj.Y + Info.OffsetTo.Y,Info.StartPosObj.Z + Info.OffsetTo.Z))
    end)

    MoveControl.StartMove:Connect(function()
        StartDrag(Move.Selection)
    end)

    MoveControl.EndMove:Connect(function()
        EndDrag()
    end)
end

function Move.Update()
    
end

function Move.Destroy()
    Things.Remove(MoveControl)
end

return Move