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
    local Display = self:GetDisplayUI() ---@class Viewport2D

    if ParentElement then
        -- we need to now make sure the parent element is displaying to the same viewport
        local SameDisplayUI = (ParentElement:GetDisplayUI() == Display)

        -- If it isnt, stop here, dont get the position of the next one
        if (not SameDisplayUI) then 
            return Position 
        end

        Position = Position + ParentElement.AbsolutePosition
    end

    if self.MouseLocked then
        Position = Display.MousePosition + self.LockOrigin
    end

    return Position
end

function BaseGui:GetRect()
    return Rect.new(self.AbsolutePosition, self.AbsoluteSize)
end

function BaseGui:IsAlwaysOnTop()
    return self.MouseLocked
end

-- Get true position from display point on part or the screen
function BaseGui:GetDisplayPosition()
    local ParentElement = self:GetParentElement()
    local Position = self:GetOffsetPosition()

    if ParentElement then
        Position = Position + ParentElement.DisplayPosition
    end

    return Position
end

function BaseGui:GetContentSize()
    local Size = Vector2.zero

    for _, v in pairs(self:GetChildren()) do
        if v:IsA("BaseGui") then
            local PositionProp = v:GetProperty("Position")
            local AbsoluteEnd = PositionProp.Offset + v.AbsoluteSize

            -- Cant use elseif's here - we need to be able to check both axises
            if AbsoluteEnd.X > Size.X then Size = Vector2.new(AbsoluteEnd.X, Size.Y) end
            if AbsoluteEnd.Y > Size.Y then Size = Vector2.new(Size.X, AbsoluteEnd.Y) end
        end
    end

    return Size
end

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

    if self.AutomaticSize then
        local ContentSize = self:GetContentSize()
        local Opposing = (self.AutomaticSize == Enum.AutomaticSize.X) and Vector2.yAxis or Vector2.xAxis

        AbsoluteSize = (ContentSize * self.AutomaticSize) + (AbsoluteSize * Opposing)
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

    -- Utility boolean for implementing draggable ui objects
    self.MouseLocked = false -- I didnt wanna implement this as a thing in explorer
    self.LockOrigin = Vector2.zero

    self.ColorMultiplier = 1

    self.BackgroundColor = Color.new(1)
    self.BackgroundTransparency = 0

    -- Used for stuff like text
    self.ForegroundTransparency = 1
    self.ForegroundColor = Color.new(0)

    --self.Rotation = 0

    self.Layer = 0
    self.Pivot = Vector2.zero -- TODO: Add functionality

    self.AbsolutePosition = Vector2.zero
    self.AbsoluteSize = self:GetAbsoluteSize()

    self.DisplayPosition = Vector2.zero

    self.Visible = true

    self.WasInvalidated = false
    self.EverInvalidated = false

    self.Proxy.Property("Pivot2D Size", "Pivot2D Position", "number Layer", "Vector2 Pivot", "Enum SquareAxis", "number ListOrder")
    self.Proxy.Property("Color BackgroundColor", "Color ForegroundColor", "number BackgroundTransparency", "number ForegroundTransparency")
    self.Proxy.Property("number ColorMultiplier")
    self.Proxy.PropertyAccess("Vector2 AbsolutePosition", "Vector2 AbsoluteSize")

    self.Proxy.Group("Transform", "Size", "Position", "Pivot")
    self.Proxy.Group("Color Multipliers", "ColorMultiplier")
    self.Proxy.Info({
        ConstraintUpdator = self.InvalidateRendering
    })
end

function BaseGui:IsVisible()
    local Visible = true

    self:GetParentCallback(function(Parent)
        if Parent:IsA("BaseGui") and (not Parent.Visible) then
            Visible = false
        end
    end)

    return Visible
end

function BaseGui:SetMouseLocked(NewLocked)
    local Display = self:GetDisplayUI() ---@class Viewport2D

    if NewLocked then
        self.LockOrigin = self.AbsolutePosition - Display.MousePosition
    end

    self.MouseLocked = NewLocked
end

function BaseGui:DrawStyle()
    if (not self.EverInvalidated) then return end -- We wait for the first invalidation before rendering the element

    if self.Visible and self:IsVisible() then
        Runtime.Backend2D.SetColor(self.BackgroundColor * self.ColorMultiplier, 1-self.BackgroundTransparency)
        self:Draw()
        Runtime.Backend2D.SetColor(Color.new(1))
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
    --self.DisplayPosition = self:GetDisplayPosition()
end

function BaseGui:InvalidateAutomaticSize()
    if self.Parent.AutomaticSize then
        self.Parent:UpdateTransforms()
        self.Parent:InvalidateAutomaticSize()
    end
end

function BaseGui:ProcessInvalidation(Origin)
    self:UpdateTransforms()
    self.EverInvalidated = true
    self.WasInvalidated = false

    -- We cant simply mark invalidation, if we did then invalidation would be frame-dependent, which is bad!
    for _, v in pairs(self:GetChildren()) do
        if v:IsA("BaseGui") then
            v:ProcessInvalidation(Origin)
            --v:InvalidateRendering()
        end
    end
end

-- TODO: Also be able to store causes of invalidation within a frame
function BaseGui:InvalidateRendering()
    self.WasInvalidated = true
end

function BaseGui:SetParent(NewParent)
    BaseGui.super.SetParent(self, NewParent)
    self:ProcessInvalidation(self)
end

function BaseGui:SetPosition(New)
    self.Position = New
    self:InvalidateRendering()
end

function BaseGui:SetSize(New)
    self.Size = New
    self:InvalidateRendering()
end

function BaseGui:SetAbsoluteSize(NewSize)
    self.AbsoluteSize = NewSize
end

function BaseGui:Update(dt)
    BaseGui.super.Update(dt)

    if self.WasInvalidated then
        self:ProcessInvalidation(self)
        self:InvalidateAutomaticSize()
    end
end

return BaseGui