
local PropertiesRender = {}
local Things = Runtime.Things
local RequiredPropertyTypes = {}

local function CreatePropertyNode(Window,PropertyTxt,Type,Thing)
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
        ForegroundColor = Studio.Theme.Text
    }

    local Option = Things.Create("Square") { -- The frame where options will be in, aka textlabel for strings, tables open and close ect ect!!!
        Size = Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.Outline,
        Layer = 3,
        Name = "Frame",
        Parent = BaseProperty,
    }

    if Utils.DoesFileExist("Studio/UI/Windows/PropertiesTypes/"..Type..".lua") then
        if not RequiredPropertyTypes[Type] then
            RequiredPropertyTypes[Type] = require("Studio/UI/Windows/PropertiesTypes/"..Type)
        end
        RequiredPropertyTypes[Type](Option,Thing,PropertyTxt)
        --PropertyTypes[Type](Option,Thing,PropertyTxt) -- make this update if a property was changed, aka for updating positions ect ect ✌️
    else
        --PropertyTypes["Not_Found"](Option,Thing,PropertyTxt)
    end

    return BaseProperty
end

function PropertiesRender.Init(Window)

    Studio.Editor3D.OnSelect:Connect(function(Thing)
        Window:ClearAllChildren()
        local index = 0
        for Property,v in pairs(Thing.Proxy.Accessible) do
            local Type
            if Thing.Proxy.Types[Property] then Type = Thing.Proxy.Types[Property] end
            print(Property,Type)
            index=index+1
            local Node = CreatePropertyNode(Window,Property,Type,Thing)
            Node.ListOrder = index
        end

        --Benchmark.End()

        Things.Create("ListLayout") {
            Parent = Window,
        }
    end)

    Studio.Editor3D.OnDeselect:Connect(function()
         Window:ClearAllChildren()
    end)
end

return PropertiesRender