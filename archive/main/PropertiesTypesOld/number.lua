local Numbered = {}
local Stringthing
function Numbered.Start(FrameOption,Thing,Property) 
    Stringthing = Runtime.Things.Create("TextInput") {
        Size = Pivot2D.FromScale(1,1),
        Text = tostring(Thing[Property]),
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.CurrentTheme.Text2,
        Parent = FrameOption
    }

    Stringthing.FocusEnd:Connect(function()
        Runtime.Things.SetProperty(Thing,Property,tonumber(Stringthing.Text))
        --Studio.Editor3D.PropertyChanged.Invoke(Thing,Property,Thing[Property])
        
        --print(Studio.Layout.WindowsCreated)

        Studio.Layout.CallHandle("Explorer", "Redraw") -- Change this pls :skull:
    end)
end

function Numbered.Update(NewVal)
    Stringthing:SetText(tostring(NewVal))
end

return Numbered