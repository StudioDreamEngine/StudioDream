local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Square: BaseGui
local Square = Things.Extend("Square")

function Square:new()
    Square.super.new(self)

    self.Hovering = false
end

function Square:OnInitalParent(NewParent)
    Square.super.OnInitalParent(self, NewParent)
    Runtime.InterfaceManager.RegisterButton(self.UUID)
end

return Square