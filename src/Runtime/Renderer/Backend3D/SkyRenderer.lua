local skyMesh = Dream.cubeObject:getMesh()
local celestialMesh = Dream.planeObject:getMesh()

local shader = Dream:getBasicShader("sky_cube")
local shader2 = Dream:getBasicShader("sky_celestial")

local Sun
local Moon
local Sky

local RenderSky = {}

RenderSky.TransformProj = nil

RenderSky.Time = 7
RenderSky.Latitude = math.pi/3
RenderSky.Ambient = 0.25

local function sendWithTransform(transform, mesh, celestial)
	local currentShader = celestial and shader2 or shader

	love.graphics.setShader(currentShader)

	currentShader:send("transform", (transform or Dream.mat4.getIdentity()))
	currentShader:send("transformProj", RenderSky.TransformProj)

	love.graphics.draw(mesh)
	--love.graphics.clear(false, true, true)
end

function RenderSky.SetSky(InSky)
	Sky = love.graphics.newCubeImage(InSky)
end

function RenderSky.SetCelestials(Celestial,ImageData)
	if Celestial == "Sun" then
		Sun = ImageData
	else
		Moon = ImageData
	end
end

function RenderSky.Draw()
	RenderSky.Longitude = GlobalTick

	skyMesh:setTexture(Sky)

	local TimeMultiplier = math.abs(((-RenderSky.Time + 6) / 24) % 1)
	local Longitude = TimeMultiplier * math.pi * 2

	--[[
		0.4 - 0.5: Fade
		0.5 - 1: Transparent
		0 - 0.1: Fade

		(Old quadratic, ignore, its been replaced with a more understandable linear one)
		-(4x-1.3)^2+1.5
	]]
	
	local SunLight = math.clamp(math.abs(10 * (TimeMultiplier-0.25)) - 1.5,0,1)
	local SkyLight = math.clamp(math.abs(8 * (TimeMultiplier-0.25)) - 1,0,1)

	love.graphics.setColor(SkyLight,SkyLight,SkyLight,1)
	sendWithTransform(nil, skyMesh)

	--RenderSky.Time = GlobalTick*4

	local SunTransform = Transform3D.FromAngle(0, 0, Longitude) * Transform3D.FromAngle(0, -RenderSky.Latitude, 0) * Transform3D.FromPosition(0,0,0.2) * Transform3D.FromAngle(0, 0, -Longitude)
	local MoonTransform = Transform3D.FromAngle(0, 0, Longitude) * Transform3D.FromAngle(0, RenderSky.Latitude, 0) * Transform3D.FromPosition(0,0,0.2) * Transform3D.FromAngle(0, 0, -Longitude)
	
	local SunDirection = SunTransform.Forward
	Runtime.Backend3D.SunLight:setDirection(SunDirection.X,SunDirection.Y,SunDirection.Z)
	Runtime.Backend3D.SunLight:setBrightness(SunLight*10)

	local MoonDirection = MoonTransform.Forward
	Runtime.Backend3D.MoonLight:setDirection(MoonDirection.X,MoonDirection.Y,MoonDirection.Z)
	Runtime.Backend3D.MoonLight:setBrightness((1-SunLight)*10)
	
	love.graphics.setColor(1,1,1,SunLight)
	celestialMesh:setTexture(Sun)
	sendWithTransform(SunTransform:GetMatrix() * Dream.mat4.getScale(0.02), celestialMesh, true)

	love.graphics.setColor(1,1,1,1-SunLight/2)
	celestialMesh:setTexture(Moon)
	sendWithTransform(MoonTransform:GetMatrix() * Dream.mat4.getScale(0.02), celestialMesh, true)
end

return RenderSky