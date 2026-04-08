local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local ImagePrimative = Things.Extend("BaseGui")

function ImagePrimative:new()
    ImagePrimative.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "photo"
    }
    
    self.Image = nil

    self.Changed:Connect(function(_, New)
        self.ImageFile = Runtime.Backend2D.NewImage(New)
    end, "Image")
end

function ImagePrimative:Draw()
    if (not self.ImageFile) then return end -- TODO: Placeholder image

    -- Proper scaling of images
    local ScaleX = self.AbsoluteSize.X/self.ImageFile:getWidth()
    local ScaleY = self.AbsoluteSize.Y/self.ImageFile:getHeight()

    love.graphics.draw(self.ImageFile,0,0,0,ScaleX, ScaleY)
end

return ImagePrimative