--[[
	Bloctans 2025

	Lua implementation of events, with listeners added to allow for one event to have more customizability
	Edited to use the Galvanic Lua Scheduler
]]

local Module = {}

--[[
	TODO
	Basically events that block execution until all connections are done
]]
function Module:NewBlocking(EventName) return Module:New(EventName, true) end

--[[
	Normal Async event
]]
---@return Signal
function Module:New(EventName, Debug) --I had no idea you could define module functions with : -- You can, and yeah i should probably start using self
	---@class Signal
	local EventObject = {}
	local Events = {}

	EventObject.Type = "Signal"
	
	local function NewEventID() 
		return CreateUUID()
	end
	
	function EventObject:DisconnectWithListener(Listener)
		for i,v in pairs(Events) do
			if v[2] == Listener then
				Events[i] = nil
			end
		end
	end

	function EventObject:Wait()
		local Invoked = false
		EventObject:ConnectOnce(function() Invoked = true end)

		repeat Scheduler.Yield() until Invoked
	end

	function EventObject:DisconnectAll()
		for _, Event in pairs(Events) do
			Event[3]:Disconnect() 
		end

		table.clear(Events)
	end
	
	---@return SignalConnection
	local function ConnectEvent(func, listener, EventId)
		-- I bet theres a faster way but whatever
		---@class SignalConnection
		local SingleEventObject = {}

		SingleEventObject.Type = "SignalConnection"
		SingleEventObject.EventId = EventId
		SingleEventObject.EventName = EventName
		SingleEventObject.AlreadyDisconnected = false

		function SingleEventObject:Disconnect() 
			assert(SingleEventObject.EventId, "Attempted to disconnect already-disconnected Signal.")
			if SingleEventObject.AlreadyDisconnected then return end
			
			SingleEventObject.AlreadyDisconnected = true

			Events[SingleEventObject.EventId] = nil
			SingleEventObject = {}
		end

		return SingleEventObject
	end

	function EventObject:Destroy()
		table.clear(Events)
		EventObject = {}
	end
	
	function EventObject:Connect(func,listener) 
		local EventId = NewEventID()
		local SingleEventObject = ConnectEvent(func, listener, EventId)
		
		Events[EventId] = {func,listener,SingleEventObject,false,false}
		return SingleEventObject
	end

	function EventObject:ConnectDeferred(func,listener) 
		local EventId = NewEventID()
		local SingleEventObject = ConnectEvent(func, listener, EventId)
		
		Events[EventId] = {func,listener,SingleEventObject,false,true}
		return SingleEventObject
	end
	
	function EventObject:ConnectOnce(func,listener) 
		local EventId = NewEventID()
		local SingleEventObject = ConnectEvent(func, listener, EventId)

		Events[EventId] = {func,listener,SingleEventObject,true}
		return SingleEventObject
	end

	function EventObject.Invoke(MatchingListener, ...)
		Utils.AssertType(Events, "table")
		
		--[[
			v[1] - Callback function
			v[2] - Listener ID to match for
			v[3] - Event object
			v[4] - Call once
			v[5] - Call deferred
		]]
		local Success, Message = pcall(function(MatchingListener, ...)
			local CurrentEvents = table.clone(Events) -- Certain events will break the pairs iterator if a new one is added during the call

			for EventID,v in pairs(CurrentEvents) do 
				
				-- If the listener ID doesnt exist, automatically return true.
				-- otherwise, only return true if the listener id is the same as the invoked listener id
				local DoesMatch = false
				
				if (not v[2]) or (v[2] == MatchingListener) then -- No matching listener or id
					DoesMatch = true
				end
				
				if DoesMatch then
					-- Pack our tuple, add the MatchingListener then Unpack it
					-- I know {...} exists, however grabbing table length seems to fail, 
					-- so to prevent more shitty code i have to use the n value
					local Args = table.pack(...)

					table.insert(Args, MatchingListener)
					
					-- When the table is packed, it ignores any nil args, so for unpacking to
					-- work we have to nil any indexes that arent nil. 
					-- (persumably internally when you nil an index it isnt actually removed until the next collection round but idk)
					for i = 1,Args.n do 
						if (not Args[i]) and (type(Args[i]) ~= "boolean") then 
							Args[i] = nil 
						end 
					end

					-- Ok rant over
					if v[5] then
						Scheduler.QueueTask(v[1], unpack(Args))
					else
						Scheduler.NewTask(v[1], unpack(Args))
					end
					
					if v[4] then v[3]:Disconnect() end
				end
			end
		end, MatchingListener, ...)

		if (not Success) then
			print("Error while invoking "..EventName..", "..Message)
			printVerbose(Events)
		end
	end

	return EventObject
end

return Module