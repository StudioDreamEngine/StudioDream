local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
---@class BaseGui: Thing
local BaseGui = Things.Extend("Thing")

function BaseGui:GetOffsetPosition()
    local PositionProp = self:GetProperty("Position")

    local Position = PositionProp.Offset - (self.Pivot * self.AbsoluteSize)
    local ParentElement = self:GetParentElement()

    if ParentElement then
        Position = Position + (PositionProp.Scale * ParentElement.AbsoluteSize)
    end

    return Position
end

function BaseGui:GetAbsolutePosition()
    local ParentElement = self:GetParentElement()
    local Position = self:GetOffsetPosition()

    if ParentElement then
        -- we need to now make sure the parent element is displaying to the same viewport
        local SameDisplayUI = (ParentElement:GetDisplayUI() == self:GetDisplayUI())

        -- If it isnt, stop here, dont get the position of the next one
        if (not SameDisplayUI) then 
            return Position 
        end

        Position = Position + ParentElement.AbsolutePosition
    end

    return Position
end

function BaseGui:GetRect()
    return Rect.new(self.AbsolutePosition, self.AbsoluteSize)
end

-- Get true position from display point on part or the screen
function BaseGui:GetDisplayPosition()
    local ParentElement = self:GetParentElement()
    local Position = self:GetOffsetPosition()

    if ParentElement then
        Position = Position + ParentElement:GetDisplayPosition()
    end

    return Position
end

--[[function BaseGui:GetContentSize()
    local Size = Vector2.zero

    for _, v in pairs(self:GetChildren()) do
        if v:IsA("BaseGui") then
            local AbsoluteEnd = v.Position.Offset + v.AbsoluteSize

            if AbsoluteEnd.X > Size.X and AbsoluteEnd.Y > Size.Y then
                Size = AbsoluteEnd
            end
        end
    end

    return Size
end]]

function BaseGui:GetAbsoluteSize()
    local AbsoluteSize = self.Size.Offset
    local ParentElement = self:GetParentElement()

    if ParentElement then -- Only do this if we found a parent element
        local Scale = (ParentElement.AbsoluteSize * self.Size.Scale)

        if self.SquareAxis then
            Scale = Vector2.one * Scale[self.SquareAxis]
        end
    
        AbsoluteSize = AbsoluteSize + Scale
    end

    return AbsoluteSize
end

-- Find the parent element rendering this object, not really needed
function BaseGui:GetParentElement()
    return (self.Parent and self.Parent:IsA("BaseGui")) and self.Parent
end

-- Find the parent Viewport2D rendering this object
-- TODO: Viewport2D should provide this directly to the object when the display list is created
function BaseGui:GetDisplayUI()
    return self:FindFirstAncestorWithClass("Viewport")
end

function BaseGui:Draw()
    error("BaseGui:Draw() is virtual and should not be called directly (from: "..self.Name..")")
end

function BaseGui:new() 
    BaseGui.super.new(self)

    self.Size = Pivot2D.FromOffset(50, 50)
    self.Position = Pivot2D.FromOffset(0, 0)

    self.AutomaticSize = nil
    self.SquareAxis = nil
    self.ListOrder = 0

    self.ColorMultiplier = 1

    self.BackgroundColor = Color.new(1)
    self.BackgroundTransparency = 0

    -- Used for stuff like text
    self.ForegroundTransparency = 0
    self.ForegroundColor = Color.new(0)

    self.Layer = 0
    self.Pivot = Vector2.zero -- TODO: Add functionality

    self.AbsolutePosition = Vector2.zero
    self.AbsoluteSize = self:GetAbsoluteSize()

    self.Proxy.Property("Size", "Position", "Layer", "Pivot", "SquareAxis", "ListOrder")
    self.Proxy.Property("BackgroundColor", "ForegroundColor", "BackgroundTransparency", "ForegroundTransparency")
    self.Proxy.PropertyAccess("AbsolutePosition", "AbsoluteSize")
end

function BaseGui:DrawStyle()
    Runtime.Backend2D.SetColor(self.BackgroundColor * self.ColorMultiplier, 1-self.BackgroundTransparency)
    self:Draw()

    Runtime.Backend2D.SetColor(Color.new(0,0,1))
    local AbsoluteSize = self.AbsoluteSize
    love.graphics.rectangle("line", 0,0, AbsoluteSize.X, AbsoluteSize.Y)

    Runtime.Backend2D.SetColor(Color.new(1))
end

function BaseGui:UpdateChildTransforms()
    self:UpdateTransforms()

    for _, v in pairs(self:GetChildren()) do
        if v:IsA("BaseGui") then
            v:UpdateChildTransforms()
        end
    end
end

function BaseGui:UpdateTransforms()
    local NewSize = self:GetAbsoluteSize()

    if NewSize.Magnitude() == 0 then
        printVerbose("Ignoring Transform update due to size")
        return
    end

    self:SetAbsoluteSize(NewSize)
    self.AbsolutePosition = self:GetAbsolutePosition()
end

function BaseGui:SetParent(NewParent)
    BaseGui.super.SetParent(self, NewParent)
    self:UpdateTransforms()
end

function BaseGui:SetPosition(New)
    self.Position = New
    self:UpdateTransforms()
end

function BaseGui:SetSize(New)
    self.Size = New
    self:UpdateTransforms()
end

function BaseGui:SetAbsoluteSize(NewSize)
    self.AbsoluteSize = NewSize
end

return BaseGui