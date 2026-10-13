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

    self.Proxy.Icon("Padding")

    self.Proxy.MakeCreatable()
end

function Padding:UnLinkObject(Obj)
    self.ChangeConnect[Obj]:Disconnect()
    self.ChangeConnect[Obj] = nil
end

function Padding:UnLinkAll()
    for i,v in pairs(self.ChangeConnect) do
        self:UnLinkObject(i)
    end
end

function Padding:PadOn(Object)
    local Clamp = Object.AbsoluteSize-Vector2.new(self.PaddingY,self.PaddingX)
    local Clamped = Vector2.new(math.max(0,Clamp.X),math.max(0,Clamp.Y))

    Object:SetOverride(self, "ChildRect", Rect.new(Object.AbsolutePosition + Object.AbsolutePivot + Vector2.new(math.max(0,self.PaddingY/2),math.max(0,self.PaddingX/2)), Clamped))
end

function Padding:LinkObject(Object)
    Object:BindOverride(self,"ChildRect")

    self.ChangeConnect[Object] = Object.PropagatedChange:Connect(function(a,b)
        self:PadOn(Object)
    end, "AbsoluteSize")

    self:PadOn(Object)
end

--[[function Padding:SetPaddingSpecific(Object)
    self.PaddingSpecific = Object
    self:UnLinkAll()

    if not Object then
        if self.PaddingSpecific then
            self:UnLinkObject(self.PaddingSpecific)
        end
        return
    end
    Object.ParentChanged:Connect(function()
        self:UnLinkObject(Object)
    end)

    if Object:IsA("BaseGui") then
        self:LinkObject(Object)
    end
end]]

function Padding:UnbindObject(_child)
    Padding.super.UnbindObject(self, _child)
    
    if self.ChangeConnect[_child] ~= nil then
       self:UnLinkObject(_child)
    end
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