local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@class Image2D: BaseGui
local Image2D = Things.Extend("BaseGui")
local DefaultIdentifier = Runtime.Resources.GetIdentifierFromID("Internal/Icons/Studio.png")

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

function Image2D:new()
    Image2D.super.new(self)

    self.ImageFile = nil ---@class Texture
    self.ImageRect = Rect.new(Vector2.zero, Vector2.zero) ---@class Rect
    self.ImageQuad = nil
    
    self.CornerRadius = 0
    self.ForegroundColor = Color.new(1)

    self.ScaleType = Enum.ScaleType.Stretch
    self.FilterType = Enum.FilterType.Pixelated

    self.NineSlice = Rect.new(Vector2.zero, Vector2.zero)
    self.Slices = {}

    self:SetResource(DefaultIdentifier)
end

function Image2D:DefineAPI()
    Image2D.super.DefineAPI(self)

    self.Proxy.Icon("Image2D")
    self.Proxy.Property("Rect ImageRect","Resource Resource","Enum.FilterType FilterType","Rect NineSlice")
    self.Proxy.Group("Visuals","Resource","ImageRect","FilterType","NineSlice")
    self.Proxy.MakeCreatable()
end

function Image2D:SetResource(Identifier, Reload)
    self.ImageFile, self.Resource = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID, Reload)
    if (not self.ImageFile) then return end

    self:RefreshQuad() -- Only refresh the quad object
    self.ImageFile:setFilter(self.FilterType, self.FilterType)
end

function Image2D:SetFilterType(NewType)
    self.FilterType = NewType
    self.ImageFile:setFilter(NewType, NewType) -- Only set filter type here
end

function Image2D:RefreshQuad()
    local Width, Height = self.ImageFile:getDimensions()
    local ImageSize = Vector2.new(Width, Height)

    -- ImageRect is optional, if we dont find one, default to the image itself.
    self.ImageQuad = Runtime.Backend2D.NewQuad(self.ImageRect.Usable() and self.ImageRect or Rect.new(Vector2.zero, ImageSize), ImageSize)
    if self.NineSlice.Usable() then self:CreateSlices(ImageSize) end
end

function Image2D:CreateSlices(ImageSize)
    Profiler.Start("Image2D - Create Slices")
    local NineSlice = self.NineSlice

    local SliceData = Renderer.Image.GetSlices(NineSlice, ImageSize)
    self.Slices = {}

    for _, Slice in pairs(SliceData) do
        table.insert(self.Slices, {
            Pos = Slice.Pos,
            SizeDbg = Slice.Size,
            Quad = Runtime.Backend2D.NewQuad(Rect.new(Slice.Pos, Slice.Size), ImageSize)
        })
    end
    Profiler.End()
end

function Image2D:SetNineSlice(NewNineSlice)
    self.NineSlice = NewNineSlice
    self:RefreshQuad()
end

function Image2D:SetImageRect(NewRect)
    if (not self.ImageFile) then print("Attempted to set image rect but cannot") return end

    self.ImageRect = NewRect
    self:RefreshQuad()
end

function Image2D:HandleDrawImage(Scale)
    if (not self.NineSlice.Usable()) then
        love.graphics.scale(Scale.X, Scale.Y)
        love.graphics.draw(self.ImageFile,self.ImageQuad,0,0,0) -- Draw Image
        return
    end

    for _, Slice in pairs(self.Slices) do
        Profiler.Start("Image2D - Draw Slices")
        self:SetColor("Foreground")
        love.graphics.draw(self.ImageFile, Slice.Quad, Slice.Pos.X, Slice.Pos.Y, 0)

        if FLAGS.DebugDraw then
            love.graphics.setColor(0,0,1)
            love.graphics.rectangle("line", Slice.Pos.X, Slice.Pos.Y, Slice.SizeDbg.X, Slice.SizeDbg.Y)
        end
        Profiler.End()
    end
end

function Image2D:Draw()
    if (not self.ImageQuad) then return end -- TODO: Placeholder image

    local _,_, w,h = self.ImageQuad:getViewport()
    local ImageSize = Vector2.new(w,h)
    local Size = self.AbsoluteSize

    local Scale = ImageScale[self.ScaleType](Size/ImageSize)
    ImageSize = ImageSize * Scale

    if self.CornerRadius > 0 then
        love.graphics.setStencilMode("draw", 255)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", 0,0, Size.X, Size.Y, self.CornerRadius, self.CornerRadius)
        love.graphics.setStencilMode("test", 255)
    end

    self:SetColor("Foreground")

    local PivotCenter = (Size/2) - (ImageSize/2)

    love.graphics.push()
    love.graphics.translate(PivotCenter.X, PivotCenter.Y)
    self:HandleDrawImage(Scale)
    love.graphics.pop()

    love.graphics.setStencilMode("off")
end

return Image2D