local AnimTwoDee = {}

local PlayingAnimations = {}

function AnimTwoDee:CreateAnim(Object,Info,Size)
	local AnimObject = {}
	
	AnimObject.Playing = false
	AnimObject.DoesLoop = false
	AnimObject.Reverse = false
	AnimObject.FPS = 8
	AnimObject.Frame = 1
	AnimObject.Frames = Info
	AnimObject.Direction = 1
	AnimObject.Accumulator = 0
	AnimObject.FrameSize = Size or Object.ImageRectSize
	
	AnimObject.OnEnd = _G.Signal:new()
	
	local function Update()
		if not PlayingAnimations[Object] then
			PlayingAnimations[Object] = {
				Current = nil,
				Animations = {}
			}
		end
		if not table.find(PlayingAnimations[Object].Animations,AnimObject) then
			table.insert(PlayingAnimations[Object].Animations,AnimObject)
		end
		
	end
	
	function AnimObject:Play()
		AnimObject.Frame = 1
		AnimObject.Accumulator = 0
		AnimObject.Playing = true
		AnimObject:SetFrameSize(AnimObject.FrameSize)
		PlayingAnimations[Object].Current = AnimObject
		print(PlayingAnimations[Object].Current)
		Update()
	end
	
	function AnimObject:Pause()
		AnimObject.Playing = false
	end
	
	function AnimObject:SetFrameSize(Vecto2)
		Object.ImageRectSize = Vecto2
		self.FrameSize = Vecto2
	end	
	
	function AnimObject:SetFrame(Frame)
		AnimObject.Frame = Frame
	end
	
	function AnimObject:Stop()
		AnimObject.Playing = false
		AnimObject.Frame = 1
	end
	
	function AnimObject:Destroy()
		PlayingAnimations[Object] = nil
	end
	
	return AnimObject
end

function AnimTwoDee:Update(dt)
	for img, wrapper in pairs(PlayingAnimations) do
		if wrapper.Current == nil then return end
		local BeforeState = wrapper
		local state = wrapper.Current
		if not state.Playing then return end
		state.Accumulator = state.Accumulator + dt * state.FPS

		if state.Accumulator >= 1 then
			state.Accumulator = state.Accumulator - 1

			state.Frame = state.Frame + state.Direction

			if state.Frame > #state.Frames or state.Frame < 1 then
				if state.Reverse then
					state.Direction = state.Direction * -1
					state.Frame = state.Frame + state.Direction
				elseif state.DoesLoop then
					state.Frame = 1
				else
					BeforeState.Current = nil
					state.OnEnd.Invoke()
					return
				end
			end
		end

		local frame = state.Frames[state.Frame]
		
		local NewRect = Rect.new(Vector2.new(frame.X * state.FrameSize.X,frame.Y * state.FrameSize.Y),state.FrameSize)
		img:SetImageRect(NewRect)
	end
end

return AnimTwoDee