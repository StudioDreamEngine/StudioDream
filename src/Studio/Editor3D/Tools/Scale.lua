local Scale = {}
local Things = Runtime.Things

Scale.SingleSelect = true -- For now

local ScaleControl ---@class ScaleControl

-- miklitus
local Info = {
    OgScale = Vector3.zero,
    StartPos = Vector3.zero
}

local function StartDrag(Obj)
    Info.OgScale = Obj.Scale
    Info.StartPos = Obj.Position
end

local function EndDrag()
    --Studio.EditorServices.Undo.RegisterUndo(SelectingObj,"Transform",Transform3D.FromPosition(Info.StartPosObj+Info.OffsetTo))
    
    Info.StartPosObj = Vector3.zero
    Info.OffsetTo = Vector3.zero
end

function Scale.Init()
    ScaleControl = Things.Create("ScaleControl") {
        Parent = Things.Root.RootViewport
    }

    ScaleControl.Adornee = Scale.Selection

    local Selecting = Scale.Selection ---@class Transformable3D

    ScaleControl.OnMove:Connect(function(Plane, Normal)
        local ScaleOffset = (Normal.Abs() * Plane)/2
        local ScaleOffset2 = (Normal * Plane)/2

        Selecting:SetPosition(Info.StartPos + ScaleOffset2)
        Selecting.Scale = Info.OgScale + ScaleOffset
    end)

    ScaleControl.StartScale:Connect(function()
        StartDrag(Selecting)
    end)

    ScaleControl.EndScale:Connect(function()
        EndDrag()
    end)
end

function Scale.Update()
    
end

function Scale.Destroy()
    Things.Remove(ScaleControl)
end

return Scale