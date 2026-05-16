
local PropertiesRender = {}
local Things = Runtime.Things

local PropertyTypes = { -- I really dont want to keep all this stuff here
    ["string"] = function(FrameOption,Thing,Property) -- maybe a signal for when the option is changed? like u stop typing the new object name ect ect

        local Stringthing = Things.Create("TextInput") {
            Size = Pivot2D.FromScale(1,1),
            Text = tostring(Thing[Property]),
            Parent = FrameOption
        }
        Stringthing.FocusEnd:Connect(function()
            Thing[Property] = Stringthing.Text

            Studio.Editor3D.PropertyChanged.Invoke(Thing,Property,Thing[Property])
            
            --print(Studio.Layout.WindowsCreated)

            Studio.Layout.WindowsCreated["Windows.Explorer"].Update() -- Change this pls :skull:
        end)
    end,
    ["boolean"] = function(FrameOption)
         Things.Create("ImageButton") {
            Size = Pivot2D.FromScale(1,1),
            Parent = FrameOption,
            Image = "Assets/Icons/Engine/boolean.png"
         }
    end,
    ["Vector3"] = function(FrameOption,Thing,Property) -- maybe a signal for when the option is changed? like u stop typing the new object name ect ect

        Things.Create("TextInput") {
            Size = Pivot2D.FromScale(1,1),
            Parent = FrameOption,
            Text = tostring(Thing[Property])
        }
        
    end,
}

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
        ForegroundColor = Color.new(1,1,1)
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

    if PropertyTypes[Type] then
        PropertyTypes[Type](Option,Thing,PropertyTxt)
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