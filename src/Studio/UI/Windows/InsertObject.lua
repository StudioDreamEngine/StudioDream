local Things = Runtime.Things
local InsertObject = {}

InsertObject.Container = nil ---@class Square

function InsertObject.Init()
    InsertObject.ScrollContainer = Things.Create("Square") { -- Not a scroll container for now
        Size = Pivot2D.FromScale(1,1),
        Parent = InsertObject.Container
    }
end

function InsertObject.Update(dt)
    
end

return InsertObject