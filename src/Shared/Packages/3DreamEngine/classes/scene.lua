---@type Dream
local lib = _3DreamEngine

---newScene
---@param shadowPass boolean
---@param dynamic boolean
---@param alpha boolean
---@param cam DreamCamera
---@param blacklist Rasterizer
---@param frustumCheck boolean
---@param canvases DreamCanvases
---@param light Rasterizer
---@param isSun boolean
---@return DreamScene
---@private
function lib:newScene(shadowPass, dynamic, alpha, cam, blacklist, frustumCheck, canvases, light, isSun)
	---@type DreamScene
	local m = setmetatable({ }, self.meta.scene)
	
	m.tasks = { }
	
	m.shadowPass = shadowPass
	m.dynamic = dynamic
	m.alpha = alpha
	m.cam = cam
	m.blacklist = blacklist or { }
	m.frustumCheck = frustumCheck
	m.canvases = canvases
	m.light = light
	m.isSun = isSun
	
	--setting specific identifier
	m.settingsIdentifier = self:getGlobalSettingsIdentifier(alpha, canvases, shadowPass, isSun)
	
	return m
end

local function getPosition(mesh, transform)
	if transform then
		local a = mesh.boundingSphere.center
		return lib.vec3(
				transform[1] * a[1] + transform[2] * a[2] + transform[3] * a[3] + transform[4],
				transform[5] * a[1] + transform[6] * a[2] + transform[7] * a[3] + transform[8],
				transform[9] * a[1] + transform[10] * a[2] + transform[11] * a[3] + transform[12])
	else
		return mesh.boundingSphere.center
	end
end

local function isWithingLOD(LOD_min, LOD_max, pos, size)
	local camPos = lib.camera.position
	if camPos then
		local dist = math.max(((pos - camPos):length() - size) * lib.LODFactor, 0)
		if dist <= LOD_max + 1 then
			return dist >= LOD_min and dist <= LOD_max, true
		else
			return false, false
		end
	else
		return true, true
	end
end

---@class DreamScene
local class = {
	links = { "scene" },
}

---Add a mesh to the scene
---@param mesh DreamMesh
---@param transform DreamMat4
---@param reflection DreamReflection @ optional
function class:addMesh(mesh, transform, reflection, material)
	if self.blacklist[mesh] then
		return
	end
	
	--not visible
	if self.shadowPass then
		if material.Alpha or not mesh.shadowVisibility or material.shadow == false then
			return
		end
	else
		if not mesh.renderVisibility then
			return
		end
	end
	
	--wrong alpha
	if (self.alpha and true) ~= (material.Alpha and true) then
		return
	end
	
	--todo cache
	local pos = getPosition(mesh, transform)
	
	--not visible from current perspective
	if self.frustumCheck and mesh.boundingSphere.size > 0 then
		local size = mesh.boundingSphere.size * (transform and transform:getLossySize() or 1)
		mesh.rID = mesh.rID or math.random()
		if not self.cam:inFrustum(pos, size, mesh.rID) then
			return false
		end
	end
	
	--todo here custom reflections (closest globe or default) and lights can be used
	
	local shader = lib:getRenderShader(mesh, material, reflection, self.settingsIdentifier, self.alpha, self.canvases, self.light, self.shadowPass, self.isSun)
	
	local dist = self.alpha and (pos - self.cam.position):lengthSquared() or 0
	
	--create task object
	local task = setmetatable({
		mesh,
		transform,
		pos,
		shader,
		reflection,
		dist,
		material
	}, lib.meta.task)
	
	--add to list
	self:addTo(task, shader, material)
end

function class:addTo(task, shader, material)
	if self.alpha then
		table.insert(self.tasks, task)
	else
		--create lists
		if not self.tasks[shader] then
			self.tasks[shader] = { [material] = { task } }
		elseif not self.tasks[shader][material] then
			self.tasks[shader][material] = { task }
		else
			table.insert(self.tasks[shader][material], task)
		end
	end
end

--sorting function for the alpha pass
local function sortFunction(a, b)
	return a:getDistance() > b:getDistance()
end

function class:getIterator()
	if self.alpha then
		table.sort(self.tasks, sortFunction)
		
		local i = 0
		return function()
			i = i + 1
			return self.tasks[i]
		end
	else
		local co = coroutine.create(function()
			for _, shaderGroup in pairs(self.tasks) do
				for _, materialGroup in pairs(shaderGroup) do
					for _, task in pairs(materialGroup) do
						coroutine.yield(task)
					end
				end
			end
		end)
		
		return function()
			local ok, task = coroutine.resume(co)
			if ok then
				return task
			end
		end
	end
end

return class