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

    local Material = Dream:newMaterial()

    print("Create buffer")

    local Buffer = Runtime.Resources.CreateBuffer(Canvas)
    Material:SetAlbedoTexture(Buffer)
	Material.Particle = true
    Material.Alpha = true
    Material.Simple = true

    Drawable:setMaterial(Material)

    local Mesh = Dream:newSprite()
    Drawable.meshes["Mesh"] = Mesh

    return Mesh, Drawable, Buffer
end

return BillboardClass