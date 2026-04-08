local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local BaseGui = Things.Extend("Thing")

function BaseGui:GetOffsetPosition()
    local Position = self.Position.Offset - (self.Pivot * self.AbsoluteSize)
    local ParentElement = self:GetParentElement()

    if ParentElement then
        Position = Position + (self.Position.Scale * ParentElement.AbsoluteSize)
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

        Position = Position + ParentElement:GetAbsolutePosition()
    end

    return Position
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

function BaseGui:GetAbsoluteSize(Size)
    local Size = Size or self.Size

    local AbsoluteSize = Size.Offset
    local ParentElement = self:GetParentElement()

    if ParentElement then -- Only do this if we found a parent element
        AbsoluteSize = AbsoluteSize + (ParentElement.AbsoluteSize * Size.Scale)
    end
    
    return AbsoluteSize
end

-- Find the parent element rendering this object
function BaseGui:GetParentElement()
    return self:FindFirstAncestorWithClass("BaseGui")
end

-- Find the parent Viewport2D rendering this object
-- TODO: Viewport2D should provide this directly to the object when the display list is created
function BaseGui:GetDisplayUI()
    return self:FindFirstAncestorWithClass("Viewport2D")
end

function BaseGui:Draw()
    error("BaseGui:Draw() is virtual and should not be called directly (from: "..self.Name..")")
end

function BaseGui:new() 
    BaseGui.super.new(self)

    self.Size = Pivot2D.FromOffset(50, 50)
    self.Position = Pivot2D.FromOffset(0, 0)

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

    self.LastSize = self.AbsoluteSize
end

function BaseGui:DrawStyle()
    Runtime.Backend2D.SetColor(self.BackgroundColor * self.ColorMultiplier, 1-self.BackgroundTransparency)
    self:Draw()

    local AbsoluteSize = self.AbsoluteSize
    --love.graphics.rectangle("line", 0,0, AbsoluteSize.X, AbsoluteSize.Y)
    
    Runtime.Backend2D.SetColor(Color.new(1))
end

function BaseGui:SetPosition(New)
    self.Position = New
    self.AbsolutePosition = self:GetAbsolutePosition()
end

function BaseGui:SetAbsoluteSize(NewSize)
    self.AbsoluteSize = NewSize
end

function BaseGui:Update(dt) 
    BaseGui.super.Update(self, dt)

    local CurrentSize = self:GetAbsoluteSize()

    if not (CurrentSize.Is(self.LastSize)) then
        self:SetAbsoluteSize(CurrentSize)
    end

    self.LastSize = CurrentSize
end

return BaseGui