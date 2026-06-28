local Template = {}

local SelectionManager = Studio.Editor3D.SelectionManager

local function CheckAllTheSame(table)
    local FirstVal = table[1] and table[1].Thing[table[1].Property]
    for i, Info in pairs(table) do
        if Info.Thing[Info.Property] ~= FirstVal then
            return false
        end
    end
    return true
end

function Template.Start(MainInfo)
    local self = {}

    local Button = Runtime.Things.Create("TextButton") {
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundTransparency = 0,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.Theme.GetCurrentTheme().FontBold,
        BackgroundColor = Studio.Theme.GetCurrentTheme().Primary,
        CornerRadius = 5,
    }

    Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(1,0),
        Position = Pivot2D.FromScale(1,0),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/EditorIcons/Drawable3D.png",
        Parent = Button
    }
    print(MainInfo)
    function self.Update()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)

        for i,Info in pairs(MainInfo.WillHandle) do
            print(Info)
            if AllSame then
                Button:SetText(Info.Thing[Info.Property] and Info.Thing[Info.Property].Name or "~")
            else
                Button:SetText("~")
            end
        end
    end

    self.Update()
    
    table.insert(MainInfo.Connections,Button.Clicked:Connect(function()
        for i,Info in pairs(MainInfo.WillHandle) do
            if not SelectionManager.ObjectPicker then
                SelectionManager.ObjectPicker = Info.Thing
                Runtime.Cursor.ChangeCursor("HoldingObj")

                SelectionManager.ObjectPickerEvent:ConnectOnce(function(NewThing)
                    Runtime.Things.SetProperty(Info.Thing, Info.Property, NewThing)
                    Studio.Layout.CallHandle("Explorer", "Redraw")
                end)
            else
                SelectionManager.ObjectPicker = false
                Runtime.Cursor.ChangeCursor("Main")
            end
        end
    end))

    return self
end

return Template