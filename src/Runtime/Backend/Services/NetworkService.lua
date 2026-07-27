---@class NetworkService
local NetworkService = {}

local enet = require("enet")

local function generateRandomId()
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local id = ""
	for i = 1, 16 do
		local rand = love.math.random(1, #chars)
		id = id .. string.sub(chars, rand, rand)
	end
	return id
end

function NetworkService.Init()
	love.math.setRandomSeed(os.time())
	NetworkService.ActiveHosts = {}
end

function NetworkService.Connect(ipAddress)
	local id
	repeat
		id = generateRandomId()
	until not NetworkService.ActiveHosts[id]

	local enetHost = enet.host_create(nil, 1, 2)

	local serverPeer = enetHost:connect(ipAddress, 2)

	local clientObject = {
		Id = id,
		EnetHost = enetHost,
		ServerPeer = serverPeer,
		IsConnected = false,
		OnConnected = Signal:New("OnConnected"),
		OnDisconnected = Signal:New("OnDisconnected"),
		OnReceived = Signal:New("OnReceived"),
	}

	function clientObject:Send(data, isReliable)
		if not self.ServerPeer or not self.IsConnected then
			return
		end

		local channel = (isReliable == false) and 0 or 0
		local flag = (isReliable == false) and "unreliable" or "reliable"

		self.ServerPeer:send(data, channel, flag)
		self.EnetHost:flush()
	end

	function clientObject:Close()
		if not NetworkService.ActiveHosts[self.Id] then
			return
		end

		if self.ServerPeer then
			self.ServerPeer:disconnect()
			self.EnetHost:flush()
		end

		if self.EnetHost then
			self.EnetHost:destroy()
		end

		NetworkService.ActiveHosts[self.Id] = nil
		collectgarbage("collect")
	end

	NetworkService.ActiveHosts[id] = clientObject
	return clientObject
end

function NetworkService.CloseAll()
	for _, clientObject in pairs(NetworkService.ActiveHosts) do
		clientObject:Close()
	end
end

function NetworkService.OnDestroy()
	NetworkService.CloseAll()
end

function NetworkService.Update(dt)
	for id, clientObject in pairs(NetworkService.ActiveHosts) do
		local event = clientObject.EnetHost:service(0)

		while event do
			if event.type == "connect" then
				clientObject.IsConnected = true
				clientObject.OnConnected:Invoke(event.peer)
			elseif event.type == "disconnect" then
				clientObject.IsConnected = false
				clientObject.OnDisconnected:Invoke(event.peer)
			elseif event.type == "receive" then
				clientObject.OnReceived:Invoke(event.data, event.peer)
			end

			event = clientObject.EnetHost:service(0)
		end

		clientObject.EnetHost:flush()
	end
end

return NetworkService