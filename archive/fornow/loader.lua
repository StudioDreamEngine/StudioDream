---@diagnostic disable: undefined-doc-param
--[[
#part of the 3DreamEngine by Luke100000
loader.lua - loads objects
--]]

---@type Dream
local lib = _3DreamEngine
local vec3 = lib.vec3

--tags that will get recognized
lib.meshTags = {
	["LOD"] = true,
	["POS"] = true,
	["LINK"] = true,
	["ID"] = true,
	["RAYTRACE"] = true,
	["REFLECTION"] = true,
	["HIDE"] = true,
	["SHADOW"] = true,
}

--the default args used by the object loader
lib.defaultArgs = {
	cleanup = false,
	mesh = true,
	export3do = false,
	skip3do = false, --todo remove
	particleSystems = false,
	scene = false,
	decodeBlenderNames = true,
}

--extends given arg table with default args
local function prepareArgs(args)
	if type(args) == "string" then
		error("loadObjects signature has changed, please check docu")
	end
	
	args = table.copy(args or { })
	
	for d, s in pairs(lib.defaultArgs) do
		if args[d] == nil then
			args[d] = s
		end
	end
	
	return args
end

--remove objects without vertices
local function cleanEmpties(obj)
	for d, m in pairs(obj.meshes) do
		if not m.faces or not m.vertices or m.vertices:getSize() == 0 then
			obj.meshes[d] = nil
		end
	end
end

lib.supportedFiles = {
	--todo temporary disabled
	-- "3do", --3DreamEngine object file - way faster than obj but does not keep vertex information
	"glb", --glTF binary format
	"gltf", --glTF embedded or separate
	"vox", --magicka voxel
	"obj", --obj file
	"dae", --dae file
}

---Loads and adds that object as a library, see https://3dreamengine.github.io/3DreamEngine/docu/introduction
function lib:loadLibrary(path, args, prefix)
	args = prepareArgs(args)
	args.loadAsLibrary = true
	
	--load
	local obj = self:loadScene(path, args)
	
	--insert into library
	for d, o in pairs(obj.objects) do
		local id = (prefix or "") .. d
		self.objectLibrary[id] = o
	end
end

---Register object in the object library. Objects loaded with the `LINK` tag are then replaced with the entry from the library
---@param object DreamObject
---@param name string
function lib:registerObject(object, name)
	self.objectLibrary[name] = object
end

---Loads an scene, see https://3dreamengine.github.io/3DreamEngine/docu/introduction
function lib:loadScene(path, args)
	args = args and table.copy(args) or { }
	args.scene = true
	return self:loadObject(path, args)
end

--[[
Object Tags in name
A mesh/object name may contain additional tags, denoted as `TAG:VALUE_` or `TAG_`
	`POS:name` treats it as position
	`PHYSICS:type` treats it as a collider
	`LOD:level` set lod, starting at 0
	`LINK:name` replace this object with an library entry
	`RAYTRACE` treat as raytrace, puts it into
	`REFLECTION` treat as reflection (WIP)
	`REMOVE` removes, may be used for placeholder or reference objects
	`SHADOW:FALSE` disabled shadow
--]]

--[[
Loader Args
	`mesh (true)` create a mesh after loading
	`particleSystems (true)` generate particleSystems as defined in the material
	`cleanup (true)` unloads raw buffers (positions, normals, ...) after finishing loading
	`export3do (false)` loads the object as usual, then export the entire object as a 3DO file
	`animations (nil)` when using COLLADA format, split the animation into `{key = {from, to}}`, where `from` and `to` are timestamps in seconds
	`decodeBlenderNames (true)` remove the vertex objects postfix added on export, e.g. `name` instead of `name_Cube`
--]]

---Load an object
---@param path string @ Path to object without extension
---@param args table
--[[function lib:loadObject(path, args)
	--set default args
	args = prepareArgs(args)
	
	local n = string.split(path, "/")
	local dir = #n > 1 and table.concat(n, "/", 1, #n - 1) or ""
	
	local obj = self:newObject()
	obj.args = args
	obj.dir = dir
	
	self.deltonLoad:start("load " .. obj.name)
	
	--test for existing files
	local found = { }
	local newest = 0
	for _, typ in ipairs(lib.supportedFiles) do
		local info = love.filesystem.getInfo(path .. "." .. typ) -- ??? This was supost to be working??? 
		if info then
			found[typ] = info.modtime or 0
			newest = math.max(info.modtime or 0, newest)
		end
	end
	
	--load files
	for _, typ in ipairs(lib.supportedFiles) do
		if found[typ] then
			--load object
			self.deltonLoad:start("parser")
			local file = love.filesystem.read(path .. "." .. typ)

			self.loader[typ](self, obj, file)
			self.deltonLoad:stop()
		end
	end
	
	if not next(found) then
		error("object " .. obj.name .. " not found (" .. path .. ")")
	end
	
	self:processObject(obj) --extract positions, physics, ...
	self:finishObject(obj) --create meshes, link library entries, ...
	
	self.deltonLoad:stop()

	return obj
end]]

---@param name string @ the full object or mesh identifier
---@return string, table @ the actual name and the extracted tags
---@private
function lib:parseTags(name)
	name = self:removePostfix(name)
	if type(name) == "string" then
		local possibles = string.split(name, "_")
		local tags = { }
		for index, tag in ipairs(possibles) do
			local key, value = unpack(string.split(tag, ":"))
			if self.meshTags[key] then
				--tag found
				tags[key:lower()] = value or true
			elseif key:upper() == key and key:lower() ~= key then
				--this looks like a tag, but is invalid
				print(string.format("Unknown tag '%s' of object/mesh '%s'", key, name))
			else
				--cancel, the rest is the name
				return table.concat(possibles, "_", index), tags
			end
		end
		return "root", tags
	else
		return name, { }
	end
end

---Finish object
---@param obj DreamObject
---@private
function lib:finishObject(obj)
	for _, o in pairs(obj.objects) do
		self:finishObject(o)
	end
	
	--link objects
	for index, link in ipairs(obj.links) do
		local lo = self.objectLibrary[link.source]
		assert(lo, "Linked object " .. link.source .. " is not in the object library!")
		local o = self:newLinkedObject(lo, link.source)
		o.transform = link.transform
		obj.objects["link_" .. index] = o
	end
	
	--callback
	if obj.args.callback then
		obj.args.callback(obj)
	end
	
	--remove empty meshes
	cleanEmpties(obj)
	
	--cleaning up
	if obj.args.cleanup then
		obj:cleanup()
	end
end