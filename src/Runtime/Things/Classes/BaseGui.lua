local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local BaseGui = Things.Extend("Thing")

function BaseGui:GetAbsolutePosition()
    local Position = Vector2.zero

    -- TODO
end

function BaseGui:GetAbsoluteSize()
    local AbsoluteSize = self.Size.Offset
    local ParentSize = self:GetParentElement():GetAbsoluteSize()

    AbsoluteSize = AbsoluteSize + (ParentSize * self.Size.Scale)
end

function BaseGui:GetParentElement()
    return self:GetParentCallback(function(Object)
        return Object:IsA("BaseGui")
    end)
end

function BaseGui:GetDisplayUI()
    return self:GetParentCallback(function(Object)
        return Object:IsA("Viewport2D")
    end)
end

function BaseGui:Draw()
    error("BaseGui:Draw() is virtual and should not be called directly")
end

function BaseGui:New() 
    self.Size = Pivot2D.FromOffset(Vector2.one * 50)
    self.Position = Pivot2D.FromOffset(Vector2.one * 50)

    self.AbsolutePosition = Vector2.zero
    self.AbsoluteSize = Vector2.zero
end

function BaseGui:Update(dt) 
    self.AbsoluteSize = BaseGui:GetAbsoluteSize()
end

return BaseGui