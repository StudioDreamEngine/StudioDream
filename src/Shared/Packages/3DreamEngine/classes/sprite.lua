---@type Dream
local lib = _3DreamEngine

---Creates a new sprite, that is, a textured quad mesh
---@param texture Texture @ optional
---@param quad Quad @ optional
---@return DreamSprite
function lib:newSprite(quad)
	local u1, v1, u2, v2, ratio
	if quad then
		local qx, qy, w, h = quad:getViewport()
		local sw, sh = quad:getTextureDimensions()
		ratio = h / w
		u1, v1, u2, v2 = qx / sw, qy / sh, (qx + w) / sw, (qy + h) / sh
	else
		u1, v1, u2, v2, ratio = 0, 0, 1, 1, 1
	end
	
	---@type DreamSprite
	local mesh = setmetatable(lib.classes.sprite.getQuadMesh(1, ratio, u1, v1, u2, v2), self.meta.sprite)
	
	return mesh
end

---A sprite represents a simple, textured quad
---@class DreamSprite : DreamMesh
local class = {
	links = { "mesh", "sprite" },
}

local normals, faces

---Builds a quad mesh
---@param sx number
---@param sy number
---@param u1 number
---@param v1 number
---@param u2 number
---@param v2 number
---@private
function class.getQuadMesh(sx, sy, u1, v1, u2, v2)
	if not normals then
		normals = lib:newDynamicBuffer()
		normals:append({ 0, 0, 1 })
		normals:append({ 0, 0, 1 })
		normals:append({ 0, 0, 1 })
		normals:append({ 0, 0, 1 })
		
		faces = lib:newDynamicBuffer()
		faces:append({ 1, 2, 3 })
		faces:append({ 1, 3, 4 })
	end
	
	local material = lib:newMaterial()
	local mesh = lib:newMesh(material)
	
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

return class