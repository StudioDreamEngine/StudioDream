return function(MeshBytes, Identifier)
    -- obj loader from 3DreamEngine

    --store vertices, normals and texture coordinates
	local vertices = { }
	local normals = { }
	local texture = { }

    local mesh = Dream:newMesh()
	
	for _, l in pairs(string.split(MeshBytes, "\n")) do
		l = string.gsub(l, "\r", "") -- thanks trusti
		local v = string.split(l, " ")
		
		if v[1] == "v" then
			table.insert(vertices, { tonumber(v[2]), tonumber(v[3]), tonumber(v[4]) })
		elseif v[1] == "vn" then
			table.insert(normals, { tonumber(v[2]), tonumber(v[3]), tonumber(v[4]) })
		elseif v[1] == "vt" then
			table.insert(texture, { tonumber(v[2]), 1.0 - tonumber(v[3]) })
		elseif v[1] == "f" then
			local meshVertices = mesh:getOrCreateBuffer("vertices")
			local meshTexCoords = mesh:getOrCreateBuffer("texCoords")
			local meshNormals = mesh:getOrCreateBuffer("normals")
			local meshFaces = mesh:getOrCreateBuffer("faces")
			
			local vertexCount = #v - 1
			
			--triangulate faces
			local index = meshVertices:getSize()
			if vertexCount == 3 then
				--tris
				meshFaces:append({ index + 1, index + 2, index + 3 })
			else
				--triangulates, fan style
				for i = 1, vertexCount - 2 do
					meshFaces:append({ index + 1, index + 1 + i, index + 2 + i })
				end
			end
			
			--combine vertex and data into one
			index = index + vertexCount
			for i = 1, vertexCount do
				local v2 = string.split(v[i + 1]:gsub("//", "/0/"), "/")
				meshVertices:append(vertices[tonumber(v2[1])] or { 0, 0, 0 })
				meshTexCoords:append(texture[tonumber(v2[2])] or { 0, 0 })
				meshNormals:append(normals[tonumber(v2[3])] or { 1, 0, 0 })
			end
		end
	end

    return mesh
end