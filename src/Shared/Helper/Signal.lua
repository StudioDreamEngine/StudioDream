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
function Module:New(EventName, Blocking) --I had no idea you could define module functions with : -- You can, and yeah i should probably start using self
	---@class Signal
	local EventObject = {}
	local Events = {}
	
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
	
	---@return SignalConnection
	local function ConnectEvent(func, listener, EventId)
		-- I bet theres a faster way but whatever
		---@class SignalConnection
		local SingleEventObject = {}

		SingleEventObject.EventId = EventId
		SingleEventObject.EventName = EventName

		function SingleEventObject:Disconnect() 
			--print(SingleEventObject.EventName.." Disconnected")
			Events[SingleEventObject.EventId] = nil
			SingleEventObject = {}
		end

		return SingleEventObject
	end

	function EventObject:Destroy()
		Events = {}
		EventObject = {}
	end
	
	function EventObject:Connect(func,listener) 
		local EventId = NewEventID()
		
		local SingleEventObject = ConnectEvent(func, listener, EventId)
		
		Events[EventId] = {func,listener,SingleEventObject}
		return SingleEventObject
	end
	
	function EventObject:ConnectOnce(func,listener) 
		local EventId = NewEventID()

		local SingleEventObject = ConnectEvent(func, listener, EventId)

		Events[EventId] = {func,listener,SingleEventObject,true}
		return SingleEventObject
	end

	function EventObject.Invoke(MatchingListener, ...)
		--print("Call to invoke",EventName)
		
		--[[
			v[1] - Callback function
			v[2] - Listener ID to match for
			v[3] - Event object
			v[4] - Call only once then disconnect
		]]
		for EventID,v in pairs(Events) do 
			
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
				for i = 1,Args.n do 
					if (not Args[i]) then 
						Args[i] = nil 
					end 
				end

				-- Ok rant over
				Scheduler.NewTask(v[1], unpack(Args))
				
				if v[4] then v[3]:Disconnect() end
			end
		end
	end

	return EventObject
end

return Module