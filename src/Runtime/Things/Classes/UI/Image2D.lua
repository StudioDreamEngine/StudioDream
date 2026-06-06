local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Image2D: BaseGui
local Image2D = Things.Extend("BaseGui")
local DefaultIdentifier = Runtime.Resources.GetIdentifier("Internal/Icons/Studio.png")

function Image2D:new()
    Image2D.super.new(self)

    self.ImageFile = nil
    self.ImageRect = nil
    self.ImageQuad = nil
    
    self.ForegroundColor = Color.new(1)

    self:SetResource(DefaultIdentifier)
end

function Image2D:DefineAPI()
    Image2D.super.DefineAPI(self)

    self.Proxy.Icon("Image2D")
    self.Proxy.Property("Rect ImageRect","Resource Resource")
    self.Proxy.Group("Visuals","Resource","ImageRect")

    self.Proxy.MakeCreatable()
end

function Image2D:SetResource(Identifier)
    self.ImageFile, self.Resource = Runtime.Resources.LoadFromIdentifier(Identifier)

    local Width, Height = self.ImageFile:getDimensions()
    local Size = Vector2.new(Width, Height)

    self:SetImageRect(Rect.new(Vector2.zero, Size))
end

function Image2D:SetImageRect(NewRect)
    if (not self.ImageFile) then 
        print("Attempted to set image rect but cannot")
        return 
    end

    local Width, Height = self.ImageFile:getDimensions()
    local Size = Vector2.new(Width, Height)

    self.ImageRect = NewRect
    self.ImageQuad = Runtime.Backend2D.NewQuad(self.ImageRect, Size)
end

function Image2D:Draw()
    if (not self.ImageQuad) then return end -- TODO: Placeholder image

    local _,_,w,h = self.ImageQuad:getViewport()

    -- Proper scaling of images
    local ScaleX = self.AbsoluteSize.X/w
    local ScaleY = self.AbsoluteSize.Y/h

    Runtime.Backend2D.SetColor(self.ForegroundColor, 1-self.ForegroundTransparency)
    love.graphics.draw(self.ImageFile,self.ImageQuad,0,0,0,ScaleX,ScaleY)
end

return Image2D