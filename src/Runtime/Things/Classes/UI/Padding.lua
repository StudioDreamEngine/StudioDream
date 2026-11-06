local Things = Runtime.Things

---@class Padding: ChildOverride
local Padding = Things.Extend("ChildOverride")

function Padding:new()
    Padding.super.new(self)

    self.OverrideProperties = {"Size"}
    self.ObjectFilter = "BaseGui"

    self.PaddingSpecific = nil

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

    self.Proxy.Icon("Padding")

    self.Proxy.MakeCreatable()
end

function Padding:PadOn(Object)
    local Clamp = Object.AbsoluteSize-Vector2.new(self.PaddingY,self.PaddingX)
    local Clamped = Vector2.new(math.max(0,Clamp.X),math.max(0,Clamp.Y))

    Object:SetOverride(self, "ChildRect", Rect.new(Object.AbsolutePosition + Object.AbsolutePivot + Vector2.new(math.max(0,self.PaddingY/2),math.max(0,self.PaddingX/2)), Clamped), true)
end

function Padding:LinkObject(Object)
    Object:BindOverride(self,"ChildRect")

    self.ChangeConnect = Object.PostTransform:Connect(function()
        self:PadOn(Object)
    end)
end

function Padding:UnbindObject(_child)
    Padding.super.UnbindObject(self, _child)
    
    self.ChangeConnect:Disconnect()
end

function Padding:BindObject(Object)
    local Binded = Padding.super.BindObject(self, Object)
    if (not Binded) then return end

    if Object:IsA("BaseGui") then
        self:LinkObject(Object)
    end
end

return Padding