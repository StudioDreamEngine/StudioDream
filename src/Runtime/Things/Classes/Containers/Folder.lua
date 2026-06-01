local Things = Runtime.Things

---@module 'Thing'
---@class Folder
local Folder = Things.Extend("Thing")

function Folder:new() 
    Folder.super:new(self)
    self.LockObjectsIn = false

    self.Explorer = {
        Visible = true,
        Icon = "folder"
    }
end

function Folder:DefineAPI()
    Folder.super.DefineAPI(self)

    self.Proxy.Icon("Folder")
    self.Proxy.Property("boolean LockObjectsIn")
    self.Proxy.Group("Objects", "LockObjectsIn")
    self.Proxy.MakeCreatable()
end

function Folder:Update(dt) 
end

return Folder