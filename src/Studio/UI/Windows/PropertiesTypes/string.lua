local Stringed = {}
local Stringthing

function Stringed.Start(FrameOption,Thing,Property) 
    Stringthing = Runtime.Things.Create("TextInput") {
        Size = Pivot2D.FromScale(1,1),
        Text = tostring(Thing[Property]),
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text2,
        Parent = FrameOption
    }

    Stringthing.FocusEnd:Connect(function()
        --Studio.EditorServices.Undo.RegisterUndo(Thing,Property,Thing[Property])
        Thing[Property] = Stringthing.Text
        --print(Studio.Layout.WindowsCreated)

        Studio.Layout.CallHandle("Explorer", "Redraw") -- Change this pls :skull:
    end)
end

function Stringed.Update(NewVal)
    Stringthing:SetText(tostring(NewVal))
end

return Stringed