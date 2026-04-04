local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local BaseGui = Things.Extend("Thing")

function BaseGui:New() 
    self.Size = Pivot2D.new(50,0,50,0)
    self.Position = Pivot2D.new(50,0,50,0)
end

function BaseGui:GetDisplayUI()
    return self:GetParentCallback(function(Object)
        return Object:IsA("Viewport2D")
    end)
end

function BaseGui:Update(dt) 

end

return BaseGui