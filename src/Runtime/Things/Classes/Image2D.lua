local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local ImagePrimative = Things.Extend("BaseGui")
local Image

function ImagePrimative:New()
    self.super.New(self)
    self.Icon = "photo"
    self.ImageFile = nil
    self.Position = Vector2.new(0,0)
end

function ImagePrimative:Draw()
    Image = love.graphics.newImage(self.ImageFile)

    love.graphics.draw(Image,Position.X,Position.Y)
end

return ImagePrimative