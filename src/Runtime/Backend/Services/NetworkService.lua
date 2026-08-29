local NetworkService = {}

local enet = require("enet")

local Types = {}

local function RegisterType(name, check, encode, decode)
	Types[name] = {
		Check = check,
		Encode = encode,
		Decode = decode,
	}
end

local function IsArray(tbl)
	local count = 0
	for k in pairs(tbl) do
		if type(k) ~= "number" then
			return false
		end
		count = count + 1
	end

	return count == #tbl
end

local function Serialize(value)
	local valueType = type(value)

	if valueType == "nil" then
		return "N"
	end

	if valueType == "boolean" then
		return value and "B1" or "B0"
	end

	if valueType == "number" then
		return "D" .. tostring(value) .. ";"
	end

	if valueType == "string" then
		return "S" .. #value .. ":" .. value
	end

	if valueType == "table" then
		for name, data in pairs(Types) do
			if data.Check(value) then
				local encoded = data.Encode(value)
				return "C" .. name .. ":" .. #encoded .. ":" .. encoded
			end
		end

		local buffer = {
			IsArray(value) and "A" or "T",
		}

		if IsArray(value) then
			for i = 1, #value do
				buffer[#buffer + 1] = Serialize(value[i])
			end
		else
			for k, v in pairs(value) do
				buffer[#buffer + 1] = Serialize(k)
				buffer[#buffer + 1] = Serialize(v)
			end
		end

		buffer[#buffer + 1] = "E"

		return table.concat(buffer)
	end

	error("Unsupported network value: " .. valueType)
end

local function Deserialize(data, index)
	index = index or 1

	local tag = data:sub(index, index)
	index = index + 1

	if tag == "N" then
		return nil, index
	end

	if tag == "B" then
		return data:sub(index, index) == "1", index + 1
	end

	if tag == "D" then
		local finish = data:find(";", index)
		local number = tonumber(data:sub(index, finish - 1))

		return number, finish + 1
	end

	if tag == "S" then
		local finish = data:find(":", index)
		local size = tonumber(data:sub(index, finish - 1))

		local start = finish + 1
		local value = data:sub(start, start + size - 1)

		return value, start + size
	end

	if tag == "C" then
		local finish = data:find(":", index)
		local name = data:sub(index, finish - 1)

		local sizeEnd = data:find(":", finish + 1)
		local size = tonumber(data:sub(finish + 1, sizeEnd - 1))

		local start = sizeEnd + 1
		local value = data:sub(start, start + size - 1)

		local typeData = Types[name]

		if not typeData then
			error("Unknown network type: " .. name)
		end

		return typeData.Decode(value), start + size
	end

	if tag == "A" then
		local array = {}

		while data:sub(index, index) ~= "E" do
			local value
			value, index = Deserialize(data, index)

			array[#array + 1] = value
		end

		return array, index + 1
	end

	if tag == "T" then
		local tbl = {}

		while data:sub(index, index) ~= "E" do
			local key
			key, index = Deserialize(data, index)

			local value
			value, index = Deserialize(data, index)

			tbl[key] = value
		end

		return tbl, index + 1
	end

	error("Invalid network packet at " .. tostring(index))
end

function NetworkService.RegisterType(name, check, encode, decode)
	RegisterType(name, check, encode, decode)
end

NetworkService.RegisterType("mat4", function(value)
	return type(value) == "table" and value ~= nil and value == nil
end, function(value)
	return love.data.pack(
		"string",
		"ffffffffffffffff",
		value,
		value,
		value,
		value,
		value,
		value,
		value,
		value,
		value,
		value,
		value,
		value,
		value,
		value,
		value,
		value
	)
end, function(data)
	local matrix = { love.data.unpack("ffffffffffffffff", data) }
	table.remove(matrix)

	if _3DreamEngine and _3DreamEngine.mat4 then
		return _3DreamEngine.mat4(matrix)
	end

	return matrix
end)

local function Pack(data)
	return Serialize(data)
end

local function Unpack(data)
	if not data or data == "" then
		return nil
	end
	return Deserialize(data, 1)
end

local threadCode = [[
	local url, method, reqData, isJson, customHeaders = ...
	local https = require("https")
	
	local options = { 
		method = method or "GET",
		headers = {}
	}
	
	if isJson then
		options.headers["Content-Type"] = "application/json"
	end
	
	if customHeaders and type(customHeaders) == "table" then
		for k, v in pairs(customHeaders) do
			options.headers[k] = v
		end
	end
	
	if reqData then
		options.data = reqData
	end
	
	local code, body, headers = https.request(url, options)
	
	love.thread.getChannel("https_responses"):push({
		url = url,
		code = code,
		body = body
	})
]]
function NetworkService.Init()
	love.math.setRandomSeed(os.time())
	NetworkService.ActiveHosts = {}
	NetworkService.ActiveRequests = {}
	NetworkService.ResponseChannel = love.thread.getChannel("https_responses")
end

function NetworkService.Fetch(url, method, data, headers, callback)
	local thread = love.thread.newThread(threadCode)
	local sendData = data
	local isJson = false

	if type(data) == "table" then
		isJson = true
		if love.data and love.data.encode then
			sendData = love.data.encode("string", "json", data)
		end
	end

	thread:start(url, method, sendData, isJson, headers)
	table.insert(NetworkService.ActiveRequests, {
		Thread = thread,
		Callback = callback,
		Url = url,
		IsJson = isJson,
	})
end

function NetworkService.CreateServer(port, maxClients)
	local id = "S_" .. port

	if NetworkService.ActiveHosts[id] then
		return NetworkService.ActiveHosts[id]
	end

	local host = enet.host_create("*:" .. port, maxClients or 32, 2)

	local server = {
		Id = id,
		EnetHost = host,
		IsServer = true,

		OnConnected = Signal:New("OnConnected"),
		OnDisconnected = Signal:New("OnDisconnected"),
		OnReceived = Signal:New("OnReceived"),
	}

	function server:SendTo(peer, data, reliable)
		if not peer then
			return
		end
		peer:send(Pack(data), reliable and 0 or 1, reliable and "reliable" or "unreliable")
	end

	function server:Broadcast(data, reliable)
		self.EnetHost:broadcast(Pack(data), reliable and 0 or 1, reliable and "reliable" or "unreliable")
	end

	function server:Close()
		if self.EnetHost then
			self.EnetHost:destroy()
		end
		NetworkService.ActiveHosts[self.Id] = nil
		collectgarbage("collect")
	end

	NetworkService.ActiveHosts[id] = server
	return server
end

local function GenerateId()
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local result = ""
	for i = 1, 32 do
		local index = love.math.random(1, #chars)
		result = result .. chars:sub(index, index)
	end
	return result
end

function NetworkService.Connect(address)
	local id
	repeat
		id = GenerateId()
	until not NetworkService.ActiveHosts[id]

	local host = enet.host_create(nil, 1, 2)
	local peer = host:connect(address, 2)

	local client = {
		Id = id,
		EnetHost = host,
		ServerPeer = peer,
		IsServer = false,
		IsConnected = false,

		OnConnected = Signal:New("OnConnected"),
		OnDisconnected = Signal:New("OnDisconnected"),
		OnReceived = Signal:New("OnReceived"),

		_PendingRequests = {},
		_RequestId = 0,
	}

	function client:Send(data, reliable)
		if not self.ServerPeer or not self.IsConnected then
			return
		end
		self.ServerPeer:send(Pack(data), reliable and 0 or 1, reliable and "reliable" or "unreliable")
	end

	function client:Request(data)
		if not self.IsConnected then
			return nil
		end

		self._RequestId = self._RequestId + 1
		local reqId = self._RequestId
		data._requestId = reqId

		local thread = coroutine.running()
		if not thread then
			error("Request must run inside coroutine")
		end

		self._PendingRequests[reqId] = thread
		self:Send(data, true)

		return coroutine.yield()
	end

	function client:Close()
		if self.ServerPeer then
			self.ServerPeer:disconnect()
			self.EnetHost:flush()
		end

		if self.EnetHost then
			self.EnetHost:service(100)
			self.EnetHost:destroy()
		end

		NetworkService.ActiveHosts[self.Id] = nil
		collectgarbage("collect")
	end

	NetworkService.ActiveHosts[id] = client
	return client
end

function NetworkService.CloseAll()
	for _, host in pairs(NetworkService.ActiveHosts) do
		host:Close()
	end
end

function NetworkService.OnDestroy()
	NetworkService.CloseAll()
end

function NetworkService.Update(dt)
	for _, host in pairs(NetworkService.ActiveHosts) do
		local event = host.EnetHost:service(0)

		while event do
			if event.type == "connect" then
				if not host.IsServer then
					host.IsConnected = true
				end
				host.OnConnected:Invoke(event.peer)
			elseif event.type == "disconnect" then
				if not host.IsServer then
					host.IsConnected = false
				end
				host.OnDisconnected:Invoke(event.peer)
			elseif event.type == "receive" then
				local data = Unpack(event.data)
				local handled = false

				if not host.IsServer and type(data) == "table" and data._requestId then
					local thread = host._PendingRequests[data._requestId]
					if thread then
						host._PendingRequests[data._requestId] = nil
						data._requestId = nil
						handled = true
						coroutine.resume(thread, data)
					end
				end

				if not handled then
					host.OnReceived:Invoke(data, event.peer, event.channel)
				end
			end

			event = host.EnetHost:service(0)
		end

		host.EnetHost:flush()
	end

	local response = NetworkService.ResponseChannel:pop()
	while response do
		for i = #NetworkService.ActiveRequests, 1, -1 do
			local req = NetworkService.ActiveRequests[i]
			if req.Url == response.url then
				if req.Callback then
					local finalBody = response.body
					if req.IsJson and love.data and love.data.decode then
						pcall(function()
							finalBody = love.data.decode("string", "json", response.body)
						end)
					end
					req.Callback(response.code, finalBody)
				end
				table.remove(NetworkService.ActiveRequests, i)
				break
			end
		end
		response = NetworkService.ResponseChannel:pop()
	end
end

return NetworkService
