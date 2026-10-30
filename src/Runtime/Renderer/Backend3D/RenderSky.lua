return function (transformProj)
    local shader = Dream:getBasicShader("sky_cube")
	love.graphics.setShader(shader)
	shader:send("transformProj", transformProj)
	local mesh = Dream.cubeObject:getMesh()
	mesh:setTexture(Dream.sky_texture)
	love.graphics.draw(mesh)
end