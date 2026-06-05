local VectorThree = {}
local VectorThing

function VectorThree.Start(FrameOption,Thing,Property) -- maybe a signal for when the option is changed? like u stop typing the new object name ect ect

    VectorThing = Runtime.Things.Create("TextInput") {
        Size = Pivot2D.FromScale(1,1),
        Text = tostring(Thing[Property]),
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text2,
        Parent = FrameOption
    }

    VectorThing.FocusEnd:Connect(function()
        local ToFilter = string.gsub(VectorThing.Text,"%a","")
        local SplitVecText = string.split(ToFilter,",")
            
        local RebuildVector = Vector3.new(tonumber(SplitVecText[1]) or 0.01,tonumber(SplitVecText[2])or 0.01,tonumber(SplitVecText[3])or 0.01)
            
        --Studio.Editor3D.PropertyChanged.Invoke(Thing,Property,Thing[Property])
        Thing[Property] = RebuildVector
        VectorThing.Text = tostring(Thing[Property])
    end)
end

function VectorThree.Update(NewVal)
    VectorThing:SetText(tostring(NewVal))
end

return VectorThree