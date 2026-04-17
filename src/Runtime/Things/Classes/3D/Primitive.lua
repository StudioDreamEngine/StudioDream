local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Base3D'
local Primitive = Things.Extend("Base3D")

function Primitive:new()
    Primitive.super.new(self)

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "MeshPart"
    }
    self.Shape = Enum.Shape.Brick

    self._LastShape = self.Shape
end

function Primitive:Update(dt)
    if self._LastShape ~= self.Shape or not self.Drawable then
        self.Drawable = Dream:loadObject('Assets/' .. self.Shape)
        print("[Primitive] made new Drawable")
    end
    self._LastShape = self.Shape

    Primitive.super.Update(self, dt)
end

return Primitive