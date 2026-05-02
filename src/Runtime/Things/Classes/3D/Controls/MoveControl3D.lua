-- Base object for ALL 3d objects, drawable or not
local Things = Runtime.Things

---@class MoveControl: Base3D
local MoveControl = Things.Extend("Base3D")

function MoveControl:new()
    MoveControl.super.new(self)

    self.OnMove = Signal:New("Control")
end

function MoveControl:Update(dt)
    
end

return MoveControl