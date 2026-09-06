--[[
#part of the 3DreamEngine by Luke100000
--]]

---@type Dream
local lib = _3DreamEngine

---Renders the sky box
---@private
function lib:renderSky(transformProj, camTransform, transformScale)
	if transformScale then
		transformProj = transformProj * lib.mat4.getScale(transformScale)
	end
	
	love.graphics.push("all")

	--cubemap
	local shader = self:getBasicShader("sky_cube")
	love.graphics.setShader(shader)
	shader:send("transformProj", transformProj)
	local mesh = self.cubeObject.mesh:getMesh()
	mesh:setTexture(self.sky_texture)
	love.graphics.draw(mesh)

	love.graphics.pop()
end