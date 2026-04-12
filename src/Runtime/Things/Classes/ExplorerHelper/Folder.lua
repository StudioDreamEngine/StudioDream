local Things = Runtime.Things

---@module 'Thing'
local Folder = Things.Extend("Thing")

function Folder:new() 
    Folder.super:new(self)
    self.LockObjectsIn = false

    self.Explorer = {
        Visible = true,
        Icon = "folder"
    }
end

function Folder:Update(dt) 
end

return Folder