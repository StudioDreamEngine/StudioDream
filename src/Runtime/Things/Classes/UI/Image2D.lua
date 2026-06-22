local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Image2D: BaseGui
local Image2D = Things.Extend("BaseGui")
local DefaultIdentifier = Runtime.Resources.GetIdentifier("Internal/Icons/Studio.png")

local ScaleModes = {
        ["stretch"] = function(self) 
            local _,_,w,h = self.ImageQuad:getViewport()
            
            ScaleX = self.AbsoluteSize.X/w
            ScaleY = self.AbsoluteSize.Y/h

            love.graphics.scale(ScaleX, ScaleY)
        end,
        ["fit"] = function(self)
            local AbSize = self.AbsoluteSize
            local Width, Height = self.ImageFile:getDimensions()
            local HeightScale = AbSize.Y/Height
            local WidthScale = AbSize.X/Width

            love.graphics.scale((HeightScale/WidthScale > 1) and WidthScale or HeightScale)
        end
    }

function Image2D:new()
    Image2D.super.new(self)

    self.ImageFile = nil
    self.ImageRect = nil
    self.ImageQuad = nil
    
    self.ScaleType = "stretch"

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

    local Width, Height = self.ImageFile:getDimensions()
    local Size = Vector2.new(Width, Height)

    self:SetImageRect(Rect.new(Vector2.zero, Size))
end

function Image2D:SetImageRect(NewRect)
    if (not self.ImageFile) then 
        print("Attempted to set image rect but cannot")
        return 
    end

    local Width, Height = self.ImageFile:getDimensions()
    local Size = Vector2.new(Width, Height)

    self.ImageRect = NewRect
    self.ImageQuad = Runtime.Backend2D.NewQuad(self.ImageRect, Size)
end

function Image2D:UpdateAspect()
    local AbSize = self.AbsoluteSize
    local HeightScale = AbSize.Y/480
    local WidthScale = AbSize.X/640

    return (HeightScale/WidthScale > 1) and WidthScale or HeightScale
end

function Image2D:HandleScaleMode()
    ScaleModes[self.ScaleType](self)
end

function Image2D:Draw()
    if (not self.ImageQuad) then return end -- TODO: Placeholder image

    self:SetColor("Foreground")

    self:HandleScaleMode()
    love.graphics.draw(self.ImageFile,self.ImageQuad,0,0,0,1,1) -- Draw Image
end

return Image2D