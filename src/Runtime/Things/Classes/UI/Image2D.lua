local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Image2D: BaseGui
local Image2D = Things.Extend("BaseGui")

function Image2D:new()
    Image2D.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "photo"
    }
    
    self.Image = nil
    self.ImageRect = nil
    
    self.ImageQuad = nil

    self.Proxy.Property("Rect ImageRect")
end

function Image2D:SetImage(NewImage)
    self.Image = NewImage
    self.ImageFile = Runtime.Backend2D.NewImage(NewImage)

    local Width, Height = self.ImageFile:getDimensions()
    local Size = Vector2.new(Width, Height)

    self.ImageRect = Rect.new(Vector2.zero, Size)
    self.ImageQuad = Runtime.Backend2D.NewQuad(self.ImageRect, Size)
end

function Image2D:Draw()
    if (not self.ImageFile) then return end -- TODO: Placeholder image

    -- Proper scaling of images
    local ScaleX = self.AbsoluteSize.X/self.ImageFile:getWidth()
    local ScaleY = self.AbsoluteSize.Y/self.ImageFile:getHeight()

    love.graphics.draw(self.ImageFile,self.ImageQuad,0,0,0,ScaleX,ScaleY)
end

return Image2D