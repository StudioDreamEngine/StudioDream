local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@class Image2D: Square
local Image2D = Things.Extend("Square")

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
    self.BackgroundTransparency = 1

    self.ScaleType = Enum.ScaleType.Stretch
    self.FilterType = Enum.FilterType.Pixelated

    self.Flipped = false
    self.ImageSize = Vector2.zero
    self.NineSlice = Rect.new(Vector2.zero, Vector2.zero)
    self.Slices = {}

    self.DefaultIdentifier = nil

    local IdentifierPath = (math.random(1,100) == 1) and "ImageEyes" or "ImageTemplate"

    self.DefaultIdentifier = Runtime.Resources.GetIdentifierFromID("Internal/Templates/"..IdentifierPath..".png")
    self:SetResource(self.DefaultIdentifier)
end

function Image2D:DefineAPI()
    Image2D.super.DefineAPI(self)

    self.Proxy.Icon("Image2D")
    self.Proxy.Property("Rect ImageRect","Resource Resource","Enum.FilterType FilterType","Rect NineSlice","boolean Flipped")
    self.Proxy.Group("Visuals","Resource","ImageRect","FilterType","NineSlice","Flipped")
    self.Proxy.MakeCreatable()
end

function Image2D:SetResource(Identifier)
    self.ImageFile, self.Resource = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID, "Image")
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
    self.ImageSize = Vector2.new(Width, Height)

    -- ImageRect is optional, if we dont find one, default to the image itself.
    self.ImageQuad = Runtime.Backend2D.NewQuad(self.ImageRect.Usable() and self.ImageRect or Rect.new(Vector2.zero, self.ImageSize), self.ImageSize)
    if self.NineSlice.Usable() then self:CreateSlices(self.ImageSize) end
end

function Image2D:CreateSlices(ImageSize)
    local NineSlice = self.NineSlice

    local SliceData = Renderer.Image.GetSlices(NineSlice, ImageSize)
    self.Slices = {}

    -- top 5 most ass code ever - bloctans
    for _, Slice in pairs(SliceData) do
        table.insert(self.Slices, {
            Size = Slice.Size,
            Offset = (Slice.Size * Slice.Pivot),
            Pivot = Slice.Pivot,
            Origin = Slice.Origin or Slice.Pos,
            Main = Slice.Main,
            StretchTo = Slice.StretchTo,
            Quad = Runtime.Backend2D.NewQuad(Rect.new(Slice.Pos, Slice.Size), ImageSize)
        })
    end
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
        local X,Y = self.ImageSize.X/2, self.ImageSize.Y/2

        love.graphics.translate(X,Y)
        love.graphics.scale((self.Flipped and -1 or 1),1)
        love.graphics.draw(self.ImageFile,self.ImageQuad,0,0,0,1,1,X,Y) -- Draw Image
        return
    end

    local BottomRight = (self.ImageSize - self.NineSlice.Max) + self.NineSlice.Min

    -- top 5 most ass code ever - bloctans
    for _, Slice in pairs(self.Slices) do
        self:SetColor("Foreground")

        local Pos = (Slice.Pivot * self.AbsoluteSize)
        local QScale = Vector2.one

        if Slice.Main then
            Pos = Pos + Slice.Origin
            QScale = (self.AbsoluteSize-BottomRight) ---@class Vector2
        elseif Slice.StretchTo then
            local Normal = Slice.StretchTo

            QScale = (self.AbsoluteSize-BottomRight) * Normal + ((Vector2.one - Normal) * Slice.Size)

            Pos = Pos + Slice.Origin
        end

        if Slice.Main or Slice.StretchTo then
            QScale = QScale / Slice.Size
        end

        love.graphics.draw(self.ImageFile, Slice.Quad, Pos.X, Pos.Y, 0, QScale.X, QScale.Y, Slice.Offset.X,Slice.Offset.Y)
    end
end

function Image2D:Draw()
    Image2D.super.Draw(self)
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