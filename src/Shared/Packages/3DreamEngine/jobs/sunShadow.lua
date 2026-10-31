local job = { }

---@type Dream
local lib = _3DreamEngine

function job:init()
	self.stencils = { }
end

function job:queue()
	--shadows
	for d, s in ipairs(lib.lighting) do
		if lib:getFeature("shadows") and s.shadow and s.active and s.shadow.typ == "sun" then
			lib:addOperation("sunShadow", s)
		end
	end
end

function job:execute(light)
	--create new canvases if necessary
	if not light.shadow.canvas then
		light.shadow.canvas = love.graphics.newCanvas(light.shadow.resolution, light.shadow.resolution,
			{ format = "r16f",
				readable = true,
				msaa = 0,
				type = "2d" })
		light.shadow.camera = lib:newCamera()

		local shadowCam = light.shadow.camera
		shadowCam.noFrustumCheck = true
		shadowCam.sun = true

		light.lastCascade = 0
	end
	
	local normal = light.direction
	local position = lib.camera.position
	
	light.lastCascade = light.lastCascade % 5

	local stepSize = light.shadow.refreshStepSize * 2.3
	
	local shadowCam = light.shadow.camera
	if not shadowCam or (position - shadowCam.position):lengthSquared() > stepSize or (normal - shadowCam.normal):lengthSquared() > 0 then
		local r = light.shadow.cascadeDistance
		local n = 1.0
		local f = 100
		
		--camera orientation
		shadowCam.position = position
		shadowCam.normal = normal
		shadowCam.transform = lib:lookAt(shadowCam.position + shadowCam.normal * (f * 0.5), shadowCam.position, lib.vec3(0.0, 1.0, 0.0))
		shadowCam.rendered = false
		
		--orthographic projected multiplied by the cameras view matrix
		local a1 = 1 / r
		local a6 = a1
		local a11 = -2 / (f - n)
		local a12 = -(f + n) / (f - n)
		
		local b = shadowCam.transform
		shadowCam.transformProj = lib.mat4({
			a1 * b[1], a1 * b[2], a1 * b[3], a1 * b[4],
			a6 * b[5], a6 * b[6], a6 * b[7], a6 * b[8],
			a11 * b[9], a11 * b[10], a11 * b[11], a11 * b[12] + a12,
			0.0, 0.0, 0.0, 1.0,
		})
	end
	
	local canvases = { light.shadow.canvas }
	
	--static shadow
	if not shadowCam.rendered or not light.shadow.static then
		local dynamic
		if light.shadow.static then
			dynamic = false
		end
		
		lib:render(shadowCam, canvases, dynamic, true, light.blacklist)
		
		--smooth lighting
		--[[if light.shadow.smooth then
			local blurStrength = 30.0 * light.size / light.shadow.cascadeFactor ^ (cascade - 1)
			local iterations = math.ceil(blurStrength)
			lib:blurCanvas(light.shadow.canvases[cascade], blurStrength / iterations, iterations, { true, false, false, false })
		end]]
	end
	
	shadowCam.rendered = true
end

return job