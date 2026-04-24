local Things = Runtime.Things

---@module 'Thing'
---@class Root
local Root = Things.Extend("Thing")

function Root:new() 
    Root.super.new(self)

    self.Explorer = {
        UseNewIcon = true,
        Visible = true,
        Icon = "Root",
    }

    self.Serializable = false
end

return Root