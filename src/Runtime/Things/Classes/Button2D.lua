local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local Button2D = Things.Extend("BaseGui")

function Button2D:new()
    self.super:new()
    self.ImageFile = nil -- ImageThing for render maybe???
    self.BackgroundColor = Color.new(1)
    self.BackgroundTransparency = 0
    self.Explorer = {
        Visible = true,
        Icon = "picture"
    }
end

function Button2D:Draw()
    local Image = love.graphics.newImage(self.ImageFile or "Assets/EditorIcons/16/" .. self.Explorer.Icon .. ".png")
    local Size = Vector2.new(Image:getWidth(),Image:getHeight())
    local Background = love.graphics.rectangle("fill", 0,0, Size.X, Size.Y)
    local Image2 = love.graphics.draw(Image,0,0)
end

return Button2D