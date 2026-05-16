return function(FrameOption,Thing,Property) -- maybe a signal for when the option is changed? like u stop typing the new object name ect ect

        local VectorThing = Runtime.Things.Create("TextInput") {
            Size = Pivot2D.FromScale(1,1),
            Parent = FrameOption,
            Text = tostring(Thing[Property])
        }

        VectorThing.FocusEnd:Connect(function()
            local SplitVecText = string.split(VectorThing.Text,",")
            local RebuildVector = Vector3.new(tonumber(SplitVecText[1]),tonumber(SplitVecText[2]),tonumber(SplitVecText[3]))
            Studio.Editor3D.PropertyChanged.Invoke(Thing,Property,Thing[Property])
            Thing[Property] = RebuildVector
        end)
    end