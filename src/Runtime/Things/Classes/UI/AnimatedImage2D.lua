local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the constraint system
---@class AnimatedImage2D: Image2D
local AnimatedImage2D = Things.Extend("Image2D")

function AnimatedImage2D:new()
    AnimatedImage2D.super.new(self)

    self.CurrentPlaying = nil
    self.DoesLoop = true
    self.Playing = false
    self.Reverse = false
    self.FramesPerSecond = 8
    self.FrameIn = 1
    self.Direction = 1
    self.StorageAnimations = {}
    self.OnEnd = Signal:New("AnimatedImage2DEndSignal")
end

function AnimatedImage2D:DefineAPI()
    AnimatedImage2D.super.DefineAPI(self)
    self.Proxy.MakeCreatable()
end

function AnimatedImage2D:StorageAnimation(Name,Animation)
    local AnimatedAnimation = {}
    AnimatedAnimation.Accumulator = 0
    AnimatedAnimation.Frames = Animation
    self.StorageAnimations[Name] = AnimatedAnimation
end

function AnimatedImage2D:GetStoragedAnimationByName(Name)
    return self.StorageAnimations[Name]
end

function AnimatedImage2D:Play(Animation)
    if Animation then
        self.CurrentPlaying = self:GetStoragedAnimationByName(Animation)
    end
    self.Playing = true
end

function AnimatedImage2D:Pause()
    self.Playing = false
end

function AnimatedImage2D:Stop()
    self.Playing = false
    self.FrameIn = 1
    self:SetFrameByFrameIn(self.FrameIn)
end

function AnimatedImage2D:SetFrameByFrameIn(FrameIn)
    if not self.CurrentPlaying then return end
    local frame = self.CurrentPlaying.Frames[FrameIn]
    local NewSize = Vector2.new(self.ImageRect.Size.X*frame.X,self.ImageRect.Size.Y*frame.Y)
	local NewRect = Rect.new(NewSize,self.ImageRect.Size)
	self:SetImageRect(NewRect)
end

function AnimatedImage2D:RenderCurrentAnimation(dt)
	local AnimationToRender = self.CurrentPlaying
	AnimationToRender.Accumulator = AnimationToRender.Accumulator + dt * self.FramesPerSecond

	if AnimationToRender.Accumulator >= 1 then
		AnimationToRender.Accumulator = AnimationToRender.Accumulator - 1
		self.FrameIn = self.FrameIn + self.Direction
        print(self.FrameIn)
		if self.FrameIn > #AnimationToRender.Frames or self.FrameIn < 1 then
			if self.Reverse then
				self.Direction = self.Direction * -1
				self.FrameIn = self.FrameIn + self.Direction
			elseif self.DoesLoop then
				self.FrameIn = 1
			else
				self.CurrentPlaying = nil
				self.OnEnd.Invoke()
				return
			end
		end
	end

	self:SetFrameByFrameIn(self.FrameIn)
end

function AnimatedImage2D:Update(dt)
    if self.CurrentPlaying ~= nil or self.Playing ~= false then 
        self:RenderCurrentAnimation(dt)
    end
end

return AnimatedImage2D