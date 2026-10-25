local ImageScale = {
    [Enum.ScaleType.Stretch] = function(Scale) 
        return Vector2.new(Scale.X, Scale.Y)
    end,
    [Enum.ScaleType.LockAspect] = function(Scale)
        return Vector2.one * ((Scale.Y/Scale.X > 1) and Scale.X or Scale.Y)
    end,
    [Enum.ScaleType.Crop] = function(Scale)
        return Vector2.one * ((Scale.Y/Scale.X < 1) and Scale.X or Scale.Y)
    end
}

local function HandleDrawImage(Scale, ImageQuad, Size)
    love.graphics.scale(Scale.X, Scale.Y)
    local X,Y = Size.X/2, Size.Y/2

    love.graphics.translate(X,Y)
    love.graphics.draw(ImageQuad.File,ImageQuad.Quad,0,0,0,1,1,X,Y) -- Draw Image
end

return function(Info)
    local ImageQuad = Info.ImageQuad

    if (not ImageQuad) then return end -- TODO: Placeholder image

    local _,_, w,h = ImageQuad.Quad:getViewport()
    local ImageSize = Vector2.new(w,h)
    local Size = Info.Size

    local Scale = ImageScale[ImageQuad.ScaleType](Size/ImageSize)
    ImageSize = ImageSize * Scale

    Runtime.Backend2D.SetColor(Color)

    local PivotCenter = (Size/2) - (ImageSize/2)

    love.graphics.push()
    love.graphics.translate(PivotCenter.X, PivotCenter.Y)
    HandleDrawImage(Scale, ImageQuad, ImageSize)
    love.graphics.pop()

    love.graphics.setStencilMode("off")
end