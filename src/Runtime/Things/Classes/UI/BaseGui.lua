local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class BaseGui: Thing
local BaseGui = Things.Extend("Thing")

function BaseGui:GetOffsetPosition()
    local PositionProp = self:GetProperty("Position")
    local Position = PositionProp.Offset

    local ParentRect = self:GetParentRect()

    if ParentRect then
        Position = Position + (PositionProp.Scale * ParentRect.Size)
    end

    return Position
end

function BaseGui:GetAbsoluteRotation()
    return math.rad(self.Rotation)
end

function BaseGui:GetAbsolutePosition()
    local ParentRect = self:GetParentRect(true)

    local Position = self:GetOffsetPosition()
    local Display = self:GetDisplayUI() ---@class Viewport2D
    
    if ParentRect then
        Position = Position + ParentRect.Origin
    end

    -- Handle stuff that should only be handled if we actually have a DisplayUI
    if Display and Display:IsA("Viewport2D") then
        if self.MouseLocked then
            Position = Display.MousePosition + self.LockOrigin
        end

        self.ViewportPosition = Position + Display.ViewportPosition
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
        -- the negative layer check is an ABSOLUTELY nasty hack and really shouldnt be here, but im too lazy - bloctans
        if v:IsA("BaseGui") and (v.Layer >= 0) then
            local PositionProp = v:GetProperty("Position")
            local AbsoluteEnd = PositionProp.Offset + v.AbsoluteSize

            -- Cant use elseif's here - we need to be able to check both axises
            if AbsoluteEnd.X > Size.X then Size = Vector2.new(AbsoluteEnd.X, Size.Y) end
            if AbsoluteEnd.Y > Size.Y then Size = Vector2.new(Size.X, AbsoluteEnd.Y) end
        end
    end

    return Size
end

function BaseGui:GetContentSizeByAdd()
    local ResultSize = Vector2.zero
    print(#self:GetChildren())

    for _,v in pairs(self:GetChildren()) do
        if v.AbsoluteSize~=nil then
            --print(v.AbsoluteSize)
            ResultSize = ResultSize + v.AbsoluteSize
        end
    end
    
    return ResultSize
end

function BaseGui:GetAbsoluteSize()
    local AbsoluteSize = self.Size.Offset
    local ParentRect = self:GetParentRect()

    if ParentRect then -- Only do this if we found a parent element
        local Scale = (ParentRect.Size * self.Size.Scale)

        if self.SquareAxis and self.SquareAxis~="none" then
            Scale = Vector2.one * Scale[self.SquareAxis]
        end
    
        AbsoluteSize = AbsoluteSize + Scale
    end

    if self.AutomaticSize then
        local ContentSize = self:GetContentSize()

        local Opposing = (self.AutomaticSize == Enum.AutomaticSize.X) and Vector2.yAxis or Vector2.xAxis
        local Result = (ContentSize * self.AutomaticSize) + (AbsoluteSize * Opposing)

        AbsoluteSize = Result
    end

    return AbsoluteSize
end

--[[
    its trignometry time!!!!!!!
    math is scary
]]
function BaseGui:GetRotatedBounds()
    local sin = math.sin(self.AbsoluteRotation) -- sin(0) == 0
    local cos = math.cos(self.AbsoluteRotation) -- cos(0) == 1

    return Vector2.new(
        (self.AbsoluteSize.X * cos) + (self.AbsoluteSize.Y * sin),
        (self.AbsoluteSize.X * sin) + (self.AbsoluteSize.Y * cos)
    )  
end

-- Return the object, or the Container
function BaseGui:GetUIObject(Object, Viewport)
    if Object:IsA("ViewportContainer") then
        return Object.Adornee -- PROXY: This returns the adornee assigned, which is assigned DIRECTLY. so there is NO proxy!
    elseif Object:IsA(Viewport and "Viewport" or "BaseGui") then
        return Object
    end
end

-- Find the parent element rendering this object, not really needed
function BaseGui:GetParentElement()
    if (not self.Parent) then return end

    return self:GetUIObject(self.Parent)
end

function BaseGui:GetParentRect(SameDisplay)
    local ParentElement = self:GetParentElement() ---@class BaseGui

    if ParentElement then
        -- If its a scroll container, we need its parentrect object to be able to offset the object itself
        if ParentElement:IsA("ScrollContainer") then 
            SameDisplay = false 
        end

        -- Instead of going up the heierarchy and checking for the display, 
        -- we just check if the parent element is a Viewport. Because if it is, then its 100% displaying to something else
        if SameDisplay and ParentElement:IsA("Viewport") then
            return
        end

        return ParentElement:GetChildRect()
    end
end

-- Find the parent Viewport2D rendering this object
-- TODO: Viewport2D should provide this directly to the object when the display list is created
function BaseGui:GetDisplayUI()
    return self:GetParentCallback(function(Object)
        return self:GetUIObject(Object, true)
    end)
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
    self.Rotation = 0

    self.Layer = 0

    self.PropagatedChange = Signal:New("PropagatedChange")

    self.AutomaticSize = nil
    self.SquareAxis = Enum.SquareAxis.Nothing

    self.AbsoluteLayer = 0
    self.ListOrder = 0

    self.ChildRect = Rect.new(Vector2.zero, Vector2.zero) -- Rect used 

    -- Utility boolean for implementing draggable ui objects
    self.MouseLocked = false -- I didnt wanna implement this as a thing in explorer
    self.LockOrigin = Vector2.zero

    self.ColorMultiplier = 1
    self.ClipsChildren = true

    self.BackgroundColor = Color.new(1)
    self.BackgroundTransparency = 0

    -- Used for stuff like text
    self.ForegroundTransparency = 0
    self.ForegroundColor = Color.new(0)

    self.Transparency = 0

    self.ViewportPosition = Vector2.zero
    self.AbsolutePosition = Vector2.zero
    self.AbsoluteRotation = 0
    self.AbsoluteSize = Vector2.one

    self.Visible = true
    self.TruelyVisible = true

    self.InvalidatedFrom = {}

    self.WasInvalidated = false
    self.EverInvalidated = false

    self.AlreadyCompletedAutoSize = false
end

function BaseGui:DefineAPI()
    BaseGui.super.DefineAPI(self)

    self.Proxy.Property("Pivot2D Size", "Pivot2D Position", "number Layer", "Vector2 Pivot", "Enum.SquareAxis SquareAxis", "number ListOrder", "boolean Visible","number Rotation")
    self.Proxy.Property("Color BackgroundColor", "Color ForegroundColor", "number BackgroundTransparency", "number ForegroundTransparency", "number ColorMultiplier")
    self.Proxy.Property("Enum.AutomaticSize AutomaticSize")
    self.Proxy.PropertyAccess("Vector2 AbsolutePosition", "Vector2 AbsoluteSize")

    self.Proxy.Group("Transform", "Size", "Position", "Pivot", "SquareAxis",  "AutomaticSize", "Rotation")
    self.Proxy.Group("Layout", "Visible",  "Layer", "ListOrder")
    self.Proxy.Group("Color", "ColorMultiplier")

    self.Proxy.Info({
        ConstraintUpdator = function()
            self:ProcessInvalidation(self)
            self:InvalidateAutomaticSize()
        end
    })
end

function BaseGui:IsVisible()
    local Visible = true

    Profiler.Start("IsVisible")
    self:GetParentCallback(function(Parent)
        if Parent:IsA("BaseGui") and (not Parent.Visible) then
            Visible = false
        end
    end)
    Profiler.End()

    return self.Visible and Visible
end

function BaseGui:SetMouseLocked(NewLocked)
    local Display = self:GetDisplayUI() ---@class Viewport2D
    if (not Display) then return end

    if NewLocked then
        self.LockOrigin = self.AbsolutePosition - Display.MousePosition
    end

    self.MouseLocked = NewLocked
    self:InvalidateRendering()
end

function BaseGui:DrawStyle()
    if (not self.EverInvalidated) then return end -- We wait for the first invalidation before rendering the element

    love.graphics.push()
    love.graphics.rotate(self.AbsoluteRotation)
    love.graphics.translate(self.AbsolutePivot.X,self.AbsolutePivot.Y)
    
    self:SetColor("Background", true)
    self:Draw()

    love.graphics.pop()
    love.graphics.translate(self.RotatedPivot.X,self.RotatedPivot.Y)

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

function BaseGui:UpdateTransforms()
    self.AbsoluteRotation = self:GetAbsoluteRotation()

    local NewSize = self:GetAbsoluteSize()

    if (not NewSize:Is(self.AbsoluteSize)) then
        self:SetAbsoluteSize(NewSize)
        self.PropagatedChange.Invoke("AbsoluteSize", NewSize)
    end

    self.AbsolutePosition = self:GetAbsolutePosition()
    self.AbsolutePivot = -(self.Pivot * self.AbsoluteSize)
    self.RotatedPivot = -(self.Pivot * self:GetRotatedBounds())

    self.ChildRect = Rect.new(self.AbsolutePosition + self.RotatedPivot, self:GetRotatedBounds())
end

function BaseGui:InvalidateAutomaticSize()
    if self.Parent and self.Parent.AutomaticSize then
        self.Parent:ProcessInvalidations()
        self.Parent:InvalidateAutomaticSize()
    end
end

-- Same as ProcessInvalidation, Except it doesnt Update WasInvalidated, and doesnt propagate, used for handling AutomaticSize changes
function BaseGui:ProcessInvalidations()
    Profiler.Start("BaseGui - Process Invalidation")
    self:UpdateTransforms() 

    local NewVisible = self:IsVisible()

    if self.TruelyVisible ~= NewVisible then
        self.TruelyVisible = NewVisible

        self.PropagatedChange.Invoke("Visible", self.TruelyVisible)
    end
    Profiler.End()
end

-- Process the invalidation for an object
function BaseGui:ProcessInvalidation(Origin)
    if (not self.Parent) then return end -- Hacky fix

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
function BaseGui:InvalidateRendering(WasSame)
    if WasSame and self.EverInvalidated then return end

    self.WasInvalidated = true
end

function BaseGui:SetParent(NewParent)
    local CouldParent, Reason = BaseGui.super.SetParent(self, NewParent)

    self:InvalidateRendering()
    self:ProcessInvalidation(self)
    --self:InvalidateAutomaticSize()

    return CouldParent, Reason
end

function BaseGui:SetVisible(NewVisiblity)
    self.Visible = NewVisiblity
    self:InvalidateRendering()
end

function BaseGui:SetPosition(New)
    local Same = self.Position.Is(New)

    self.Position = New
    self:InvalidateRendering(Same)
end

function BaseGui:SetPivot(New)
    self.Pivot = New
    self:InvalidateRendering()
end

function BaseGui:SetRotation(New)
    self.Rotation = New
    self:InvalidateRendering()
end

---@param New Pivot2D
function BaseGui:SetSize(New)
    local Same = self.Size.Is(New)

    self.Size = New
    self:InvalidateRendering(Same)
end

function BaseGui:SetAbsoluteSize(NewSize)
    self.AbsoluteSize = NewSize
end

function BaseGui:Invalidate(dt)
    if self.WasInvalidated or self.MouseLocked then
        --print(self:GetPath())
        self:ProcessInvalidation(self)
        self:InvalidateAutomaticSize()
    end
end

return BaseGui