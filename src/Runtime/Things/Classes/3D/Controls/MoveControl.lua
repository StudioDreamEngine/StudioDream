-- Base object for ALL 3d objects, drawable or not
local Things = Runtime.Things

---@class MoveControl: Base3D
local MoveControl = Things.Extend("Base3D")

local Lookup = {
    Vector3.zAxis,
    -Vector3.zAxis,
    Vector3.xAxis,
    -Vector3.xAxis,
    Vector3.yAxis,
    -Vector3.yAxis
}

function MoveControl:new()
    MoveControl.super.new(self)

    self.OnMove = Signal:New("Control")
    self.Adornee = nil ---@class Drawable3D

    self.Adorns = {}
    self.Scale = .25

    for _, Axis in pairs(Lookup) do
        local UUID = CreateUUID()

        self.Adorns[Axis] = {
            Object = Runtime.Backend3D.LoadObject("Assets/DefaultMeshes/arrow", UUID),
            UUID = UUID
        }
    end
end

function MoveControl:Update(dt)
    if (not self.Adornee) then return end

    ---@class Camera
    local Camera = Things.Root:GetCamera()

    local Transform = self.Adornee.Transform

    local Z = Camera:RayDirectionToPlane(Transform.Position, Transform.Side, Camera:GetMouseRay()) * Vector3.zAxis
    local Y = Camera:RayDirectionToPlane(Transform.Position, Transform.Forward, Camera:GetMouseRay()) * Vector3.yAxis -- Idk if Y should use the forward vector... whatever!
    local X = Camera:RayDirectionToPlane(Transform.Position, Transform.Forward, Camera:GetMouseRay()) * Vector3.xAxis

    print(Z)

    for Axis, Adorn in pairs(self.Adorns) do
        Adorn.Object:resetTransform()
        Adorn.Object:translate((Transform.Position + (Axis * self.Adornee.Size)).ToDream())
        Adorn.Object:lookTowards(-Axis.ToDream())
        Adorn.Object:scale(self.Scale)
        Adorn.Object:translate(0,0,2)
        Adorn.Object:rotateX(math.pi/2)
    end
end

return MoveControl