local Move = {}
local Things = Runtime.Things

local MoveControl ---@class MoveControl
local SelectingObj
local SelectingPos

local Info = {
    ["StartPosPlane"] = Vector3.zero, 
    ["StartPosObj"] = Vector3.zero,
    ["OffsetTo"] = Vector3.zero,
}

local Locks = {
    ["StartLock"] = false
}

local function StartDrag(Plane,Obj)
    Info.StartPosPlane = Plane
    Info.StartPosObj = Obj.Position
end

local function EndDrag()
    Locks.StartLock = false
    Info.StartPosObj = Vector3.zero
    Info.StartPosPlane = Vector3.zero
    Info.OffsetTo = Vector3.zero
end

function Move.Init()
    MoveControl = Things.Create("MoveControl") {
        Parent = Things.Root.RootViewport
    }

    MoveControl.Adornee = Move.Selection

    MoveControl.OnMove:Connect(function(Plane)
    SelectingObj = Move.Selection
    if not Locks.StartLock then
        Locks.StartLock = true
        StartDrag(Plane, Move.Selection)
    end

    local CamPos = Things.Root:GetCamera().Position
    local ObjPos = SelectingObj.Position
   -- local Distance = math.sqrt((CamPos.X - ObjPos.X)^2 +(CamPos.Y - ObjPos.Y)^2 +(CamPos.Z - ObjPos.Z)^2)

   -- local Scale = Distance * 0.01

    Info.OffsetTo = Vector3.new((Plane.X - Info.StartPosPlane.X),(Plane.Y - Info.StartPosPlane.Y),(Plane.Z - Info.StartPosPlane.Z))

    SelectingObj.Transform = Transform3D.FromPosition(Info.StartPosObj.X + Info.OffsetTo.X,Info.StartPosObj.Y + Info.OffsetTo.Y,Info.StartPosObj.Z + Info.OffsetTo.Z)
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