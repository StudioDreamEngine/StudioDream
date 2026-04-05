local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local ImagePrimative = Things.Extend("BaseGui")
local Image

function ImagePrimative:New()
    self.ImageFile = nil
end

function ImagePrimative:Draw()
    local Size = self.AbsoluteSize
    
    Image = love.graphics.newImage(self.ImageFile)
    local width = Image:getWidth()
	local height = Image:getHeight()
	local quad = love.graphics.newQuad(0,0, width,height/2, width,height) -- Change this for propertie

    love.graphics.draw(Image,quad, Size.X,Size.Y)
end

return ImagePrimative