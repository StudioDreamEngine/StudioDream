local sh = { }
local lib = _3DreamEngine

sh.type = "light"

sh.func = "sampleShadowSun"

function sh:constructDefinesGlobal(dream)
	return [[
	uniform float maxShadowIntensity;

	float sampleShadowSun2(Image tex, vec2 shadowUV, float depth) {
		float ox = float(fract(love_PixelCoord.x * 0.5) > 0.25);
		float oy = float(fract(love_PixelCoord.y * 0.5) > 0.25) + ox;
		if (oy > 1.1) oy = 0.0;
		float ss_texelSize = 1.0 / love_ScreenSize.x;

		vec2 NewUV = vec2(shadowUV.x, 1.0-shadowUV.y);
		
		float r0 = texture(tex, NewUV + vec2(-1.5 + ox, 0.5 + oy) * ss_texelSize).x;
		float r1 = texture(tex, NewUV + vec2(0.5 + ox, 0.5 + oy) * ss_texelSize).x;
		float r2 = texture(tex, NewUV + vec2(-1.5 + ox, -1.5 + oy) * ss_texelSize).x;
		float r3 = texture(tex, NewUV + vec2(0.5 + ox, -1.5 + oy) * ss_texelSize).x;

		return (r0 > depth ? 0.25 : 0.0) +
			(r1 > depth ? 0.25 : 0.0) +
			(r2 > depth ? 0.25 : 0.0) +
			(r3 > depth ? 0.25 : 0.0)
		;
	}
	]] .. self:constructDefinesGlobalCommon(dream)
end

function sh:constructDefinesGlobalCommon(dream)
	return [[
	float ]] .. self.func .. [[(vec3 vertexPos, vec3 pos, mat4 proj, Image tex, float bias, float distlimit) {
		float dist = distance(vertexPos, pos)/distlimit;
		float fade = clamp(-8.0f + (dist * 16f),0.0,1.0);

		float v = 0.0;
		vec3 uvs = (proj * vec4(vertexPos, 1.0)).xyz;
		v += ]] .. self.func ..[[2(tex, uvs.xy * 0.5 + 0.5, uvs.z - bias);

		return clamp(v + fade, 0.0, 1.0); //1.0;
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
	float shadowBias = dot(normal, -ss_vec_#ID#);
	float bias = mix(1.0, 0.01, dot(normal, ss_vec_#ID#)) / 512.0;
	float shadow = ]] .. self.func .. [[(vertexPos, ss_pos_#ID#, ss_proj_#ID#, ss_tex_#ID#, bias, 20.0f);

	if (shadowBias > 0.0) {
		shadow = 1.0;
	}

	if (shadow > 0.0) {
		vec3 lightColor = ss_color_#ID# * shadow;
		
		light += getLight(lightColor, viewVec, ss_vec_#ID#, normal, albedo, roughness, metallic);
	}
	]]):gsub("#ID#", ID)
end

function sh:sendGlobalUniforms(shaderObject)
	local shader = shaderObject.shader

	shader:send("maxShadowIntensity", 1.0 - (lib:getShadowIntensity() or 1.0))
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