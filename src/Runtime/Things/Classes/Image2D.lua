local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local ImagePrimative = Things.Extend("BaseGui")
local Image

function ImagePrimative:new()
    ImagePrimative.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "photo"
    }
    
    self.ImageFile = nil
end

function ImagePrimative:Draw()
    Image = love.graphics.newImage(self.ImageFile)

    love.graphics.draw(Image,0,0)
end

return ImagePrimative