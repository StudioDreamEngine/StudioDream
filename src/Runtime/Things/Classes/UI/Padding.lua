local Things = Runtime.Things

---@class Padding: ChildConstraint
local Padding = Things.Extend("ChildConstraint")

function Padding:new()
    Padding.super.new(self)

    self.ConstraintProperties = {"Size"}
    self.ObjectFilter = "BaseGui"

    self.PaddingSpecific = nil -- to do later

    self.PaddingY = 0
    self.PaddingX = 0

    self.lock = nil

    self.ChangeConnect = {}
end

function Padding:DefineAPI()
    Padding.super.DefineAPI(self)

    self.Proxy.SetCategory("UI")

    self.Proxy.Property("number PaddingY","number PaddingX")
    self.Proxy.Group("Padding","PaddingY","PaddingX")

    self.Proxy.Icon("Unkown")

    self.Proxy.MakeCreatable()
end

function Padding:UnLinkObject(Obj)
    self.ChangeConnect[Object]:DisconnectAll()
    self.ChangeConnect[Object] = nil
end

function Padding:UnLinkAll()
    for i,v in pairs(self.ChangeConnect) do
        self:UnLinkObject(i)
    end
end

function Padding:PadOn(Object)
    Object:SetConstraint(self,"ChildRect", Rect.new(Object.AbsolutePosition + Object.AbsolutePivot + Vector2.new(self.PaddingY/2,self.PaddingX/2), Object.AbsoluteSize-Vector2.new(self.PaddingY,self.PaddingX)))
    --Object.AbsoluteSize = Object.AbsoluteSize - Vector2.new(self.PaddingLeft + self.PaddingRight,self.PaddingTop + self.PaddingBottom)
end

function Padding:LinkObject(Object)
    Object:BindConstraint(self,"ChildRect")

    self.ChangeConnect[Object] = Object.PropagatedChange:Connect(function(Value, Key)
        if Key == "AbsoluteSize" then
            self:PadOn(Object)
        end
    end)

    self:PadOn(Object)
end

function Padding:BindObject(Object)
    local Binded = Padding.super.BindObject(self, Object)
    if (not Binded) then return end

    Object.ParentChanged:Connect(function()
        self:UnLinkObject(Object)
    end)

    if Object:IsA("BaseGui") then
        self:LinkObject(Object)
    end
end

return Padding