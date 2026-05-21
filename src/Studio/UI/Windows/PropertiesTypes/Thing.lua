return function(FrameOption,Thing,Property)
    local CurrentGetConnect

    local Button = Runtime.Things.Create("TextButton") {
            Text = tostring(Thing[Property].Name),
            Size = Pivot2D.FromScale(1,1),
            BackgroundTransparency = 1,
            ForegroundColor = Studio.Theme.Text,
            Parent = FrameOption,
        }

    Button.Clicked:Connect(function()
        if not Studio.Editor3D.SelectionManager.IsGetObjToPutOnVal then
            CurrentGetConnect = Studio.Editor3D.SelectionManager.StartGrabToPutOnValue()
            
            CurrentGetConnect:Connect(function(NewThing)
                if NewThing == Thing then return end
                if Property == "Parent" then Thing:SetParent(NewThing) else Thing[Property] = NewThing end
                Button:SetText(Thing[Property].Name)
                Studio.Layout.GetHandle("Explorer", "Redraw")
                CurrentGetConnect:Destroy()
            end)
        else
            Studio.Editor3D.SelectionManager.GetObjToFalse()
        end
    end)
end