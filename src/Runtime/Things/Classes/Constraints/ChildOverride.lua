local Things = Runtime.Things

---@class ChildOverride: BaseOverride
local ChildOverride = Things.Extend("BaseOverride")

function ChildOverride:new()
    ChildOverride.super.new(self)
end

function ChildOverride:Bind()
    self:BindObject(self.Parent)
end

return ChildOverride