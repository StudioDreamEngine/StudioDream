local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
---@class Image2D
local Image2D = Things.Extend("BaseGui")

function Image2D:new()
    Image2D.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "photo"
    }
    
    self.Image = nil
end

function Image2D:SetImage(NewImage)
    self.Image = NewImage
    self.ImageFile = Runtime.Backend2D.NewImage(NewImage)
end

function Image2D:Draw()
    if (not self.ImageFile) then return end -- TODO: Placeholder image

    -- Proper scaling of images
    local ScaleX = self.AbsoluteSize.X/self.ImageFile:getWidth()
    local ScaleY = self.AbsoluteSize.Y/self.ImageFile:getHeight()

    love.graphics.draw(self.ImageFile,0,0,0,ScaleX, ScaleY)
end

return Image2D