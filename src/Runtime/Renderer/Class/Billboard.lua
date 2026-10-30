local BillboardClass = {}

function BillboardClass.UpdateTransform(Object, Position, ParentViewport)
    if ParentViewport:IsA("Environment") and ParentViewport.Camera then
        local Camera = ParentViewport.Camera ---@class Camera
        local Rotation = Camera.Transform:GetBasis() ---@class Transform3D

        Object.Drawable:setTransform((Transform3D.FromPosition(Position) * Rotation):GetMatrix())
    end
end

function BillboardClass.NewSprite(quad)
	local u1, v1, u2, v2, ratio
	if quad then
		local qx, qy, w, h = quad:getViewport()
		local sw, sh = quad:getTextureDimensions()
		ratio = h / w
		u1, v1, u2, v2 = qx / sw, qy / sh, (qx + w) / sw, (qy + h) / sh
	else
		u1, v1, u2, v2, ratio = 0, 0, 1, 1, 1
	end
	
	return BillboardClass.GetQuadMesh(1, ratio, u1, v1, u2, v2)
end

local normals, faces

---Builds a quad mesh
function BillboardClass.GetQuadMesh(sx, sy, u1, v1, u2, v2)
	if not normals then
		normals = Dream:newDynamicBuffer()
		normals:append({ 0, 0, 1 })
		normals:append({ 0, 0, 1 })
		normals:append({ 0, 0, 1 })
		normals:append({ 0, 0, 1 })
		
		faces = Dream:newDynamicBuffer()
		faces:append({ 1, 2, 3 })
		faces:append({ 1, 3, 4 })
	end
	
	local mesh = Dream:newMesh()
	
	local vertices = mesh:getOrCreateBuffer("vertices")
	vertices:append({ -1 * sx, -1 * sy, 0.0 })
	vertices:append({ 1 * sx, -1 * sy, 0.0 })
	vertices:append({ 1 * sx, 1 * sy, 0.0 })
	vertices:append({ -1 * sx, 1 * sy, 0.0 })
	
	local texCoords = mesh:getOrCreateBuffer("texCoords")
	texCoords:append({ u1, v2 })
	texCoords:append({ u2, v2 })
	texCoords:append({ u2, v1 })
	texCoords:append({ u1, v1 })
	
	mesh.normals = normals
	mesh.faces = faces
	
	return mesh
end

function BillboardClass.CreateBillboard(Canvas)
    local Drawable = Runtime.Backend3D.CreateAdorn("BillboardClass")
    local Material = Runtime.Things.New("Material")

    print("Create buffer")

    local Buffer = Runtime.Resources.CreateBuffer(Canvas)
    Material:SetAlbedoTexture(Buffer)
	Material.Particle = true
    Material.Alpha = true
    Material.Simple = true

    Material:OnPropertyUpdate()

    local Mesh = BillboardClass.NewSprite()
    Drawable.material = Material
    Drawable.mesh = Mesh

    return Drawable, Buffer
end

return BillboardClass