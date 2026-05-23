return function(FrameOption,Thing,Property)
    local SelectionManager = Studio.Editor3D.SelectionManager

    local Button = Runtime.Things.Create("TextButton") {
            Text = tostring(Thing[Property].Name),
            ForegroundColor = Studio.Theme.Text,
            BackgroundColor = Studio.Theme.Primary,
            Size = Pivot2D.FromScale(0.97,0.95),
            Position = Pivot2D.FromScale(0.5,0.5),
            Pivot = Vector2.new(0.5,0.5),
            Parent = FrameOption,
            CornerRadius=5
    }

    Button.Clicked:Connect(function()
        if not SelectionManager.ObjectPicker then
            SelectionManager.ObjectPicker = true

            SelectionManager.ObjectPickerEvent:ConnectOnce(function(NewThing)
                if NewThing == Thing then return end
                
                Runtime.Things.SetProperty(Thing, Property, NewThing)

                Button:SetText(Thing[Property].Name)
                Studio.Layout.GetHandle("Explorer", "Redraw")
            end)
        else
            SelectionManager.ObjectPicker = false
        end
    end)

end