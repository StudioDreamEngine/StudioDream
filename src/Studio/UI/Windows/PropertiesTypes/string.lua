return function(FrameOption,Thing,Property) 
    local Stringthing = Runtime.Things.Create("TextInput") {
        Size = Pivot2D.FromScale(1,1),
        Text = tostring(Thing[Property]),
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text,
        Parent = FrameOption
    }

    Stringthing.FocusEnd:Connect(function()
        Thing[Property] = Stringthing.Text
        Studio.Editor3D.PropertyChanged.Invoke(Thing,Property,Thing[Property])
        
        --print(Studio.Layout.WindowsCreated)

        Studio.Layout.WindowsCreated["Windows.Explorer"].Update() -- Change this pls :skull:
    end)
end