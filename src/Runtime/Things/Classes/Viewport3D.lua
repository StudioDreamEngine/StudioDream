local Things = Runtime.Things
local Viewport3D = Things.Extend("BaseGui")

function Viewport3D:Draw()
    Dream:present()
end

function Viewport3D:SetAbsoluteSize(New)
    Viewport3D.super.SetAbsoluteSize(self, New)

    Dream:resize(New.X, New.Y)
end

return Viewport3D