local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Image2D: BaseGui
local Image2D = Things.Extend("BaseGui")
local DefaultIdentifier = Runtime.Resources.GetIdentifierFromID("Internal/Icons/Studio.png")

Image2D.ImageScale = {
    [Enum.ScaleType.Stretch] = function(self, ContainerSize, ImageSize) 
        ScaleX = ContainerSize.X/ImageSize.X
        ScaleY = ContainerSize.Y/ImageSize.Y

        return Vector2.new(ScaleX, ScaleY)
    end,
    [Enum.ScaleType.LockAspect] = function(self, ContainerSize, ImageSize)
        local HeightScale = ContainerSize.Y/ImageSize.Y
        local WidthScale = ContainerSize.X/ImageSize.X

        return Vector2.one * ((HeightScale/WidthScale > 1) and WidthScale or HeightScale)
    end,
    [Enum.ScaleType.Crop] = function(self, ContainerSize, ImageSize)
        local HeightScale = ContainerSize.Y/ImageSize.Y
        local WidthScale = ContainerSize.X/ImageSize.X

        return Vector2.one * ((HeightScale/WidthScale < 1) and WidthScale or HeightScale)
    end
}

function Image2D:new()
    Image2D.super.new(self)

    self.ImageFile = nil
    self.ImageRect = nil ---@class Rect
    self.ImageQuad = nil
    
    self.CornerRadius = 0

    self.ScaleType = Enum.ScaleType.Stretch

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
    self.ImageFile, self.Resource = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID)

    self:RefreshQuad() -- Only refresh the quad object
end

function Image2D:RefreshQuad()
    local Width, Height = self.ImageFile:getDimensions()
    local Size = Vector2.new(Width, Height)

    -- ImageRect is optional, if we dont find one, default to the image itself.
    self.ImageQuad = Runtime.Backend2D.NewQuad(self.ImageRect or Rect.new(Vector2.zero, Size), Size)
end

function Image2D:SetImageRect(NewRect)
    if (not self.ImageFile) then 
        print("Attempted to set image rect but cannot")
        return 
    end

    self.ImageRect = NewRect
    self:RefreshQuad()
end

function Image2D:Draw()
    if (not self.ImageQuad) then return end -- TODO: Placeholder image

    Profiler.Start("Image2D Draw")

    local _,_, w,h = self.ImageQuad:getViewport()
    local ImageSize = Vector2.new(w,h)
    local Size = self.AbsoluteSize

    local Scale = self.ImageScale[self.ScaleType](self, self.AbsoluteSize, ImageSize)
    ImageSize = ImageSize * Scale

    if self.CornerRadius > 0 then
        love.graphics.setStencilMode("draw", 255)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", 0,0, Size.X, Size.Y, self.CornerRadius, self.CornerRadius)

        love.graphics.setStencilMode("test", 255)
    end

    self:SetColor("Foreground")

    local PivotCenter = (Size/2) - (ImageSize/2)

    love.graphics.draw(self.ImageFile,self.ImageQuad,PivotCenter.X, PivotCenter.Y,0,Scale.X,Scale.Y) -- Draw Image
    love.graphics.setStencilMode("off")

    Profiler.End()
end

return Image2D