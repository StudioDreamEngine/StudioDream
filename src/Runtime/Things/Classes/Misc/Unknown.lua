local Things = Runtime.Things

-- This thing will only be used if we ever get to deprecate an thing, or delete it at all, this would replace it

---@class Unkown: Thing
local Unkown = Things.Extend("Thing")

function Unkown:new()
    Unkown.super.new(self)
end

function Unkown:DefineAPI()
    Unkown.super.DefineAPI(self)
    self.Proxy.Icon("Unkown")
end

return Unkown