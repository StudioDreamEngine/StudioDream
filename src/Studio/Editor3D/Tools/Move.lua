local Move = {}
local Things = Runtime.Things

local MoveControl ---@class MoveControl

function Move.Init()
    MoveControl = Things.Create("MoveControl") {
        Parent = Things.Root.RootViewport
    }

    MoveControl.Adornee = Move.Selection

    MoveControl.OnMove:Connect(function(Plane)
        print(Plane)
    end)
end

function Move.Update()
    
end

function Move.Destroy()
    Things.Remove(MoveControl)
end

return Move