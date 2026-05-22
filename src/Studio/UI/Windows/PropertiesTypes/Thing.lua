return function(FrameOption,Thing,Property)
    local CurrentGetConnect
    local Choices =  {
        {
            Type = "Button",
            Text = "Bleh",
            SubText = "Test",
            Function = function()
                print("Test")
            end
        },
        {
            Type = "Separator",
        },
         {
            Type = "Button",
            Text = "Bleh",
            SubText = "Test",
            Function = function()
                print("Test")
            end
        },
    }
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
        --[[if not Studio.Editor3D.SelectionManager.IsGetObjToPutOnVal then
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
        end]]
        Studio.Components.CreateDropdown(Button,Choices,Vector2.new(100,10),true)
    end)

end