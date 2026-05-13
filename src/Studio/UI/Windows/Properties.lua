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
        BackgroundColor = Studio.Theme.Secondary,
        Layer = 3,
        Parent = Window,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.Outline
    }

    Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = PropertyTxt,
        Name = "PropertyName",
        Parent = BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Color.new(1,1,1)
    }

    Things.Create("Square") { -- The frame where options will be in, aka textlabel for strings, tables open and close ect ect!!!
        Size = Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.Outline,
        Layer = 3,
        Name = "Frame",
        Parent = BaseProperty,
    }

    return BaseProperty
end

function PropertiesRender.Init(Window)

    Studio.Editor3D.OnSelect:Connect(function(Thing)
        Window:ClearAllChildren()
        local index = 0
        for Property,v in pairs(Thing.Proxy.Accessible) do
            index=index+1
            local Node = CreatePropertyNode(Window,Property)
            Node.ListOrder = index
        end

        --Benchmark.End()

        --[[Things.Create("ListLayout") {
            Parent = Window,
        }]]
    end)
end

return PropertiesRender