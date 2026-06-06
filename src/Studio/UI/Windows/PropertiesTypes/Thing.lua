local Thingy = {}
local Button

function Thingy.Start(FrameOption,Thing,Property)
    local SelectionManager = Studio.Editor3D.SelectionManager

    Button = Runtime.Things.Create("TextButton") {
        Text = tostring(Thing[Property].Name),
        ForegroundColor = Studio.Theme.Text,
        BackgroundColor = Studio.Theme.Primary,
        Size = Pivot2D.FromScale(0.97,0.95),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Parent = FrameOption,
        CornerRadius=5
    }

    Button.Clicked:Connect(function() -- Someone fucked this
        if not SelectionManager.ObjectPicker then
            SelectionManager.ObjectPicker = Thing
            Runtime.Cursor.ChangeCursor("HoldingObj")

            SelectionManager.ObjectPickerEvent:ConnectOnce(function(NewThing)
                Runtime.Things.SetProperty(Thing, Property, NewThing)
                Button:SetText(Thing[Property].Name)
                
                Studio.Layout.CallHandle("Explorer", "Redraw")
            end)
        else
            SelectionManager.ObjectPicker = false
            Runtime.Cursor.ChangeCursor("Main")
        end
    end)

end

function Thingy.Update(NewVal)
    Button:SetText(tostring(NewVal.Name))
end

return Thingy