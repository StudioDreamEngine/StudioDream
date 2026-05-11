local PropertiesRender = {}
local Things = Runtime.Things

local Frames = {
    ["string"] = function(Propertyframe)

    end
}

local function CreatePropertyNode(Window,PropertyTxt)
    local BaseProperty = Things.Create("Square") { 
        Size = Pivot2D.FromScale(1,0.05),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.StudioLayout.Theme.WindowColor,
        Layer = 3,
        Parent = Window,
        CornerRadius = 10,
        OutlineSize = 2,
        OutlineColor = Studio.StudioLayout.Theme.OutlineColor
    }

    Things.Create("Text") {
        Size =  Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0,0.5),
        Text = PropertyTxt,
        Parent = BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Color.new(1,1,1)
    }

    -- Make another square for Frames!!! so they can suport options

    return BaseProperty
end

function PropertiesRender.Init(Window)

    Studio.Editor3D.OnSelect:Connect(function(Thing)
        local Benchmark = Profiler.Benchmark("Invalidate Properties", true)

        Window:ClearAllChildren()

        local index = 0
        for Property,v in pairs(Thing.Proxy.Accessible) do
            index=index+1
            local Node = CreatePropertyNode(Window,Property)
            Node.ListOrder = index
        end

        Benchmark.End()

        --[[Things.Create("ListLayout") {
            Parent = Window,
        }]]
    end)
end

return PropertiesRender