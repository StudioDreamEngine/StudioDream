local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class BaseGui: Thing
local BaseGui = Things.Extend("Thing")

function BaseGui:GetOffsetPosition()
    local PositionProp = self:GetProperty("Position")

    local Position = PositionProp.Offset - (self.Pivot * self.AbsoluteSize)
    local ParentRect = self:GetParentRect()

    if ParentRect then
        Position = Position + (PositionProp.Scale * ParentRect.Size)
    end

    return Position
end

function BaseGui:GetAbsolutePosition()
    local ParentRect = self:GetParentRect(true)

    local Position = self:GetOffsetPosition()
    local Display = self:GetDisplayUI() ---@class Viewport2D

    if ParentRect then
        Position = Position + ParentRect.Origin
    end

    if self.MouseLocked and Display then
        Position = Display.MousePosition + self.LockOrigin
    end

    return Position
end

function BaseGui:GetChildRect()
    return self:GetProperty("ChildRect")
end

function BaseGui:IsAlwaysOnTop()
    return self.MouseLocked
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
    local ParentRect = self:GetParentRect()

    if ParentRect then -- Only do this if we found a parent element
        local Scale = (ParentRect.Size * self.Size.Scale)

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

function BaseGui:GetParentRect(SameDisplay)
    local ParentElement = self:GetParentElement() ---@class BaseGui

    if ParentElement then
        -- If its a scroll container, we need its parentrect object to be able to offset the object itself
        if ParentElement:IsA("ScrollContainer") then 
            SameDisplay = false 
        end

        if SameDisplay and (ParentElement:GetDisplayUI() ~= self:GetDisplayUI()) then
            return
        end

        return ParentElement:GetChildRect()
    end
end

-- Find the parent Viewport2D rendering this object
-- TODO: Viewport2D should provide this directly to the object when the display list is created
function BaseGui:GetDisplayUI()
    return self:FindFirstAncestorWithClass("Viewport")
end

function BaseGui:Draw()
    error("BaseGui:Draw() is virtual and should not be called directly (from: "..self.Name..")")
end

function BaseGui:SetColor(ColorMode, Multiplier)
    local TransparencyValue = (1 - self[ColorMode.."Transparency"]) * (1-self.Transparency)

    Runtime.Backend2D.SetColor(self[ColorMode.."Color"] * (Multiplier and self.ColorMultiplier or 1), TransparencyValue)
end

function BaseGui:new() 
    BaseGui.super.new(self)

    self.Size = Pivot2D.FromOffset(50, 50)
    self.Position = Pivot2D.FromOffset(0, 0)
    self.Pivot = Vector2.zero -- TODO: Add functionality
    --self.Rotation = 0

    self.Layer = 0

    self.PropagatedChange = Signal:New("PropagatedChange")

    self.AutomaticSize = nil
    self.SquareAxis = nil
    self.ListOrder = 0

    self.ChildRect = Rect.new(Vector2.zero, Vector2.zero) -- Rect used 

    -- Utility boolean for implementing draggable ui objects
    self.MouseLocked = false -- I didnt wanna implement this as a thing in explorer
    self.LockOrigin = Vector2.zero

    self.ColorMultiplier = 1

    self.BackgroundColor = Color.new(1)
    self.BackgroundTransparency = 0

    -- Used for stuff like text
    self.ForegroundTransparency = 0
    self.ForegroundColor = Color.new(0)

    self.Transparency = 0

    self.AbsolutePosition = Vector2.zero
    self.AbsoluteSize = self:GetAbsoluteSize()

    self.Visible = true
    self.TruelyVisible = true

    self.InvalidatedFrom = {}

    self.WasInvalidated = false
    self.EverInvalidated = false
end

function BaseGui:DefineAPI()
    BaseGui.super.DefineAPI(self)

    self.Proxy.Property("Pivot2D Size", "Pivot2D Position", "number Layer", "Vector2 Pivot", "Enum SquareAxis", "number ListOrder", "boolean Visible")
    self.Proxy.Property("Color BackgroundColor", "Color ForegroundColor", "number BackgroundTransparency", "number ForegroundTransparency")
    self.Proxy.Property("number ColorMultiplier")
    self.Proxy.PropertyAccess("Vector2 AbsolutePosition", "Vector2 AbsoluteSize")

    self.Proxy.Group("Transform", "Size", "Position", "Pivot", "Visible")
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

    return self.Visible and Visible
end

function BaseGui:SetMouseLocked(NewLocked)
    local Display = self:GetDisplayUI() ---@class Viewport2D

    if NewLocked then
        self.LockOrigin = self.AbsolutePosition - Display.MousePosition
    end

    self.MouseLocked = NewLocked
    self:InvalidateRendering()
end

function BaseGui:DrawStyle()
    if (not self.EverInvalidated) then return end -- We wait for the first invalidation before rendering the element

    if self:IsVisible() then
        self:SetColor("Background", true)
        self:Draw()

        if FLAGS.DebugDraw then
            local Rect = self:GetProperty("ChildRect")

            love.graphics.setLineWidth(1)

            Runtime.Backend2D.SetColor(Color.new(0,0,1))
            love.graphics.rectangle("line", 0, 0, self.AbsoluteSize.X, self.AbsoluteSize.Y)

            Runtime.Backend2D.SetColor(Color.new(1,0,0))
            love.graphics.rectangle("line", 0, 0, Rect.Size.X, Rect.Size.Y)
        end

       Runtime.Backend2D.SetColor(Color.new(1))
    end
end

function BaseGui:UpdateTransforms()
    local NewSize = self:GetAbsoluteSize()
    
    if NewSize.Magnitude() == 0 then
        printVerbose("Ignoring Transform update due to size")
        return
    end

    if (not NewSize.Is(self.AbsoluteSize)) then
        self:SetAbsoluteSize(NewSize)
        self.PropagatedChange.Invoke("AbsoluteSize", NewSize)
    end

    self.AbsolutePosition = self:GetAbsolutePosition()

    self.ChildRect = Rect.new(self.AbsolutePosition, self.AbsoluteSize)
end

function BaseGui:InvalidateAutomaticSize()
    if self.Parent.AutomaticSize then
        self.Parent:ProcessInvalidations()
        self.Parent:InvalidateAutomaticSize()
    end
end

-- Same as ProcessInvalidation, Except it doesnt Update WasInvalidated, and doesnt propagate, used for handling AutomaticSize changes
function BaseGui:ProcessInvalidations()
    self:UpdateTransforms() 

    local NewVisible = self:IsVisible()

    if self.TruelyVisible ~= NewVisible then
        self.TruelyVisible = NewVisible

        self.PropagatedChange.Invoke("Visible", self.TruelyVisible)
    end
end

-- Process the invalidation for an object
function BaseGui:ProcessInvalidation(Origin)
    --print("Invalidating from "..Origin.Name)

    self:ProcessInvalidations()

    self.EverInvalidated = true
    self.WasInvalidated = false

    -- We cant simply mark invalidation, if we did then invalidation would be frame-dependent, which is bad!
    for _, v in pairs(self:GetChildren()) do
        if v:IsA("BaseGui") then
            v:ProcessInvalidation(Origin)
        end
    end
end

-- TODO: Also be able to store causes of invalidation within a frame
function BaseGui:InvalidateRendering(...)
    self.WasInvalidated = true
end

function BaseGui:SetParent(NewParent)
    local CouldParent, Reason = BaseGui.super.SetParent(self, NewParent)

    self:InvalidateRendering()
    self:ProcessInvalidation(self)

    return CouldParent, Reason
end

function BaseGui:SetVisible(NewVisiblity)
    self.Visible = NewVisiblity
    self:InvalidateRendering()
end

function BaseGui:SetPosition(New)
    self.Position = New
    self:InvalidateRendering()
end

function BaseGui:SetPivot(New)
    self.Pivot = New
    self:InvalidateRendering()
end

function BaseGui:SetSize(New)
    self.Size = New
    self:InvalidateRendering()
end

function BaseGui:SetAbsoluteSize(NewSize)
    self.AbsoluteSize = NewSize
end

function BaseGui:Invalidate(dt)
    if self.WasInvalidated or self.MouseLocked then
        self:ProcessInvalidation(self)
        self:InvalidateAutomaticSize()
    end
end

return BaseGui