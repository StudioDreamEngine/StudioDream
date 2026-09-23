local Things = Runtime.Things

---@module 'Thing'
---@class Folder
local Folder = Things.Extend("Thing")

function Folder:new() 
    Folder.super.new(self)
    self.LockObjectsIn = false
    self.IconColor = Color.new(1)
end

function Folder:DefineAPI()
    Folder.super.DefineAPI(self)

    self.IconColorChanged = Signal:New("IconColorChange")

    self.Proxy.SetCategory("Containers")

    self.Proxy.Icon("Folder")
    self.Proxy.Property("boolean LockObjectsIn","Color IconColor")
    self.Proxy.Group("General", "IconColor")
    self.Proxy.Group("Objects", "LockObjectsIn")
    self.Proxy.MakeCreatable()
end

function Folder:SetIconColor(Color)
    self.IconColor = Color
    self.Proxy.SetIconColor(Color)
    self.IconColorChanged.Invoke()
end

function Folder:OnRemove()
    Folder.super.OnRemove(self)

    self.IconColorChanged:DisconnectAll()
end

function Folder:Update(dt) 
end

return Folder