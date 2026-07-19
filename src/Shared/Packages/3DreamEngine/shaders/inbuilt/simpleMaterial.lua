local dream = _3DreamEngine

local sh = { }

sh.type = "world"

function sh:buildDefines(mat, shadow)
	return [[
		#ifdef PIXEL
			uniform Image brdfLUT;
			
			uniform float ior;
		#endif
	]]
end

function sh:buildPixel(mat, shadow)
	return "color = albedo.rgb;"
end

function sh:buildVertex(mat)
	return ""
end

function sh:perShader(shaderObject)
end

function sh:perMaterial(shaderObject, material)
	local shader = shaderObject.shader
	
	if shader:hasUniform("ior") then
		shader:send("ior", 1 / material.IOR)
	end
end

function sh:perTask(shaderObject, task)
	
end

return sh