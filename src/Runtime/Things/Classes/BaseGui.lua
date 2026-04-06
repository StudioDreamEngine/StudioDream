local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local BaseGui = Things.Extend("Thing")

function BaseGui:GetPositionInParent()
    local AbsolutePosition = self.Position.Offset - (self.Pivot * self.AbsoluteSize)
    local ParentElement = self:GetParentElement()

    if ParentElement then
        AbsolutePosition = AbsolutePosition + (self.Position.Scale * ParentElement.AbsoluteSize)
    end

    return AbsolutePosition
    -- TODO
end

function BaseGui:GetAbsoluteSize()
    local AbsoluteSize = self.Size.Offset
    local ParentElement = self:GetParentElement()

    if ParentElement then -- Only do this if we found a parent element
        AbsoluteSize = AbsoluteSize + (ParentElement.AbsoluteSize * self.Size.Scale)
    end
    
    return AbsoluteSize
end

-- Find the parent element rendering this object
function BaseGui:GetParentElement()
    return self:GetParentCallback(function(Object)
        return Object:IsA("BaseGui")
    end)
end

-- Find the parent Viewport2D rendering this object
function BaseGui:GetDisplayUI()
    return self:GetParentCallback(function(Object)
        return Object:IsA("Viewport2D")
    end)
end

function BaseGui:Draw()
    error("BaseGui:Draw() is virtual and should not be called directly")
end

function BaseGui:new() 
    BaseGui.super.new(self)

    self.Size = Pivot2D.FromOffset(50, 50)
    self.Position = Pivot2D.FromOffset(0, 0)

    self.BackgroundColor = Color.new(1)
    self.BackgroundTransparency = 0

    -- Used for stuff like text
    self.ForegroundTransparency = 0
    self.ForegroundColor = Color.new(0)

    self.AbsolutePosition = Vector2.zero
    self.AbsoluteSize = Vector2.zero

    self.Layer = 0
    self.Pivot = Vector2.zero -- TODO: Add functionality
end

function BaseGui:DrawStyle()
    Runtime.Backend2D.SetColor(self.BackgroundColor, 1-self.BackgroundTransparency)
    self:Draw()
    Runtime.Backend2D.SetColor(Color.new(1))
end

function BaseGui:Update(dt) 
    BaseGui.super.Update(self, dt)

    self.AbsoluteSize = self:GetAbsoluteSize()
end

return BaseGui