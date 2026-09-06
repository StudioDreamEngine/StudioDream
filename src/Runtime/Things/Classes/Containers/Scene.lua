local Things = Runtime.Things

---@class Scene: Thing
local Scene = Things.Extend("Thing")

function Scene:new()
    Scene.super.new(self)

    self.Identifier = nil
end

return Scene