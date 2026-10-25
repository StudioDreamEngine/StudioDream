-- Handles the texture and quad for an image
---@class ImageQuad
local ImageQuad = Object:extend()

function ImageQuad:new(Resource)
    self.Quad = nil
    self.Image = Resource

    self.ScaleType = Enum.ScaleType.Stretch
    self:SetupQuad()
end

function ImageQuad:SetupQuad(Rect)
    local CanUseRect = (Rect and Rect.Usable())
    local Width, Height = self.Image:getDimensions()
    local ImageSize = Vector2.new(Width, Height)

    self.Quad = Runtime.Backend2D.NewQuad(CanUseRect and Rect or Rect.new(Vector2.zero, ImageSize), ImageSize)
end

return ImageQuad