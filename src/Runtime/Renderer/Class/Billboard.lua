local BillboardClass = {}

function BillboardClass.UpdateTransform(Object, Position, ParentViewport)
    if ParentViewport:IsA("Environment") and ParentViewport.Camera then
        local Camera = ParentViewport.Camera ---@class Camera
        local Rotation = Camera.Transform.Rotation ---@class Transform3D

        Object.Drawable:setTransform((Transform3D.FromPosition(Position) * Rotation).GetMatrix())
    end
end

function BillboardClass.CreateBillboard(Canvas)
    local Drawable = Dream:newObject()
    local Mesh = Dream:newSprite(Canvas)
    Mesh.material.Alpha = true
    Mesh.material.Simple = true

    Drawable.meshes["Mesh"] = Mesh

    return Mesh, Drawable
end

return BillboardClass