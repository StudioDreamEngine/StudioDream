local PropertiesRender = {}
local Things = Runtime.Things

local Frames = {
    ["string"] = function(Propertyframe)

    end
}

function PropertiesRender.Init(Window)

    Things.Create("ListLayout") {
        Parent = Window,
    }

    Studio.Editor3D.OnSelect:Connect(function(Thing)
        Window:ClearAllChildren({"ListLayout"})
        for Property,v in pairs(Thing.Proxy.Accessible) do
            local PropertyValue = Thing[i]
            Things.Create("Square") { 
                Size = Pivot2D.FromScale(1,0.05),
                --Pivot = Transform.Pivot,
                Layer = 3,
                Parent = Window
            }
        end
    end)
end

return PropertiesRender