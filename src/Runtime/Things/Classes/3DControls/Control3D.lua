-- Moveable axis control
local Things = Runtime.Things

---@class Control3D: Base3D
local Control3D = Things.Extend("Base3D")

function Control3D:new()
    Control3D.super.new(self)

    self.Adornee = nil ---@class Drawable3D
    self.AdornObject = Runtime.Backend3D.CreateAdorn("MoveAdorn")
    self.Adorns = {}
end

function Control3D:DefineAPI()
    Control3D.super.DefineAPI(self)

    self.Proxy.Property("Thing Adornee")
end

return Control3D