local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Contextulizer: BaseGui
local Contextulizer = Things.Extend("BaseGui")

function Contextulizer:new()
    Contextulizer.super.new(self)

    self.Debugger = true
    self.Hovering = false
    self.Choices = {}
end

function Contextulizer:DefineAPI()
    Contextulizer.super.DefineAPI(self)

    --self.Proxy.MakeCreatable()
    Runtime.InterfaceManager.OnRightClick:Connect(function()
        if not self.Hovering then return end
        
        print("GotClicked")
        Studio.Components.ContextMenu.new(self.Choices,self)
    end)
end

function Contextulizer:SetChoices(NewChoices)
    self.Choices = NewChoices
end

function Contextulizer:OnInitalParent(NewParent)
    Contextulizer.super.OnInitalParent(self, NewParent)

    Runtime.InterfaceManager.RegisterButton(self.UUID)
end

function Contextulizer:OnRemove()
    Contextulizer.super.OnRemove(self)

    self.Hovering = false
    Runtime.InterfaceManager.UnregisterButton(self.UUID)
end

function Contextulizer:SetOutlineSize(number)
    self.OutlineSize = number
end

function Contextulizer:Draw()
    local Size = self.AbsoluteSize

    if self.Debugger then
        love.graphics.rectangle("line", 0,0, Size.X, Size.Y,0, 0)
    end
end

function Contextulizer:Update(dt)
    Contextulizer.super.Update(self)

    local DisplayUI = self:GetDisplayUI()
    if (not DisplayUI) then return end
    
end

return Contextulizer