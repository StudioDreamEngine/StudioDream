local sh = { }
local lib = _3DreamEngine

sh.type = "light"

sh.func = "sampleShadowSun"

function sh:constructDefinesGlobal(dream)
	return self:constructDefinesGlobalCommon(dream)
end

function sh:constructDefinesGlobalCommon(dream)
	return [[
	float ]] .. self.func .. [[(vec3 vertexPos, vec3 pos, mat4 proj, Image tex, vec3 normal, vec3 vertexNormal) {
		//float bias = mix(1.0, 0.01, dot(vertexNormal, normal)) / 512.0;
		float v = 0.0;

		vec3 uvs = (proj * vec4(vertexPos, 1.0)).xyz;

		//float dist = distance(uvs, pos);
		//float fade = clamp(-8.0f + (dist * 16f),0.0,1.0);

		return 0.0;
	}
	]]
end

function sh:constructDefines(ID)
	return ([[
	uniform vec3 ss_pos_#ID#;
	
	uniform mat4 ss_proj_#ID#;
	
	uniform Image ss_tex_#ID#;
	
	uniform vec3 ss_vec_#ID#;
	uniform vec3 ss_color_#ID#;
	]]):gsub("#ID#", ID)
end

function sh:constructPixelGlobal(dream)

end

function sh:constructPixel(ID)
	return ([[
	float shadow = ]] .. self.func .. [[(vertexPos, ss_pos_#ID#, ss_proj_#ID#, ss_tex_#ID#, normal, ss_vec_#ID#);

	//if (shadow > 0.0) {
		vec3 lightColor = ss_color_#ID#;
		
		light += getLight(lightColor, viewVec, ss_vec_#ID#, normal, albedo, roughness, metallic);
	//}

	//vec2 uv = (ss_proj_#ID# * vec4(vertexPos, 1.0)).xy;
	//vec2 NewUV = vec2(uv.x, 1.0-uv.y);

	//light = Texel(ss_tex_#ID#, NewUV).xyz;
	]]):gsub("#ID#", ID)
end

function sh:sendGlobalUniforms(shaderObject)
	local shader = shaderObject.shader
end

function sh:sendUniforms(shaderObject, light, ID)
	local shader = shaderObject.shader
	
	if light.shadow.canvas then
		shader:send("ss_pos_" .. ID, light.shadow.camera.position)
		shader:send("ss_proj_" .. ID, light.shadow.camera.transformProj)
		shader:send("ss_tex_" .. ID, light.shadow.canvas)
	end

	shader:send("ss_color_" .. ID, light.color * light.brightness)
		
	if shader:hasUniform("ss_vec_" .. ID) then
		shader:send("ss_vec_" .. ID, light.direction)
	end
end

return sh