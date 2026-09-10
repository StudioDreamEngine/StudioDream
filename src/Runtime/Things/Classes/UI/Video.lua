local Things = Runtime.Things

---@class Video: Thing
local Video = Things.Extend("Square")

function Video:new()
    Video.super.new(self)

    self.Resource = nil
    self.Video = nil
end

function Video:DefineAPI()
    Video.super.DefineAPI(self)

    self.Proxy.Property("Resource Resource")
    self.Proxy.Group("Video","Resource")

    --self.Proxy.MakeCreatable()
end

function Video:SetResource(Identifier)
    self.Video, self.Resource = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID, "Video")
    if (not self.Video) then return end
end

function Video:Update(dt)
    
end

function Video:Draw()
    Video.super.Draw(self)
    local Size = self.AbsoluteSize 
    
    if self.Video then
        print("coil")
        print(self.Video)
        love.graphics.translate(self.AbsolutePosition.X, self.AbsolutePosition.Y)
        love.graphics.draw(self.Video, 0,0, self.AbsoluteSize.X, self.AbsoluteSize.Y)
    end
end

return Video